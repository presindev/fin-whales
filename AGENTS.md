# Fin whale OBIS observations — project instructions for coding agents

This project uses **Spec Driven Development (SDD)** for non-trivial implementation work. These instructions apply to every coding agent working in this repository (Claude Code, Codex, Cursor, OpenCode, Antigravity or another harness).

## Project summary

R project that downloads fin whale (*Balaenoptera physalus*) occurrence records from the OBIS database (obis.org), saves them as CSV in the project root, and plots them on a georeferenced map annotated with the total number of observations. Entrypoint: `Rscript run_fin_whales.R` (see `README.md`).

## Project map

Repository structure, entrypoints, commands, important docs, and protected
areas are described in the project map:

```text
.claude/context/project-map.md
```

Read it when you need orientation; do not duplicate its directory tree into
this file. Update it when the structure changes significantly (new
top-level directories, moved entrypoints, changed commands, new protected
areas).

## Commands

Use these project commands:

```bash
# Install or validate environment
scripts/init.sh

# Run all tests (testthat, tests/testthat/)
scripts/run-tests.sh

# Run lint (lintr on R/)
scripts/run-lint.sh

# Run typecheck
# Not applicable (R has no typecheck step).

# Format code
Rscript -e 'styler::style_dir("R"); styler::style_dir("tests")'
```

If any command is unknown, ask the developer before inventing one.

## SDD policy

SDD applies to tasks marked `"sdd": true` in `tasks.json`. Requirements use the EARS format; every functional requirement maps to at least one test or a justified exception.

Default state machine:

```text
pending → spec_draft → spec_ready → human_approved → in_progress → review → done
```

Optional states: `blocked`, `rejected`.

Do not implement an SDD task unless it is in `human_approved` or `in_progress`.

If a task is marked `spec_ready`, stop and ask for human approval.

## Task storage

Task state is stored in:

```text
tasks.json
```

## Spec storage

Specs are stored in:

```text
specs/<feature-slug>/
├── requirements.md
├── design.md
├── tasks.md
└── review.md
```

Spec files are markdown — the source of truth (format: `.claude/skills/sdd-workflow/spec-format.md`).
Render them to styled HTML for human review with `python3 scripts/render_spec.py specs/<feature-slug>/`; the rendered `.html` files are gitignored artifacts — never hand-edit them.
Structured state (task status, approval) lives in `tasks.json`, not in spec files.

## Required SDD workflow

For each SDD task:

1. Read the task.
2. Create or update the spec.
3. Stop for human approval.
4. Implement only after approval.
5. Run tests and validation.
6. Run the reviewer role.
7. If the reviewer requires documentation updates, run the documenter role, then the reviewer re-checks the docs.
8. Mark done only if requirements, implementation, tests and required docs are aligned.
9. Append a summary to `history.md`.

## SDD skill

The full procedure is the `sdd-workflow` skill:

```text
.claude/skills/sdd-workflow/SKILL.md
```

Invoke it by name (`sdd-workflow`) with the task ID or feature description, using this harness's skill invocation (`/sdd-workflow` in Claude Code), or read `SKILL.md` and follow it when the harness does not load skills automatically.

## Optional skills installed

None (all optional packs declined during onboarding; see `decisions/answers.md`).

## Roles (subagents)

The SDD roles are defined in `.claude/agents/`. Use them as subagents where the harness supports them; otherwise read the role file and act as that role in the main conversation, one role at a time. Roles never call each other: the main conversation orchestrates.

- `leader`: inspects task state and recommends which role to run next.
- `spec-author`: creates requirements, design and implementation tasks.
- `implementer`: writes code from approved specs.
- `reviewer`: validates implementation against specs; decides whether documentation updates are required.
- `documenter`: updates affected documentation after review approval, before a task is marked done.

None.

## Human approval policy

Human approval is mandatory before implementation. The agent stops after writing `requirements.md`, `design.md` and `tasks.md`, sets the task to `spec_ready`, and waits. Only the developer moves a task to `human_approved` (recorded in `tasks.json` → `approval`). The reviewer is required before `done`; `done` is never set with failing tests.

## Hooks policy

No hooks are enabled. Rules are instruction-level only. Do not enable hooks without developer approval (see `.claude/hooks/README.md`).

## MCP policy

No MCPs are configured. The project is local-first. Do not configure MCPs without developer approval. OBIS is accessed from R code (the `robis` package), not through an MCP.

## Git policy

The repository was initialized with `git init`; no commits exist yet. Ask before creating a branch, committing, pushing, or opening a pull request — every git mutation needs explicit permission per action.

## Protected areas

- `sdd-onboarding-kit/` — read-only source kit; never edit.
- Downloaded data (`*.csv` produced by the download script) — never hand-edit; regenerate by re-running the script.
- `.claude/sdd-kit-manifest.json` — only the `sdd-update` skill rewrites it.

## When SDD may be skipped

Tasks not marked `"sdd": true`, plus typos, trivial cosmetic changes, local renames, minor documentation, and small obvious fixes. State that SDD is being skipped and why.

## Context economy

The context window is a scarce resource. Rules:

- Keep this file short; link to deeper docs instead of duplicating them.
- Long procedures belong in skills, not here.
- Inspect context usage and compact between unrelated tasks with the harness's context commands (`/context` and `/compact` in Claude Code), with focus instructions to preserve decisions, task status, architecture constraints, and unresolved questions.
- Delegate noisy, many-file exploration to subagents where available; keep only conclusions in the main conversation.
- Durable truth lives in artifacts (`tasks.json`, `specs/`, decision logs, `history.md`), not in chat history.

## Session recovery

If unsure after resuming a session, a rewind, or a compaction: inspect the durable artifacts before continuing — `tasks.json` for task state, the active spec for what is approved, the latest review for open findings, `git status` for actual changes. When conversation memory and an artifact disagree, the artifact wins.

## Final rule

Prefer a clear spec over a clever implementation. If the spec is ambiguous, ask or revise the spec before coding.

## Functional documents

Functional documents, PRDs, tickets, user stories, or informal feature descriptions are source material.

They are not approved implementation specs.

When a functional document is provided, the agent must first generate an SDD spec under:

specs/<feature-slug>/

Required files:

- requirements.md
- design.md
- tasks.md
- assumptions.md
- open-questions.md
- acceptance-tests.md

The agent must stop after generating the spec and wait for human approval before implementation.

## Harness updates

The SDD harness was installed from the sdd-onboarding-kit (version, harness layout and file inventory: `.claude/sdd-kit-manifest.json`). To update it when the kit publishes a new version, invoke the `sdd-update` skill.
