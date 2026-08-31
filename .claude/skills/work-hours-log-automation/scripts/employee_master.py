"""Loads and validates the employee master config. No skill/company/department name
is hardcoded anywhere in this module — every value comes from the JSON file."""

from __future__ import annotations

import json
from datetime import datetime, time
from pathlib import Path
from typing import Dict, List

from models import Employee


def _parse_hhmm(value: str, field_name: str, employee_id: str) -> time:
    try:
        return datetime.strptime(value, "%H:%M").time()
    except ValueError as exc:
        raise ValueError(
            f"employee {employee_id!r}: {field_name} {value!r} is not HH:MM 24-hour format"
        ) from exc


class EmployeeMaster:
    def __init__(self, employees: Dict[str, Employee]):
        self._employees = employees

    @classmethod
    def load(cls, path: Path) -> "EmployeeMaster":
        if not path.exists():
            raise FileNotFoundError(f"Employee master config not found: {path}")
        data = json.loads(path.read_text(encoding="utf-8"))
        employees: Dict[str, Employee] = {}
        for row in data.get("employees", []):
            emp_id = row["employeeId"]
            employees[emp_id] = Employee(
                employee_id=emp_id,
                employee_name=row["employeeName"],
                department=row["department"],
                shift_start=_parse_hhmm(row["shiftStart"], "shiftStart", emp_id),
                shift_end=_parse_hhmm(row["shiftEnd"], "shiftEnd", emp_id),
                active=bool(row.get("active", True)),
            )
        instance = cls(employees)
        errors = instance.validate()
        if errors:
            raise ValueError("Employee master validation failed:\n" + "\n".join(errors))
        return instance

    def get(self, employee_id: str) -> Employee:
        try:
            return self._employees[employee_id]
        except KeyError as exc:
            raise KeyError(
                f"Employee ID {employee_id!r} not found in employee master"
            ) from exc

    def all_active(self) -> List[Employee]:
        return [e for e in self._employees.values() if e.active]

    def all(self) -> List[Employee]:
        return list(self._employees.values())

    def validate(self) -> List[str]:
        errors: List[str] = []
        seen_ids = set()
        for emp_id, emp in self._employees.items():
            if not emp_id.strip():
                errors.append("Found an employee with a blank employeeId")
            if emp_id in seen_ids:
                errors.append(f"Duplicate employeeId: {emp_id!r}")
            seen_ids.add(emp_id)
            if not emp.employee_name.strip():
                errors.append(f"employee {emp_id!r}: employeeName is blank")
            if not emp.department.strip():
                errors.append(f"employee {emp_id!r}: department is blank")
        return errors
