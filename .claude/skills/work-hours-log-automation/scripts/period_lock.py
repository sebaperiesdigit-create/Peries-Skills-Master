"""Period-lock control for work-hours-log-automation.

This is this skill's own, fully independent mechanism: its own lock-state
file, its own override gate. It is a self-attestation control, not a real
authorization/access-control system — there is no identity backend here to
verify a name against. Say so plainly if asked.

This module only validates lock state — it never writes the audit log itself.
Every save (routine or override) is logged once, uniformly, by cli.py via
audit_log.append_entry(), so there is exactly one audit entry per save
regardless of whether it was an override.
"""

from __future__ import annotations

import json
from datetime import datetime
from pathlib import Path
from typing import Optional


class LockedPeriodError(Exception):
    """Raised when a write is attempted against a locked month with no valid override."""


class PeriodLockManager:
    def __init__(self, lock_state_path: Path):
        self.lock_state_path = Path(lock_state_path)

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
        was supplied. Raises LockedPeriodError if the month is locked and no valid
        override was supplied. Never writes anything."""
        if not self.is_locked(month):
            return False
        if not override_name or not override_reason:
            raise LockedPeriodError(
                f"Month {month!r} is locked. Provide --override-name and "
                "--override-reason to write anyway."
            )
        return True
