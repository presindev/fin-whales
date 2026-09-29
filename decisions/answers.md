# SDD onboarding decisions

Recorded during onboarding on 2026-09-29 (kit v2.1.0). The developer accepted the **recommended defaults profile** (`instructions.md` → "Safe default profile"); deviations and mandatory answers are listed below.

## Project

- Project name: Fin whale OBIS observations
- Project summary: R code that downloads fin whale occurrence data from OBIS, saves it as CSV in the project root, and plots a georeferenced map with the total observation count.
- Main language/framework: R 4.6.1 (`robis`, `ggplot2`, `sf`, `rnaturalearth` available)
- Package manager: none (packages installed in the user R library; no renv)

## Harness

- Primary harness (Claude Code / Codex CLI / Cursor / OpenCode / Antigravity / other): Claude Code
- Primary harness directory (`<harness-dir>`): `.claude/`
- Instruction file(s) generated (`AGENTS.md`; `CLAUDE.md` import stub if Claude Code is used): `AGENTS.md` + `CLAUDE.md` stub
- Additional harnesses and their directories: none
- Concepts not available in the harness and the fallback used (subagents → roles in the main conversation; skills → read on demand; hooks → instruction-only): none — all concepts available

## Commands

- Init command: `scripts/init.sh`
- Test command: `scripts/run-tests.sh` → `testthat::test_dir("tests/testthat", stop_on_failure = TRUE)` (skips cleanly until `tests/testthat/` exists)
- Targeted test command: `Rscript -e 'testthat::test_file("tests/testthat/<file>.R")'`
- Lint command: `scripts/run-lint.sh` → `lintr::lint_dir("R")`, non-zero exit on any lint (skips until `R/` exists)
- Typecheck command: not applicable (R)
- Format command: `Rscript -e 'styler::style_dir("R"); styler::style_dir("tests")'`

## SDD policy

- Scope of SDD: only tasks marked `"sdd": true` in `tasks.json`
- Tasks that may skip SDD: tasks without `sdd: true`; typos, trivial cosmetic changes, local renames, minor docs, small obvious fixes
- Human approval required: yes, before implementation; reviewer required before `done`
- Requirements format: EARS; every requirement maps to a test or a justified exception
- Task storage: local `tasks.json`
- Spec storage: `specs/<feature-slug>/`
- History storage: `history.md`
- Spec renderer: Python (`scripts/render_spec.py`) — chosen by the developer (R project; neither runtime matched the language)
- Rendered HTML: gitignored (default)

## State machine

- Statuses: `pending → spec_draft → spec_ready → human_approved → in_progress → review → done`, plus `blocked`, `rejected`
- Approval transition rule: only the developer moves `spec_ready → human_approved`
- Done transition rule: reviewer approved, tests passing, documentation `updated` or `not_required`

## Git policy

- Repository: `git init` run during onboarding with developer approval; no commits made
- Branch creation: ask before creating a branch
- Branch naming: not set (ask when needed)
- Commit policy: ask before each commit
- Pull request policy: ask before opening a PR; every git mutation needs explicit per-action permission

## Hooks

- Enabled hooks: none
- Hooks left as examples: all kit examples (not copied)
- Hook failure mode: not applicable
- Hook wiring file(s) per harness: none (`.claude/settings.json` not created)

## MCPs

- Configured MCPs: none (local-first)
- MCP config file(s) per harness: none
- Read-only MCPs: none
- Read/write MCPs: none
- External task mapping: none

## Protected areas

- Protected files: `.claude/sdd-kit-manifest.json` (rewritten only by `sdd-update`)
- Protected directories: `sdd-onboarding-kit/` (read-only)
- Requires explicit approval: editing downloaded CSV data (regenerate via the script instead)

## Other defaults applied

- Optional skill packs: none installed; all ten declined by accepting defaults (do not re-propose unless asked)
- Dependency/API freshness: required for high-risk categories, advisory otherwise
- Decision log: not installed; decisions live in specs and `history.md`
- Browser testing (Playwright): option 1 — no browser UI; nothing installed
- Failure learning: proposals only; no memory write without approval of the exact entry
- Documentation phase: enabled
- Deep review: recommended for high-risk categories; paid modes only with per-invocation approval
- Autonomy: disabled except documented read-only monitoring
- Session-recovery rule: kept in `AGENTS.md`
- Project map: generated at `.claude/context/project-map.md`

## Open TODOs

- TODO: consider `renv` if the project needs reproducible package versions.
