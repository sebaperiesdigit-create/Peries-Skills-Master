"""Data definitions for work-hours-log-automation. No I/O here."""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import date, time
from enum import Enum
from typing import Optional


class DayType(str, Enum):
    WEEKEND_HOLIDAY = "Weekend Holiday"
    COMPANY_HOLIDAY = "Company Holiday"
    WORKING_DAY = "Working Day"


class EmployeeStatus(str, Enum):
    PRESENT = "Present"
    LEAVE = "Leave"


class DataSource(str, Enum):
    MANUAL = "Manual"
    CSV_IMPORT = "CSV Import"


class ReviewStatus(str, Enum):
    OK = "OK"
    NEEDS_SUPERVISOR_REVIEW = "Needs Supervisor Review"


@dataclass
class Employee:
    employee_id: str
    employee_name: str
    department: str
    shift_start: time
    shift_end: time
    active: bool = True


@dataclass
class AttendanceRecord:
    work_date: date
    employee_id: str
    arrival_time: Optional[time]
    departure_time: Optional[time]
    employee_status: EmployeeStatus
    data_source: DataSource
    notes: str = ""


@dataclass
class CalculatedRow:
    work_date: date
    employee_id: str
    employee_name: str
    department: str
    day_type: DayType
    employee_status: EmployeeStatus
    arrival_time: Optional[time]
    departure_time: Optional[time]
    gross_hours: Optional[float]
    break_hours: Optional[float]
    confirmed_hours: Optional[float]
    expected_hours: float
    late_arrival: bool
    early_departure: bool
    review_status: ReviewStatus


@dataclass
class SummaryTables:
    daily: list = field(default_factory=list)
    weekly: list = field(default_factory=list)
    monthly: list = field(default_factory=list)
