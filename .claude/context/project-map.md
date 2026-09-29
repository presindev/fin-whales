# Fin whale OBIS observations — project map

Orientation artifact for the agent and developers: where things live, how
the project runs, and what must not be touched without approval.

Rules for this file:

- Keep it concise — aim for one or two screens. It exists to avoid loading
  many files into context, not to replace them (see the context-economy
  policy).
- Keep the tree shallow (2–3 levels) and annotated; omit generated and
  vendored directories. Do not list every file.
- Never record secrets, credentials, or tokens here.
- **Maintenance rule:** update this map when the structure changes
  significantly — new top-level directories, moved entrypoints, renamed
  build/test commands, or new protected areas.

## Directory tree

```text
.
├── AGENTS.md / CLAUDE.md      # agent instructions (CLAUDE.md imports AGENTS.md)
├── .claude/                   # SDD harness: agents, skills, context, vendored policies
├── specs/                     # SDD specs, one folder per feature
├── decisions/answers.md       # onboarding decisions
├── tasks.json                 # task state
├── history.md                 # completed-task history
├── scripts/                   # init, tests, lint, spec renderer, structure validator
├── sdd-onboarding-kit/        # source kit (read-only, may be removed)
├── README.md                  # how to run and what it produces
├── run_fin_whales.R           # entrypoint: Rscript run_fin_whales.R
├── R/fin_whale_obis.R         # download, CSV, map functions
├── tests/testthat/            # offline testthat suite (OBIS mocked)
├── fin_whale_occurrences.csv  # generated output (do not hand-edit)
└── fin_whale_map.png          # generated output (do not hand-edit)
```

## Key entrypoints

| Entrypoint | Purpose |
|---|---|
| `run_fin_whales.R` | Download fin whale OBIS data, write CSV, plot map (`Rscript run_fin_whales.R`) |
| `R/fin_whale_obis.R` | `download_fin_whales()`, `plot_fin_whale_map()`, `run_fin_whales()` |

## Commands

| Action | Command |
|---|---|
| Install / validate environment | `scripts/init.sh` |
| Run all tests | `scripts/run-tests.sh` (testthat on `tests/testthat/`) |
| Lint | `scripts/run-lint.sh` (lintr on `R/`) |
| Typecheck | Not applicable (R) |
| Build | Not applicable |
| Format | `Rscript -e 'styler::style_dir("R"); styler::style_dir("tests")'` |
| Render a spec | `python3 scripts/render_spec.py specs/<feature-slug>/` |

## Framework and runtime assumptions

- R 4.6.1 (`Rscript` on PATH). Packages available at onboarding: `robis`, `ggplot2`, `sf`, `rnaturalearth`, `rnaturalearthdata`, `dplyr`, `leaflet`, `testthat`, `lintr`, `styler`.
- Network access to the OBIS API (`api.obis.org`) is required to download data.
- Python 3 is used only for the spec renderer.

## Important documentation

| Document | Path |
|---|---|
| Project README | `README.md` |
| Agent instructions | `AGENTS.md` |
| SDD procedure | `.claude/skills/sdd-workflow/SKILL.md` |
| Onboarding decisions | `decisions/answers.md` |

## Protected areas

Files or directories that require explicit approval before changes:

- `sdd-onboarding-kit/` — read-only.
- Downloaded CSV data — regenerate via the script, never hand-edit.
- `.claude/sdd-kit-manifest.json` — rewritten only by the `sdd-update` skill.

## SDD locations

| Artifact | Path |
|---|---|
| Task state | tasks.json |
| Specs | specs/<feature-slug>/ |
| History | history.md |
| Decisions | decisions/ |

## Generated files and do-not-edit

| Path | Rule |
|---|---|
| `specs/**/*.html`, `history.html` | Rendered from markdown; gitignored; never hand-edit |
| `fin_whale_occurrences.csv`, `fin_whale_map.png` | Produced by the R script; regenerate, never hand-edit |
