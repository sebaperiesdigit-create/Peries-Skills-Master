"""Period-lock and audit-log control for work-hours-log-automation.

This is this skill's own, fully independent mechanism: its own lock-state file,
its own append-only audit log, its own override gate. It is a self-attestation
and audit-log control, not a real authorization/access-control system — there is
no identity backend here to verify a name against. Say so plainly if asked.
"""

from __future__ import annotations

import json
from datetime import datetime
from pathlib import Path
from typing import Optional


class LockedPeriodError(Exception):
    """Raised when a write is attempted against a locked month with no valid override."""


class PeriodLockManager:
    def __init__(self, lock_state_path: Path, audit_log_path: Path):
        self.lock_state_path = Path(lock_state_path)
        self.audit_log_path = Path(audit_log_path)

    def _read_state(self) -> dict:
        if not self.lock_state_path.exists():
            return {"lockedMonths": {}}
        return json.loads(self.lock_state_path.read_text(encoding="utf-8"))

    def _write_state(self, state: dict) -> None:
        self.lock_state_path.parent.mkdir(parents=True, exist_ok=True)
        self.lock_state_path.write_text(
            json.dumps(state, indent=2, sort_keys=True), encoding="utf-8"
        )

    def is_locked(self, month: str) -> bool:
        state = self._read_state()
        return month in state.get("lockedMonths", {})

    def lock(self, month: str, locked_by: str) -> None:
        state = self._read_state()
        state.setdefault("lockedMonths", {})[month] = {
            "lockedAt": datetime.now().astimezone().isoformat(timespec="seconds"),
            "lockedBy": locked_by,
        }
        self._write_state(state)

    def unlock(self, month: str) -> None:
        state = self._read_state()
        state.get("lockedMonths", {}).pop(month, None)
        self._write_state(state)

    def require_override_if_locked(
        self,
        month: str,
        override_name: Optional[str],
        override_reason: Optional[str],
    ) -> bool:
        """Read-only check: returns True if the month is locked and a valid override
        was supplied (caller must still call record_override_audit itself, and only
        for a real write — never for a --dry-run). Raises LockedPeriodError if the
        month is locked and no valid override was supplied. Never writes anything."""
        if not self.is_locked(month):
            return False
        if not override_name or not override_reason:
            raise LockedPeriodError(
                f"Month {month!r} is locked. Provide --override-name and "
                "--override-reason to write anyway."
            )
        return True

    def record_override_audit(self, month: str, name: str, reason: str, action: str) -> None:
        self.audit_log_path.parent.mkdir(parents=True, exist_ok=True)
        timestamp = datetime.now().astimezone().isoformat(timespec="seconds")
        entry = (
            f"## {timestamp}\n"
            f"- Month: {month}\n"
            f"- Overridden by: {name}\n"
            f"- Reason: {reason}\n"
            f"- Action: {action} on locked period {month}\n\n"
        )
        with self.audit_log_path.open("a", encoding="utf-8") as f:
            f.write(entry)
