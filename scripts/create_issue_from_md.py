#!/usr/bin/env python3

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path
from typing import Iterable, List


def find_issue_file(explicit: str | None, issues_dir: Path, root_dir: Path) -> Path:
  if explicit:
    candidate = Path(explicit)
    if not candidate.is_absolute():
      candidate = (root_dir / candidate).resolve()
    if not candidate.is_file():
      raise FileNotFoundError(f"Issue file not found: {candidate}")
    return candidate

  files = sorted(
    issues_dir.glob("*.md"),
    key=lambda p: p.stat().st_mtime,
    reverse=True,
  )
  if not files:
    raise FileNotFoundError(f"No markdown files found in {issues_dir}")
  return files[0]


def read_front_matter(lines: List[str]) -> List[str]:
  front_matter: List[str] = []
  delimiter_count = 0

  for line in lines:
    if line.strip() == "---":
      delimiter_count += 1
      if delimiter_count == 2:
        break
      continue
    if delimiter_count == 1:
      front_matter.append(line.rstrip("\n"))

  return front_matter


def parse_title(front_matter: Iterable[str]) -> str:
  for line in front_matter:
    if line.startswith("title:"):
      value = line.split(":", 1)[1].strip()
      return value.strip('"').strip("'")
  raise ValueError("Missing title: line in front matter")


def parse_labels(front_matter: List[str]) -> List[str]:
  labels: List[str] = []
  collecting_list = False

  for line in front_matter:
    stripped = line.strip()
    if stripped.startswith("- "):
      if collecting_list:
        label = stripped[2:].strip().strip('"').strip("'")
        if label:
          labels.append(label)
      continue

    if ":" not in line:
      continue

    key, value = line.split(":", 1)
    key = key.strip()
    value = value.strip()
    collecting_list = key == "labels" and value == ""

    if key != "labels":
      continue

    if value.startswith("[") and value.endswith("]"):
      inside = value.strip("[] ")
      if inside:
        labels = [
          item.strip().strip('"').strip("'")
          for item in inside.split(",")
          if item.strip()
        ]
      else:
        labels = []
    elif value:
      labels = [value.strip().strip('"').strip("'")]
    else:
      labels = []  # will be populated by list items

  return labels


def extract_body(lines: List[str]) -> str:
  delimiter_count = 0
  for idx, line in enumerate(lines):
    if line.strip() == "---":
      delimiter_count += 1
      if delimiter_count == 2:
        return "".join(lines[idx + 1 :])
  return "".join(lines)


def run_gh_issue_create(title: str, body: str, labels: List[str]) -> None:
  cmd = ["gh", "issue", "create", "--title", title, "--body", body]
  for label in labels:
    if label:
      cmd.extend(["--label", label])
  subprocess.run(cmd, check=True)


def main(argv: List[str]) -> int:
  parser = argparse.ArgumentParser(
    description="Create a GitHub issue from a markdown template."
  )
  parser.add_argument(
    "file",
    nargs="?",
    help="Path to the markdown file (defaults to latest in .github/issues/)",
  )
  args = parser.parse_args(argv)

  root_dir = Path(__file__).resolve().parents[1]
  issues_dir = root_dir / ".github" / "issues"

  if not issues_dir.is_dir():
    raise FileNotFoundError(f"Issues directory not found: {issues_dir}")

  issue_file = find_issue_file(args.file, issues_dir, root_dir)
  lines = issue_file.read_text(encoding="utf-8").splitlines(keepends=True)
  front_matter = read_front_matter(lines)
  title = parse_title(front_matter)
  labels = parse_labels(front_matter)
  body = extract_body(lines)

  run_gh_issue_create(title, body, labels)
  return 0


if __name__ == "__main__":
  try:
    sys.exit(main(sys.argv[1:]))
  except Exception as exc:  # pragma: no cover - CLI error path
    print(f"Error: {exc}", file=sys.stderr)
    sys.exit(1)
