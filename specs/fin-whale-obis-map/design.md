---
doc: design
title: Design — Fin whale OBIS download and map
task_id: FW-001
feature_slug: fin-whale-obis-map
status: done
---

## Technical summary

Pure functions in `R/fin_whale_obis.R` do download, CSV writing and plotting; the thin entrypoint `run_fin_whales.R` sources them and calls them in order. Download uses `robis::occurrence(taxonid = 137091, fields = ...)` (REQ-001, NFR-001). The map is a `ggplot2` plot of an `sf` point layer over Natural Earth land in EPSG:4326 (REQ-004..REQ-006). Outputs are written to temp files and renamed only after success (EDGE-002, ERR-001).

## Data flow

::: diagram
<svg width="620" height="140" viewBox="0 0 620 140" aria-label="OBIS API to CSV and PNG map">
  <defs>
    <marker id="arrowhead" markerWidth="8" markerHeight="6" refX="8" refY="3" orient="auto">
      <polygon points="0 0, 8 3, 0 6" fill="#6b7280"/>
    </marker>
  </defs>
  <rect x="10" y="50" width="120" height="40" rx="6" fill="#eff6ff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="70" y="75" text-anchor="middle" font-family="sans-serif" font-size="12" fill="#1e3a8a">OBIS API v3</text>
  <line x1="130" y1="70" x2="188" y2="70" stroke="#6b7280" stroke-width="1.5" marker-end="url(#arrowhead)"/>
  <rect x="190" y="40" width="160" height="60" rx="6" fill="#f5f3ff" stroke="#7c3aed" stroke-width="1.5"/>
  <text x="270" y="66" text-anchor="middle" font-family="sans-serif" font-size="12" fill="#4c1d95">download_fin_whales()</text>
  <text x="270" y="84" text-anchor="middle" font-family="sans-serif" font-size="11" fill="#4c1d95">tibble of records</text>
  <line x1="350" y1="60" x2="428" y2="35" stroke="#6b7280" stroke-width="1.5" marker-end="url(#arrowhead)"/>
  <line x1="350" y1="80" x2="428" y2="105" stroke="#6b7280" stroke-width="1.5" marker-end="url(#arrowhead)"/>
  <rect x="430" y="15" width="180" height="40" rx="6" fill="#eafaf1" stroke="#27ae60" stroke-width="1.5"/>
  <text x="520" y="40" text-anchor="middle" font-family="sans-serif" font-size="12" fill="#14532d">fin_whale_occurrences.csv</text>
  <rect x="430" y="85" width="180" height="40" rx="6" fill="#eafaf1" stroke="#27ae60" stroke-width="1.5"/>
  <text x="520" y="110" text-anchor="middle" font-family="sans-serif" font-size="12" fill="#14532d">fin_whale_map.png</text>
</svg>
:::

## Project map references

Creates the planned `R/`, `tests/testthat/` and the root entrypoint; closing task T7 updates `.claude/context/project-map.md`.

## Files to change

| File | Change | Reason |
| --- | --- | --- |
| `R/fin_whale_obis.R` | Create | Functions below |
| `run_fin_whales.R` | Create | Entrypoint (AC-001) |
| `tests/testthat/test-fin_whale_obis.R` | Create | Offline tests (NFR-003) |
| `tests/testthat/helper-source.R` | Create | Sources `R/fin_whale_obis.R` for tests |
| `README.md` | Create | Documentation expectation |
| `.claude/context/project-map.md` | Update | Record entrypoint and outputs |

## Files not to change

| File or directory | Reason |
| --- | --- |
| `sdd-onboarding-kit/` | Protected, read-only |
| `.claude/` (except project map) | Harness files |

## Interfaces and contracts

### R/fin_whale_obis.R

```r
FIN_WHALE_APHIA_ID <- 137091L
OBIS_FIELDS <- c("id", "scientificName", "decimalLongitude", "decimalLatitude",
                 "eventDate", "date_year", "basisOfRecord", "individualCount",
                 "datasetName", "datasetID")

download_fin_whales(taxonid = FIN_WHALE_APHIA_ID, fields = OBIS_FIELDS) -> tibble
  # wraps robis::occurrence(); stop("OBIS download failed: ...") on error (ERR-001),
  # stop("OBIS returned no ... records") on 0 rows (ERR-002); adds missing REQ-003 columns as NA
valid_coords(df) -> logical vector    # non-NA, lon in [-180,180], lat in [-90,90]
plot_fin_whale_map(df) -> ggplot     # title "Fin whale (Balaenoptera physalus) observations in OBIS — total: N"
                                     # subtitle names omitted count when > 0 (EDGE-001)
write_atomic(path, writer) -> path   # writer(tmp) then file.rename(tmp, path) (EDGE-002)
run_fin_whales(out_dir = ".") -> list(total, csv, png)  # orchestrates; prints REQ-007 message
```

### CLI

```text
Rscript run_fin_whales.R   # from project root; writes ./fin_whale_occurrences.csv and ./fin_whale_map.png
```

## Data model changes

None.

## External dependencies and freshness

| Dependency | Docs checked (source, date) | Version constraints | Deprecations avoided / notes |
| --- | --- | --- | --- |
| `robis` / OBIS API v3 | Installed package signature `robis::occurrence(taxonid, fields, ...)` and live `api.obis.org/v3/occurrence` query, 2026-09-29 (281,845 records for *B. physalus*) | robis 2.12.0 installed | `fields` limits columns; paging handled by robis |
| `sf`, `ggplot2`, `rnaturalearth` | Installed versions, 2026-09-29 | as installed | `ne_countries(scale = "medium", returnclass = "sf")` |

Not a high-risk category: advisory only.

## Security and permissions

None. Public read-only API, no credentials.

## Documentation targets

`README.md` (new).

## Test design

Offline testthat tests with a small fixture tibble; `robis::occurrence` is replaced via `testthat::local_mocked_bindings(.package = "robis")`.

- AT1 → REQ-001: mock records arguments; asserts `taxonid = 137091` and `fields = OBIS_FIELDS`.
- AT2 → REQ-002/003: `run_fin_whales(tempdir)` with mocked download; CSV has header, REQ-003 columns, row count = fixture rows.
- AT3 → REQ-004/005: plot object uses `coord_sf` with CRS 4326; title contains the total.
- AT4 → REQ-006: PNG exists and is non-empty.
- AT-EDGE1 → EDGE-001: fixture with invalid coords; CSV keeps them, subtitle states omitted count.
- AT-ERR1/2 → ERR-001/002, EDGE-002: mocks throw / return 0 rows; pre-existing output files unchanged.

## UI verification plan

Not applicable.

## Risks and trade-offs

- Full download of ~282k records takes several minutes and depends on OBIS availability; mitigated by NFR-001.
- Rejected: `leaflet` interactive HTML map — a static PNG is simpler to share; can be added later.
- Rejected: summing `individualCount` as the total — often missing; records are the unit (A1).

## Rollback plan

Delete the new files; nothing else depends on them.
