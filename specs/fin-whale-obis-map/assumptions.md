---
doc: assumptions
title: Assumptions — Fin whale OBIS download and map
task_id: FW-001
feature_slug: fin-whale-obis-map
source_document: Developer request during onboarding (2026-09-29)
created: 2026-09-29
---

## Summary

- Risk counts: low 3 · medium 1 · high 0
- Blocking assumptions present: no

## Pending

None.

## Accepted

::: card risk-medium
#### A1 — An observation is one OBIS record [!ok Accepted]

- **Assumption:** "Total number of observations" = number of occurrence records downloaded, not the sum of `individualCount`.
- **Reason:** `individualCount` is often missing in OBIS.
- **Risk / impact if wrong:** medium — the map total would need a different calculation.
- **Blocks implementation:** no
- **Accepted:** 2026-09-29, developer approval "approve FW-001" (tasks.json → approval)
- **Related requirements:** REQ-005, AC-002
:::

::: card risk-low
#### A2 — Whole taxon, all time, worldwide [!ok Accepted]

- **Assumption:** No date, area or dataset filter; the taxon includes child taxa (subspecies) under AphiaID 137091.
- **Reason:** The request names only the species.
- **Risk / impact if wrong:** low — add filter arguments.
- **Blocks implementation:** no
- **Accepted:** 2026-09-29, developer approval "approve FW-001" (tasks.json → approval)
- **Related requirements:** REQ-001
:::

::: card risk-low
#### A3 — Static PNG map [!ok Accepted]

- **Assumption:** The map is a static PNG (`fin_whale_map.png`), not an interactive web map.
- **Reason:** Simplest shareable georeferenced output.
- **Risk / impact if wrong:** low — a leaflet HTML map can be added.
- **Blocks implementation:** no
- **Accepted:** 2026-09-29, developer approval "approve FW-001" (tasks.json → approval)
- **Related requirements:** REQ-004, REQ-006
:::

::: card risk-low
#### A4 — Output file names and location [!ok Accepted]

- **Assumption:** Outputs go to the project root as `fin_whale_occurrences.csv` and `fin_whale_map.png`, overwritten on each successful run.
- **Reason:** "Save the data in the folder we are in."
- **Risk / impact if wrong:** low — rename.
- **Blocks implementation:** no
- **Accepted:** 2026-09-29, developer approval "approve FW-001" (tasks.json → approval)
- **Related requirements:** REQ-002, REQ-006, EDGE-002
:::

## Rejected or replaced

None yet.
