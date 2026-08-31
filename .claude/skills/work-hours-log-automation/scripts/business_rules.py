"""The one place the business rules from references/business-rules.md are encoded.

Overnight shifts (departure time earlier than arrival time) are not supported in
this version — such a row is treated as a data-quality issue and flagged for
supervisor review rather than guessed. See references/business-rules.md.
"""

from __future__ import annotations

from datetime import date, datetime, time, timedelta
from typing import Dict, List, Tuple

from models import (
    AttendanceRecord,
    CalculatedRow,
    DayType,
    Employee,
    EmployeeStatus,
    ReviewStatus,
    SummaryTables,
)
from employee_master import EmployeeMaster
from holiday_calendar import HolidayCalendar

BREAK_HOURS = 1.0


def _hours_between(t1: time, t2: time) -> float:
    d1 = datetime.combine(date.min, t1)
    d2 = datetime.combine(date.min, t2)
    return (d2 - d1).total_seconds() / 3600.0


def _week_start(d: date) -> date:
    return d - timedelta(days=d.weekday())  # Monday


class BusinessRulesEngine:
    def __init__(self, holiday_calendar: HolidayCalendar):
        self.holiday_calendar = holiday_calendar

    def calculate(self, record: AttendanceRecord, employee: Employee) -> CalculatedRow:
        day_type = self.holiday_calendar.day_type(record.work_date)
        expected_hours = round(_hours_between(employee.shift_start, employee.shift_end), 2)

        gross_hours = None
        break_hours = None
        confirmed_hours = None
        late_arrival = False
        early_departure = False
        review_status = ReviewStatus.OK

        if day_type != DayType.WORKING_DAY:
            pass  # holiday/weekend: no scan expected, nothing to review
        elif record.employee_status == EmployeeStatus.LEAVE:
            pass  # an expected absence, not a review flag
        elif record.arrival_time is None or record.departure_time is None:
            review_status = ReviewStatus.NEEDS_SUPERVISOR_REVIEW
        elif record.departure_time <= record.arrival_time:
            # Overnight/invalid scan pair — not supported, flag rather than guess.
            review_status = ReviewStatus.NEEDS_SUPERVISOR_REVIEW
        else:
            gross_hours = round(_hours_between(record.arrival_time, record.departure_time), 2)
            break_hours = BREAK_HOURS
            confirmed_hours = round(gross_hours - BREAK_HOURS, 2)
            late_arrival = record.arrival_time > employee.shift_start
            early_departure = record.departure_time < employee.shift_end

        return CalculatedRow(
            work_date=record.work_date,
            employee_id=employee.employee_id,
            employee_name=employee.employee_name,
            department=employee.department,
            day_type=day_type,
            employee_status=record.employee_status,
            arrival_time=record.arrival_time,
            departure_time=record.departure_time,
            gross_hours=gross_hours,
            break_hours=break_hours,
            confirmed_hours=confirmed_hours,
            expected_hours=expected_hours,
            late_arrival=late_arrival,
            early_departure=early_departure,
            review_status=review_status,
        )

    def summarize(
        self, rows: List[CalculatedRow], employee_master: EmployeeMaster
    ) -> SummaryTables:
        daily = []
        weekly_totals: Dict[Tuple[str, date], float] = {}
        monthly_totals: Dict[Tuple[str, str], float] = {}

        for row in rows:
            if row.confirmed_hours is None:
                continue

            daily.append(
                {
                    "employeeId": row.employee_id,
                    "employeeName": row.employee_name,
                    "workDate": row.work_date,
                    "dailyWorkHours": row.confirmed_hours,
                }
            )

            wk_key = (row.employee_id, _week_start(row.work_date))
            weekly_totals[wk_key] = weekly_totals.get(wk_key, 0.0) + row.confirmed_hours

            mo_key = (row.employee_id, row.work_date.strftime("%Y-%m"))
            monthly_totals[mo_key] = monthly_totals.get(mo_key, 0.0) + row.confirmed_hours

        weekly = []
        for (employee_id, week_start), total in sorted(weekly_totals.items()):
            weekly.append(
                {
                    "employeeId": employee_id,
                    "employeeName": employee_master.get(employee_id).employee_name,
                    "weekStart": week_start,
                    "weekEnd": week_start + timedelta(days=6),
                    "weeklyWorkHours": round(total, 2),
                }
            )

        monthly = []
        for (employee_id, month), total in sorted(monthly_totals.items()):
            monthly.append(
                {
                    "employeeId": employee_id,
                    "employeeName": employee_master.get(employee_id).employee_name,
                    "month": month,
                    "monthlyWorkHours": round(total, 2),
                }
            )

        return SummaryTables(daily=daily, weekly=weekly, monthly=monthly)
