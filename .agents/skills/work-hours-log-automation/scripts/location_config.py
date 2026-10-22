"""Remembers which folder on disk holds this skill's config/workbooks/audit log.

The base folder is user-chosen and can be anywhere on disk, including outside
this repo — so it is never git-tracked and never assumed. What IS fixed and
git-ignored is a tiny pointer file, machine-local, that records the chosen
path so the user is never asked twice. This is this skill's own mechanism —
no shared code or file format with any other skill's local-state pattern.
"""

from __future__ import annotations

import json
import os
from pathlib import Path
from typing import Optional


def _pointer_path() -> Path:
    local_app_data = os.environ.get("LOCALAPPDATA")
    if local_app_data:
        base = Path(local_app_data)
    else:
        base = Path.home() / ".config"
    return base / "work-hours-log-automation" / "location.json"


class LocationConfig:
    def __init__(self, pointer_path: Optional[Path] = None):
        self.pointer_path = pointer_path or _pointer_path()

    def load(self) -> Optional[Path]:
        if not self.pointer_path.exists():
            return None
        data = json.loads(self.pointer_path.read_text(encoding="utf-8"))
        base_folder = data.get("baseFolder")
        return Path(base_folder) if base_folder else None

    def save(self, base_folder: Path) -> None:
        base_folder = Path(base_folder)
        self.pointer_path.parent.mkdir(parents=True, exist_ok=True)
        self.pointer_path.write_text(
            json.dumps({"baseFolder": str(base_folder)}, indent=2), encoding="utf-8"
        )

    @staticmethod
    def derive_paths(base_folder: Path) -> dict:
        base_folder = Path(base_folder)
        return {
            "employeeMaster": base_folder / "_config" / "employee-master.json",
            "companyHolidays": base_folder / "_config" / "company-holidays.json",
            "lockState": base_folder / "_config" / "period-lock.json",
            "workbookDir": base_folder / "workbooks",
            "auditLog": base_folder / "_audit-log.md",
        }
