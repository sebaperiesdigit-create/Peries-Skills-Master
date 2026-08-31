"""Loads the company-holiday list and classifies a date's Day Type.

Precedence (never configurable, per business-rules.md): Weekend Holiday always wins,
then a configured Company Holiday, then Working Day.
"""

from __future__ import annotations

import json
from datetime import date, datetime
from pathlib import Path
from typing import Dict

from models import DayType


class HolidayCalendar:
    def __init__(self, holiday_dates: Dict[date, str]):
        self._holiday_dates = holiday_dates

    @classmethod
    def load(cls, path: Path) -> "HolidayCalendar":
        if not path.exists():
            raise FileNotFoundError(f"Company holiday config not found: {path}")
        data = json.loads(path.read_text(encoding="utf-8"))
        holidays: Dict[date, str] = {}
        for row in data.get("holidays", []):
            d = datetime.strptime(row["date"], "%Y-%m-%d").date()
            holidays[d] = row.get("name", "")
        return cls(holidays)

    def day_type(self, d: date) -> DayType:
        if d.weekday() >= 5:  # Saturday=5, Sunday=6
            return DayType.WEEKEND_HOLIDAY
        if d in self._holiday_dates:
            return DayType.COMPANY_HOLIDAY
        return DayType.WORKING_DAY

    def holiday_name(self, d: date) -> str:
        return self._holiday_dates.get(d, "")
