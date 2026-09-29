---
doc: requirements
title: Requirements — Fin whale OBIS download and map
task_id: FW-001
feature_slug: fin-whale-obis-map
status: done
author: spec-author
human_approval: approved
---

## Summary

An R script downloads all fin whale (*Balaenoptera physalus*) occurrence records from OBIS, saves them as a CSV in the project root, and draws a georeferenced world map of the records labelled with the total number of observations. "Observation" means one OBIS occurrence record (see `assumptions.md` A1).

## Functional requirements

REQ-001: When the developer runs the entrypoint script, the system shall download from the OBIS API all occurrence records for fin whale (WoRMS AphiaID 137091, including child taxa).
REQ-002: When the download succeeds, the system shall write the records to `fin_whale_occurrences.csv` in the project root, one row per record, with a header row.
REQ-003: The CSV shall contain at least the columns `id`, `scientificName`, `decimalLongitude`, `decimalLatitude`, `eventDate`, `date_year`, `basisOfRecord`, `individualCount`, `datasetName`, `datasetID`.
REQ-004: When the download succeeds, the system shall produce a map of every record with valid coordinates on a world basemap in WGS84 (EPSG:4326) with longitude/latitude axes.
REQ-005: The map shall display the total number of observations (count of downloaded records) in its title.
REQ-006: When the download succeeds, the system shall save the map to `fin_whale_map.png` in the project root.
REQ-007: When the script finishes, the system shall print the total number of observations and the paths of the files written.

## Non-functional requirements

NFR-001: The download requests only the columns in REQ-003 to limit transfer time for ~282k records.
NFR-002: Code uses only packages already installed: `robis`, `dplyr`, `ggplot2`, `sf`, `rnaturalearth`, `rnaturalearthdata`.
NFR-003: Automated tests run offline (no network calls).

## Edge cases

EDGE-001: If some records lack valid coordinates (missing, or outside ±180 / ±90), the system shall keep them in the CSV, omit them from the map, and state the omitted count in the map subtitle.
EDGE-002: If `fin_whale_occurrences.csv` or `fin_whale_map.png` already exists, the system shall overwrite it only after a successful download.

## Error states

ERR-001: If the OBIS request fails, the system shall stop with an error naming OBIS and shall not modify existing output files.
ERR-002: If OBIS returns zero records, the system shall stop with an error and shall not write output files.

## Acceptance criteria

AC-001: Running `Rscript run_fin_whales.R` from the project root creates both output files and prints the total (REQ-001..REQ-007).
AC-002: The number of CSV data rows equals the total shown in the map title.

## UI acceptance criteria

Not applicable.

## Visual evidence

Not applicable.

## External dependencies

- OBIS API v3 (`api.obis.org`) via the `robis` R package.
- Natural Earth land polygons via `rnaturalearth` (offline, bundled data).

## Documentation expectations

A `README.md` with how to run the script and what it produces.

## Decision candidates

None.

## Requirement-to-test mapping

| Requirement | Expected test(s) |
| --- | --- |
| REQ-001 | AT1 (mocked `robis::occurrence` receives `taxonid = 137091`); AT-MAN1 manual run |
| REQ-002 | AT2 |
| REQ-003 | AT2 |
| REQ-004 | AT3 |
| REQ-005 | AT3 |
| REQ-006 | AT4 |
| REQ-007 | AT-MAN1 |
| EDGE-001 | AT-EDGE1 |
| EDGE-002 | AT-ERR1 |
| ERR-001 | AT-ERR1 |
| ERR-002 | AT-ERR2 |
