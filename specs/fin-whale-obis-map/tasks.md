---
doc: tasks
title: Tasks — Fin whale OBIS download and map
task_id: FW-001
feature_slug: fin-whale-obis-map
status: done
---

## Tasks

1. [x] T1: Write failing offline tests — AT1–AT4, AT-EDGE1, AT-ERR1, AT-ERR2 in `tests/testthat/` plus the source helper.
2. [x] T2: Implement download — `download_fin_whales()` for REQ-001, REQ-003, ERR-001, ERR-002.
3. [x] T3: Implement map — `valid_coords()`, `plot_fin_whale_map()` for REQ-004, REQ-005, EDGE-001.
4. [x] T4: Implement outputs and orchestration — `write_atomic()`, `run_fin_whales()`, `run_fin_whales.R` for REQ-002, REQ-006, REQ-007, EDGE-002.
5. [x] T5: Run validation — `scripts/run-tests.sh`, `scripts/run-lint.sh`, styler.
6. [x] T6: Live run — `Rscript run_fin_whales.R`; check AC-001 and AC-002 against real OBIS data.
7. [x] T7: Update docs — create `README.md`; update the project map with entrypoint and outputs.

## Validation checklist

- [x] Requirements are covered by tests.
- [x] Tests pass.
- [x] Lint passes.
- [x] No protected files were modified without approval.
- [x] Reviewer approved traceability.
- [x] Documentation decision recorded (required with targets, or not required).
