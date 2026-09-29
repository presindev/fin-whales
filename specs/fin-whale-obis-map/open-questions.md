---
doc: open-questions
title: Open questions — Fin whale OBIS download and map
task_id: FW-001
feature_slug: fin-whale-obis-map
source_document: Developer request during onboarding (2026-09-29)
created: 2026-09-29
---

## Summary

- Blocking: 0 · Non-blocking: 0 · Resolved: 1

## Open

None.

## Resolved

::: card
#### Q1 — Extra map styling [!ok Resolved]

- **Question:** Should points be colored by something (e.g. decade, basis of record), or is one color enough?
- **Why it matters:** Changes the legend and plot readability with ~282k points.
- **Default if unanswered:** One color, semi-transparent points, no legend.
- **Affected files / sections:** `design.md` § Interfaces (`plot_fin_whale_map`)
- **Related requirements:** REQ-004
- **Resolution:** Default accepted with approval "approve FW-001" (2026-09-29); implemented as one colour, alpha 0.25, no legend.
:::

## Deferred

None yet.
