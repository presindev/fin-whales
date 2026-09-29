# Project hooks

This directory documents the project-specific hooks of the SDD harness for Claude Code.

Hooks are enabled from the harness's wiring file (`.claude/settings.json`), not by placing scripts here automatically. The scripts are harness-neutral (see the adapter block at the top of each one); only the wiring is harness-specific.

## Enabled hooks

None. The developer accepted the recommended defaults during onboarding (2026-09-29): hooks are recommended but not enabled without approval. `.claude/settings.json` has no hook wiring.

## Available hook scripts

None copied. The kit's example hooks can be installed later on request.

## Policy

- Do not enable new hooks without developer approval.
- Prefer warning mode before blocking mode unless the developer approved strict enforcement.
- Keep hook scripts small and deterministic.
- Document every hook's purpose and failure mode.
- Keep the adapter block identical across scripts; put project logic below it.
