# Fin whale OBIS observations

Downloads every fin whale (*Balaenoptera physalus*, WoRMS AphiaID 137091, subspecies included) occurrence record from [OBIS](https://obis.org), saves them as CSV, and plots them on a world map labelled with the total number of observations (one observation = one OBIS record).

## Run

From the project root (needs network access to `api.obis.org`; about 1–2 minutes):

```bash
Rscript run_fin_whales.R
```

Outputs, written to the project root and overwritten on each successful run:

| File | Content |
| --- | --- |
| `fin_whale_occurrences.csv` | One row per record: `id`, `scientificName`, `decimalLongitude`, `decimalLatitude`, `eventDate`, `date_year`, `basisOfRecord`, `individualCount`, `datasetName`, `datasetID` |
| `fin_whale_map.png` | Records on a WGS84 (EPSG:4326) world map; total in the title |

If OBIS fails or returns no records, the script stops with an error and leaves existing outputs untouched. Do not hand-edit the outputs; re-run the script instead.

## Requirements

R ≥ 4.x with `robis`, `dplyr`, `ggplot2`, `sf`, `rnaturalearth`, `rnaturalearthdata`. Tests also use `testthat`, `withr`, `tibble`; lint/format use `lintr`, `styler`.

## Development

```bash
scripts/run-tests.sh   # offline testthat suite (OBIS is mocked)
scripts/run-lint.sh    # lintr on R/
```

Code: `R/fin_whale_obis.R` (functions), `run_fin_whales.R` (entrypoint). Spec: `specs/fin-whale-obis-map/` (task FW-001). Agent/SDD instructions: `AGENTS.md`.
