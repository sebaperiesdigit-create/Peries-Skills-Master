"""Shared append-only audit-log writer. Every real save and every locked-period
override goes through here, so there is exactly one entry format, one file,
and one append-only guarantee for this skill's entire audit trail.
"""

from __future__ import annotations

from datetime import datetime
from pathlib import Path
from typing import Mapping


def append_entry(audit_log_path: Path, fields: Mapping[str, str]) -> None:
    audit_log_path.parent.mkdir(parents=True, exist_ok=True)
    timestamp = datetime.now().astimezone().isoformat(timespec="seconds")
    lines = [f"## {timestamp}"]
    for key, value in fields.items():
        lines.append(f"- {key}: {value}")
    lines.append("")
    with audit_log_path.open("a", encoding="utf-8") as f:
        f.write("\n".join(lines) + "\n\n")
