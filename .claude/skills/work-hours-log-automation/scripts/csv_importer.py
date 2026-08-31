"""Generic CSV import with a runtime-confirmed column mapping.

No biometric-device format is assumed or hardcoded. The mapping (which real CSV
column corresponds to each internal field) always comes from a mapping JSON that
was confirmed with the user at runtime — this module never guesses a mapping.
"""

from __future__ import annotations

import csv
import json
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Tuple

from models import AttendanceRecord, DataSource, EmployeeStatus
from employee_master import EmployeeMaster

REQUIRED_FIELDS = ("employeeId", "workDate", "arrivalTime", "departureTime")
OPTIONAL_FIELDS = ("employeeStatus",)


class CsvImporter:
    def __init__(self, column_mapping: Dict[str, str], date_format: str, time_format: str):
        missing = [f for f in REQUIRED_FIELDS if f not in column_mapping]
        if missing:
            raise ValueError(f"Column mapping is missing required field(s): {missing}")
        self.column_mapping = column_mapping
        self.date_format = date_format
        self.time_format = time_format

    @classmethod
    def load_mapping(cls, path: Path) -> "CsvImporter":
        data = json.loads(path.read_text(encoding="utf-8"))
        return cls(
            column_mapping=data["columnMapping"],
            date_format=data.get("dateFormat", "%Y-%m-%d"),
            time_format=data.get("timeFormat", "%H:%M"),
        )

    @staticmethod
    def detect_header(csv_path: Path) -> List[str]:
        """Read-only header preview — used before any mapping exists, to decide
        whether the caller needs to ask the user to confirm a column mapping."""
        with csv_path.open("r", encoding="utf-8-sig", newline="") as f:
            reader = csv.reader(f)
            try:
                return next(reader)
            except StopIteration:
                return []

    def import_rows(
        self, csv_path: Path, employee_master: EmployeeMaster
    ) -> Tuple[List[AttendanceRecord], List[str]]:
        records: List[AttendanceRecord] = []
        warnings: List[str] = []
        seen_keys = set()

        with csv_path.open("r", encoding="utf-8-sig", newline="") as f:
            reader = csv.DictReader(f)
            for line_num, row in enumerate(reader, start=2):  # header is line 1
                emp_col = self.column_mapping["employeeId"]
                date_col = self.column_mapping["workDate"]
                arrival_col = self.column_mapping["arrivalTime"]
                departure_col = self.column_mapping["departureTime"]
                status_col = self.column_mapping.get("employeeStatus")

                raw_employee_id = (row.get(emp_col) or "").strip()
                raw_date = (row.get(date_col) or "").strip()
                raw_arrival = (row.get(arrival_col) or "").strip()
                raw_departure = (row.get(departure_col) or "").strip()
                raw_status = (row.get(status_col) or "").strip() if status_col else ""

                if not raw_employee_id:
                    warnings.append(f"line {line_num}: blank employee ID, row skipped")
                    continue
                try:
                    employee_master.get(raw_employee_id)
                except KeyError:
                    warnings.append(
                        f"line {line_num}: employee ID {raw_employee_id!r} not found in "
                        "employee master, row skipped"
                    )
                    continue

                try:
                    work_date = datetime.strptime(raw_date, self.date_format).date()
                except ValueError:
                    warnings.append(
                        f"line {line_num}: work date {raw_date!r} did not match format "
                        f"{self.date_format!r}, row skipped"
                    )
                    continue

                key = (raw_employee_id, work_date)
                if key in seen_keys:
                    warnings.append(
                        f"line {line_num}: duplicate row for employee {raw_employee_id!r} "
                        f"on {work_date}, row skipped"
                    )
                    continue
                seen_keys.add(key)

                arrival_time = None
                if raw_arrival:
                    try:
                        arrival_time = datetime.strptime(raw_arrival, self.time_format).time()
                    except ValueError:
                        warnings.append(
                            f"line {line_num}: arrival time {raw_arrival!r} did not match "
                            f"format {self.time_format!r}, treated as missing"
                        )

                departure_time = None
                if raw_departure:
                    try:
                        departure_time = datetime.strptime(raw_departure, self.time_format).time()
                    except ValueError:
                        warnings.append(
                            f"line {line_num}: departure time {raw_departure!r} did not "
                            f"match format {self.time_format!r}, treated as missing"
                        )

                status = EmployeeStatus.PRESENT
                if raw_status.strip().lower() == "leave":
                    status = EmployeeStatus.LEAVE

                records.append(
                    AttendanceRecord(
                        work_date=work_date,
                        employee_id=raw_employee_id,
                        arrival_time=arrival_time,
                        departure_time=departure_time,
                        employee_status=status,
                        data_source=DataSource.CSV_IMPORT,
                        notes="",
                    )
                )

        return records, warnings
