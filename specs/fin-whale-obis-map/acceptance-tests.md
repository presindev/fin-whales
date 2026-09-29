---
doc: acceptance-tests
title: Acceptance tests — Fin whale OBIS download and map
task_id: FW-001
feature_slug: fin-whale-obis-map
source_document: Developer request during onboarding (2026-09-29)
created: 2026-09-29
---

## Test strategy

- Testing style: `testthat, offline with mocked robis::occurrence`
- Test command: `scripts/run-tests.sh`
- Test locations: `tests/testthat/test-fin_whale_obis.R`

Scenario details are in `design.md` § Test design; this file tracks coverage.

## Coverage matrix

| Requirement | Acceptance test(s) | Covered |
| --- | --- | --- |
| REQ-001 | AT1, AT-MAN1 | !ok Covered |
| REQ-002 | AT2 | !ok Covered |
| REQ-003 | AT2 | !ok Covered |
| REQ-004 | AT3 | !ok Covered |
| REQ-005 | AT3 | !ok Covered |
| REQ-006 | AT4 | !ok Covered |
| REQ-007 | AT-MAN1 | !ok Covered |
| EDGE-001 | AT-EDGE1 | !ok Covered |
| EDGE-002 | AT-ERR1 | !ok Covered |
| ERR-001 | AT-ERR1 | !ok Covered |
| ERR-002 | AT-ERR2 | !ok Covered |

## Acceptance tests

::: card
#### AT-MAN1 — Live end-to-end run [!ok Passed]

- **Requirements:** REQ-001, REQ-007, AC-001, AC-002
- **Scenario:** Real download from OBIS.
- **Preconditions:** Network access to `api.obis.org`.
- **Action:** `Rscript run_fin_whales.R` from the project root.
- **Expected result:** Both files exist; printed total = CSV data rows = total in map title.
- **Negative expectations:** No files written outside the project root.
- **Test location:** manual (network-dependent, not automated per NFR-003)
:::

Automated tests AT1–AT4, AT-EDGE1, AT-ERR1, AT-ERR2: see `design.md` § Test design.

## Manual acceptance checklist

- [x] Every requirement has at least one acceptance test.
- [x] Main success path, empty state and invalid input are covered, where relevant.
- [x] Permission / security behavior is covered, if relevant.
- [x] Non-goals are protected, if relevant.
- [x] Tests are feasible with the current project test setup.
- [x] No acceptance test depends on hidden assumptions.
