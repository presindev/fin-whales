---
doc: history
title: SDD History
---

## Entries

<!-- Append a new entry each time a task reaches done — newest first, immediately after the INSERT-ENTRY-HERE marker. Remove the "No entries yet." line when adding the first entry. Entry format:

::: card
#### TASK-001 — feature-slug [!ok done]

- **Date:** YYYY-MM-DD
- **Spec:** `specs/feature-slug/`
- **Summary:** …
- **Files changed:** …
- **Tests run:** …
- **Reviewer decision:** approved
- **Human approval ref:** …
- **Docs updated:** … (targets updated, or "not required")
- **Decisions recorded:** … (entries accepted by the developer, or "none")
- **Follow-ups:** … (or "none")
:::
-->

<!-- INSERT-ENTRY-HERE -->

::: card
#### FW-001 — fin-whale-obis-map [!ok done]

- **Date:** 2026-09-29
- **Spec:** `specs/fin-whale-obis-map/`
- **Summary:** R script downloads all fin whale (AphiaID 137091) OBIS records (281,845 on 2026-09-29), writes `fin_whale_occurrences.csv` and plots `fin_whale_map.png` (WGS84, total in title). Writes are atomic and failures leave existing outputs untouched.
- **Files changed:** `R/fin_whale_obis.R`, `run_fin_whales.R`, `tests/testthat/helper-source.R`, `tests/testthat/test-fin_whale_obis.R`, `README.md`, `.claude/context/project-map.md` (also `AGENTS.md` / `decisions/answers.md` doc sync, review NBK-1)
- **Tests run:** `scripts/run-tests.sh` 26 pass / 0 fail; `scripts/run-lint.sh` no lints; live run (AC-001, AC-002)
- **Reviewer decision:** approved
- **Human approval ref:** developer in chat, 2026-09-29, "approve FW-001" (tasks.json → approval)
- **Docs updated:** `README.md`, `.claude/context/project-map.md`
- **Decisions recorded:** none
- **Follow-ups:** none
:::
