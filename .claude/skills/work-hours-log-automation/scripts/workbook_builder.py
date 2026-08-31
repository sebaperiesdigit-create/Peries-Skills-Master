"""Builds/updates the 3-sheet monthly work-hours workbook with openpyxl.

Sheet 1 (Attendance Log) is the only sheet ever hand-edited (via upsert — existing
Arrival/Departure values are never blanked by an incoming record that doesn't
supply them). Sheets 2 and 3 are fully derived: every call clears and rewrites
them from Sheet 1's current contents, so they can never drift out of sync.
"""

from __future__ import annotations

import shutil
from dataclasses import dataclass, field
from datetime import date, datetime, time
from pathlib import Path
from typing import Dict, List, Optional, Tuple

from openpyxl import Workbook, load_workbook
from openpyxl.styles import Font
from openpyxl.worksheet.worksheet import Worksheet

from models import (
    AttendanceRecord,
    CalculatedRow,
    DataSource,
    DayType,
    EmployeeStatus,
    ReviewStatus,
    SummaryTables,
)
from employee_master import EmployeeMaster
from holiday_calendar import HolidayCalendar
from business_rules import BusinessRulesEngine

SHEET_ATTENDANCE = "Attendance Log"
SHEET_CALCULATION = "Work Hours Calculation"
SHEET_SUMMARY = "Summary Report"

ATTENDANCE_HEADERS = (
    "Work Date", "Day Type", "Employee ID", "Employee Name", "Department",
    "Shift Start", "Shift End", "Arrival Time", "Departure Time",
    "Employee Status", "Data Source", "Review Status", "Notes",
)

CALCULATION_HEADERS = (
    "Work Date", "Employee ID", "Employee Name", "Day Type", "Employee Status",
    "Arrival Time", "Departure Time", "Gross Hours", "Break Hours",
    "Confirmed Work Hours", "Expected Hours", "Late Arrival", "Early Departure",
    "Review Status",
)

DAILY_HEADERS = ("Employee ID", "Employee Name", "Work Date", "Daily Work Hours")
WEEKLY_HEADERS = ("Employee ID", "Employee Name", "Week Start", "Week End", "Weekly Work Hours")
MONTHLY_HEADERS = ("Employee ID", "Employee Name", "Month", "Monthly Work Hours")


@dataclass
class UpsertResult:
    added: int = 0
    updated: int = 0
    preserved_unchanged: int = 0
    touched: List[Tuple[str, str]] = field(default_factory=list)
    warnings: List[str] = field(default_factory=list)


def _write_header(ws: Worksheet, headers: Tuple[str, ...]) -> None:
    for col_idx, header in enumerate(headers, start=1):
        cell = ws.cell(row=1, column=col_idx, value=header)
        cell.font = Font(bold=True)
    ws.freeze_panes = "A2"


def _col_index(headers: Tuple[str, ...], name: str) -> int:
    return headers.index(name) + 1  # 1-based for openpyxl


def _time_or_none(value) -> Optional[time]:
    if value is None or value == "":
        return None
    if isinstance(value, time):
        return value
    if isinstance(value, datetime):
        return value.time()
    return None


def _date_or_none(value) -> Optional[date]:
    if value is None or value == "":
        return None
    if isinstance(value, date) and not isinstance(value, datetime):
        return value
    if isinstance(value, datetime):
        return value.date()
    return None


class WorkbookBuilder:
    def __init__(self, workbook_path: Path):
        self.workbook_path = Path(workbook_path)
        self._wb: Optional[Workbook] = None

    def load_or_create(self) -> None:
        if self.workbook_path.exists():
            self._wb = load_workbook(str(self.workbook_path))
            for name, headers in (
                (SHEET_ATTENDANCE, ATTENDANCE_HEADERS),
                (SHEET_CALCULATION, CALCULATION_HEADERS),
                (SHEET_SUMMARY, None),
            ):
                if name not in self._wb.sheetnames:
                    ws = self._wb.create_sheet(name)
                    if headers:
                        _write_header(ws, headers)
        else:
            self._wb = Workbook()
            default_sheet = self._wb.active
            self._wb.remove(default_sheet)
            _write_header(self._wb.create_sheet(SHEET_ATTENDANCE), ATTENDANCE_HEADERS)
            _write_header(self._wb.create_sheet(SHEET_CALCULATION), CALCULATION_HEADERS)
            self._wb.create_sheet(SHEET_SUMMARY)  # headers written per-table in rebuild_summary_sheet

    # ---- Sheet 1: Attendance Log ------------------------------------------------

    def _read_attendance_index(self) -> Dict[Tuple[str, str], int]:
        """Returns {(work_date_iso, employee_id): row_number} for existing rows."""
        ws = self._wb[SHEET_ATTENDANCE]
        date_col = _col_index(ATTENDANCE_HEADERS, "Work Date")
        id_col = _col_index(ATTENDANCE_HEADERS, "Employee ID")
        index: Dict[Tuple[str, str], int] = {}
        for row_num in range(2, ws.max_row + 1):
            d = _date_or_none(ws.cell(row=row_num, column=date_col).value)
            emp_id = ws.cell(row=row_num, column=id_col).value
            if d is None or not emp_id:
                continue
            index[(d.isoformat(), str(emp_id))] = row_num
        return index

    def upsert_attendance_rows(
        self,
        records: List[AttendanceRecord],
        employee_master: EmployeeMaster,
        holiday_calendar: HolidayCalendar,
    ) -> UpsertResult:
        ws = self._wb[SHEET_ATTENDANCE]
        result = UpsertResult()
        index = self._read_attendance_index()

        col = {name: _col_index(ATTENDANCE_HEADERS, name) for name in ATTENDANCE_HEADERS}

        for record in records:
            try:
                employee = employee_master.get(record.employee_id)
            except KeyError as exc:
                result.warnings.append(str(exc))
                continue

            key = (record.work_date.isoformat(), record.employee_id)
            day_type = holiday_calendar.day_type(record.work_date)

            if key in index:
                row_num = index[key]
                if record.arrival_time is not None:
                    ws.cell(row=row_num, column=col["Arrival Time"], value=record.arrival_time)
                if record.departure_time is not None:
                    ws.cell(row=row_num, column=col["Departure Time"], value=record.departure_time)
                ws.cell(row=row_num, column=col["Employee Status"], value=record.employee_status.value)
                ws.cell(row=row_num, column=col["Data Source"], value=record.data_source.value)
                if record.notes:
                    ws.cell(row=row_num, column=col["Notes"], value=record.notes)
                ws.cell(row=row_num, column=col["Day Type"], value=day_type.value)
                result.updated += 1
                result.touched.append(key)
            else:
                row_num = ws.max_row + 1
                ws.cell(row=row_num, column=col["Work Date"], value=record.work_date)
                ws.cell(row=row_num, column=col["Day Type"], value=day_type.value)
                ws.cell(row=row_num, column=col["Employee ID"], value=employee.employee_id)
                ws.cell(row=row_num, column=col["Employee Name"], value=employee.employee_name)
                ws.cell(row=row_num, column=col["Department"], value=employee.department)
                ws.cell(row=row_num, column=col["Shift Start"], value=employee.shift_start)
                ws.cell(row=row_num, column=col["Shift End"], value=employee.shift_end)
                if record.arrival_time is not None:
                    ws.cell(row=row_num, column=col["Arrival Time"], value=record.arrival_time)
                if record.departure_time is not None:
                    ws.cell(row=row_num, column=col["Departure Time"], value=record.departure_time)
                ws.cell(row=row_num, column=col["Employee Status"], value=record.employee_status.value)
                ws.cell(row=row_num, column=col["Data Source"], value=record.data_source.value)
                ws.cell(row=row_num, column=col["Review Status"], value=ReviewStatus.OK.value)
                if record.notes:
                    ws.cell(row=row_num, column=col["Notes"], value=record.notes)
                index[key] = row_num
                result.added += 1
                result.touched.append(key)

        return result

    def read_all_attendance_records(self) -> List[AttendanceRecord]:
        """Reconstructs AttendanceRecords from Sheet 1's current contents, used to
        rebuild the derived sheets from source."""
        ws = self._wb[SHEET_ATTENDANCE]
        col = {name: _col_index(ATTENDANCE_HEADERS, name) for name in ATTENDANCE_HEADERS}
        records: List[AttendanceRecord] = []
        for row_num in range(2, ws.max_row + 1):
            work_date = _date_or_none(ws.cell(row=row_num, column=col["Work Date"]).value)
            employee_id = ws.cell(row=row_num, column=col["Employee ID"]).value
            if work_date is None or not employee_id:
                continue
            status_raw = ws.cell(row=row_num, column=col["Employee Status"]).value
            status = EmployeeStatus.LEAVE if status_raw == EmployeeStatus.LEAVE.value else EmployeeStatus.PRESENT
            source_raw = ws.cell(row=row_num, column=col["Data Source"]).value
            source = DataSource.CSV_IMPORT if source_raw == DataSource.CSV_IMPORT.value else DataSource.MANUAL
            records.append(
                AttendanceRecord(
                    work_date=work_date,
                    employee_id=str(employee_id),
                    arrival_time=_time_or_none(ws.cell(row=row_num, column=col["Arrival Time"]).value),
                    departure_time=_time_or_none(ws.cell(row=row_num, column=col["Departure Time"]).value),
                    employee_status=status,
                    data_source=source,
                    notes=ws.cell(row=row_num, column=col["Notes"]).value or "",
                )
            )
        return records

    def _sync_review_status_to_attendance(self, calculated_rows: List[CalculatedRow]) -> None:
        ws = self._wb[SHEET_ATTENDANCE]
        index = self._read_attendance_index()
        col = _col_index(ATTENDANCE_HEADERS, "Review Status")
        for row in calculated_rows:
            key = (row.work_date.isoformat(), row.employee_id)
            if key in index:
                ws.cell(row=index[key], column=col, value=row.review_status.value)

    # ---- Sheet 2: Work Hours Calculation (derived, always rebuilt) --------------

    def rebuild_calculation_sheet(
        self, engine: BusinessRulesEngine, employee_master: EmployeeMaster
    ) -> List[CalculatedRow]:
        ws = self._wb[SHEET_CALCULATION]
        ws.delete_rows(2, ws.max_row)  # keep header, clear all data rows
        if ws.max_row == 1 and ws.cell(row=1, column=1).value != CALCULATION_HEADERS[0]:
            _write_header(ws, CALCULATION_HEADERS)

        source_records = self.read_all_attendance_records()
        calculated: List[CalculatedRow] = []
        for record in source_records:
            try:
                employee = employee_master.get(record.employee_id)
            except KeyError:
                continue  # already warned about at upsert time
            calculated.append(engine.calculate(record, employee))

        calculated.sort(key=lambda r: (r.work_date, r.employee_id))

        col = {name: _col_index(CALCULATION_HEADERS, name) for name in CALCULATION_HEADERS}
        for offset, row in enumerate(calculated, start=2):
            ws.cell(row=offset, column=col["Work Date"], value=row.work_date)
            ws.cell(row=offset, column=col["Employee ID"], value=row.employee_id)
            ws.cell(row=offset, column=col["Employee Name"], value=row.employee_name)
            ws.cell(row=offset, column=col["Day Type"], value=row.day_type.value)
            ws.cell(row=offset, column=col["Employee Status"], value=row.employee_status.value)
            ws.cell(row=offset, column=col["Arrival Time"], value=row.arrival_time)
            ws.cell(row=offset, column=col["Departure Time"], value=row.departure_time)
            ws.cell(row=offset, column=col["Gross Hours"], value=row.gross_hours)
            ws.cell(row=offset, column=col["Break Hours"], value=row.break_hours)
            ws.cell(row=offset, column=col["Confirmed Work Hours"], value=row.confirmed_hours)
            ws.cell(row=offset, column=col["Expected Hours"], value=row.expected_hours)
            ws.cell(row=offset, column=col["Late Arrival"], value=row.late_arrival)
            ws.cell(row=offset, column=col["Early Departure"], value=row.early_departure)
            ws.cell(row=offset, column=col["Review Status"], value=row.review_status.value)

        self._sync_review_status_to_attendance(calculated)
        return calculated

    # ---- Sheet 3: Summary Report (derived, always rebuilt) ----------------------

    def rebuild_summary_sheet(self, summary_tables: SummaryTables) -> None:
        ws = self._wb[SHEET_SUMMARY]
        for row in list(ws.iter_rows()):
            for cell in row:
                cell.value = None

        row_num = 1
        row_num = self._write_summary_table(ws, row_num, "Daily Totals", DAILY_HEADERS, [
            (r["employeeId"], r["employeeName"], r["workDate"], r["dailyWorkHours"])
            for r in summary_tables.daily
        ])
        row_num += 1
        row_num = self._write_summary_table(ws, row_num, "Weekly Totals", WEEKLY_HEADERS, [
            (r["employeeId"], r["employeeName"], r["weekStart"], r["weekEnd"], r["weeklyWorkHours"])
            for r in summary_tables.weekly
        ])
        row_num += 1
        self._write_summary_table(ws, row_num, "Monthly Totals", MONTHLY_HEADERS, [
            (r["employeeId"], r["employeeName"], r["month"], r["monthlyWorkHours"])
            for r in summary_tables.monthly
        ])

    @staticmethod
    def _write_summary_table(
        ws: Worksheet, start_row: int, title: str, headers: Tuple[str, ...], rows: List[tuple]
    ) -> int:
        title_cell = ws.cell(row=start_row, column=1, value=title)
        title_cell.font = Font(bold=True)
        header_row = start_row + 1
        for col_idx, header in enumerate(headers, start=1):
            cell = ws.cell(row=header_row, column=col_idx, value=header)
            cell.font = Font(bold=True)
        data_row = header_row + 1
        for values in rows:
            for col_idx, value in enumerate(values, start=1):
                ws.cell(row=data_row, column=col_idx, value=value)
            data_row += 1
        return data_row  # first free row after this table

    # ---- Backup + save -----------------------------------------------------------

    def backup_if_exists(self, backup_dir: Path) -> Optional[Path]:
        if not self.workbook_path.exists():
            return None
        backup_dir.mkdir(parents=True, exist_ok=True)
        timestamp = datetime.now().strftime("%Y%m%dT%H%M%S")
        backup_path = backup_dir / f"{self.workbook_path.stem}__backup-{timestamp}.xlsx"
        shutil.copy2(self.workbook_path, backup_path)
        return backup_path

    def save(self) -> None:
        self.workbook_path.parent.mkdir(parents=True, exist_ok=True)
        self._wb.save(str(self.workbook_path))
