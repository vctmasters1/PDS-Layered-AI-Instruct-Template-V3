# Changelog

All notable changes to this **template** are recorded here. This tracks the template structure itself, not any project built from it. Once you adopt the template for a real project, replace the contents below with your project's changelog.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the template uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- **Claude Code, Continue, and Cline pointer files** — pre-configured compatibility for three additional AI coding agents, following the same "pointer, not duplication" pattern as the existing Cursor integration:
  - [`CLAUDE.md`](CLAUDE.md) at the repo root for Claude Code.
  - [`.continue/rules/project.md`](.continue/rules/project.md) for Continue.
  - [`.clinerules/project.md`](.clinerules/project.md) for Cline.
- `AGENTS.md` tool compatibility section updated to list all five pre-configured agents (Copilot, Codex CLI, Aider, Cursor, Claude Code, Continue, Cline).

## [3.1.1] — 2026-05-25

### Added
- **`.examples/` filled-in module showcase** — three realistic worked examples (`auth-api`, `data-layer`, `ui-component`) each with a populated `.ai/instruct.md` and a `BEFORE-AFTER.md` showing concrete AI behavior changes once layered rules are in place.
- **`setup.sh` / `setup.ps1`** — one-shot installer (git hooks, `.env` scaffold, validator run) so a fresh clone is bootstrapped before `/ai-onboard`.
- **`.ai/stack-examples/`** — copy-paste reference Code Organization rules for TypeScript+React, Python+FastAPI, and Embedded C/C++.
- **`.cursor/rules/project.mdc`** — Cursor compatibility pointer to the `.ai/` hierarchy (no rule duplication).
- **`.github/PULL_REQUEST_TEMPLATE.md`** — AI-INSTRUCT-aware PR checklist (instruction discipline, safety, credentials).
- **`.github/TOPICS.md`** — recommended GitHub repo topics for discoverability.
- README hero section, status badges (License, Copilot Ready, AGENTS.md, Template V3), and a Mermaid diagram of the depth-priority layering.
- TEMPLATE-USAGE.md → **Companion Resources** section with Awesome-Copilot, Cursor, Aider, stack-example, and filled-in module guidance.
- `.example-module/` and `.examples/` registered in root `.ai/instruct.md` Key Directories; `.examples/` and stack-example sections added to `.ai/index.md`.

### Changed
- `.ai/conventions.md` dot-prefix list now includes `.cursor/` (tooling) and `.examples/` (reference scaffold).

## [3.1.0] — 2026-05-25

### Added
- **`/ai-onboard` slash command** — interactive wizard that walks a fresh clone through filling in every template placeholder (project name, description, license year/holder, `dev-specs.md` checkboxes, dates, modules, env vars), then invokes `/ai-update-index`. Detects sensible defaults from the environment and existing workspace files before asking. See [`.github/prompts/ai-onboard.prompt.md`](.github/prompts/ai-onboard.prompt.md).
- **`/ai-validate` slash command** — runs the drift validator and reports findings without auto-editing. See [`.github/prompts/ai-validate.prompt.md`](.github/prompts/ai-validate.prompt.md).
- **`/ai-commit` slash command** — pre-commit hygiene: refreshes `Last Updated` dates on staged instruction files, runs the validator, drafts a Conventional Commits message, and optionally pushes (never with `--force` or `--no-verify`). See [`.github/prompts/ai-commit.prompt.md`](.github/prompts/ai-commit.prompt.md).
- `.github/copilot-instructions.md` now documents the **YAML Frontmatter Schema** for `.prompt.md`, `.agent.md`, and `SKILL.md` files (required/optional fields, allowed values).
- `.github/scripts/validate-instructions.ps1` — drift linter that flags unfilled `[DATE]` placeholders, retired `§` syntax, missing `## Contents` tables on 5+-section files, malformed prompt/agent frontmatter, and broken relative markdown links. Documented in [`TEMPLATE-USAGE.md` → Validation](TEMPLATE-USAGE.md#validation).
- `.example-module/.env.example` so the example module demonstrates the full per-module env convention.
- `TEMPLATE-USAGE.md` Step 2 now includes a **realistic filled-in module example** alongside the placeholder scaffold.
- `.ai/conventions.md` File Naming now lists **tool-mandated name exceptions** (`copilot-instructions.md`, `SKILL.md`) and codifies the `/ai-` prefix rule for project-specific prompt files.
- `.ai/index.md` now explains why entries link to files rather than section anchors.
- Cross-links between [`.ai/conventions.md` → .gitignore Decisions](.ai/conventions.md#gitignore-decisions) and [`.ai/credentials.md` → .gitignore Requirements](.ai/credentials.md#gitignore-requirements) so each file points to the other as a related source of truth.

### Changed
- `.ai/conventions.md` Instruction File Dating rule clarified: prompt-file *templates* and inline code-block templates may keep `[DATE]` / `YYYY-MM-DD` as a literal placeholder until instantiated.
- `AGENTS.md` no longer claims Claude Code (`CLAUDE.md`) or Cursor (`.cursorrules`) compatibility — those integrations were never provided. Codex CLI and Aider remain.
- `.dev-docs/` index template heading normalized to `## Archived (\`.old/\`)` (with backticks) in `.ai/conventions.md` and `TEMPLATE-USAGE.md`, matching what `/ai-new-module` already emits and what the two shipped `.dev-docs/index.md` files use.
- `AGENTS.md` added to the list of root meta-files exempted from `kebab-case.md` naming in `.ai/conventions.md`.
- **Cross-reference convention standardized on clickable markdown anchor links.** The grep-only `§` (section-sign) token has been retired in favor of standard markdown anchor syntax — `[Heading](path/to/file.md#heading)` — across all TOC tables and cross-references. Links are now click-navigable in VS Code (Ctrl/Cmd+Click), VS Code preview, and GitHub. See [Cross-Reference Convention](.ai/conventions.md#cross-reference-convention) and [TOC Requirement](.ai/conventions.md#toc-requirement) for the new rules.
- All `| § | What's here |` TOC column headers replaced with `| Section | What's here |` across `.github/copilot-instructions.md`, `.github/dev-specs.md`, `.ai/conventions.md`, `.ai/credentials.md`, `.ai/instruct.md`, `.ai/maintenance.md`, `.example-module/.ai/instruct.md`, and `TEMPLATE-USAGE.md`.
- All `> **→ \`path\` § Heading**` callouts retrofitted to clickable `> **→ [Heading](relative/path.md#heading)**` form. Paths are now relative to the linking file (so links work in VS Code preview and editor, not only in GitHub render).
- `pre-commit` and `.gitignore` comment references updated to the new `path#anchor` form.
- README and TEMPLATE-USAGE no longer maintain parallel slash-command / agent / skill tables — both now point to [`.ai/index.md` → Meta & System](.ai/index.md#meta--system) as the single source of truth.
- `install-hooks.sh` no longer `chmod`s non-existent `commit-msg` / `pre-push` hooks.
- `.github/skills/project-navigation/SKILL.md` clarified: the master index links at file granularity — jump to specific sections using each file’s own `## Contents` table.
- `AGENTS.md` Aider wording tightened: Aider does not auto-discover `AGENTS.md`; users must point `--read` at the relevant files.
- `/ai-archive` prompt now specifies preferred move command (`git mv` for tracked files, `Move-Item` / `mv` otherwise) so history is preserved.

### Fixed
- Validator path drift corrected throughout the template — the script lives at [`.github/scripts/validate-instructions.ps1`](.github/scripts/validate-instructions.ps1) (stale `.github/debug/...` references in TEMPLATE-USAGE and this changelog fixed).
- `pre-commit.sample` references removed — the shipped hook is [`.github/hooks/pre-commit`](.github/hooks/pre-commit) (no `.sample` suffix; `core.hooksPath` sources it live).
- `Template Version` in `.github/copilot-instructions.md` now matches this `## [3.1.0]` release block (was `V3.1.0` while the CHANGELOG still had everything under `[Unreleased]`).
- `**Last Updated**: [DATE]` placeholder filled in `.ai/instruct.md` and `.example-module/.ai/instruct.md` (was previously violating the rule in [Versioning](.ai/conventions.md#versioning)).
- Retired `§` cross-reference syntax replaced with clickable markdown anchors in `.archive/README.md` and `.dev-docs/.old/README.md`.

## [3.0.1] — 2026-05-25

### Fixed
- Duplicate prompt file `update-index.prompt.md` removed (canonical name is `ai-update-index.prompt.md`).
- `.gitignore` `.env.*` pattern no longer accidentally ignores committed `.env.example` template.
- `.env/` directory flattened to root-level `.env.example` to remove the file-vs-directory namespace collision.
- `.github/copilot-instructions.md` now has the required Contents TOC (its own rule from [TOC Requirement](.ai/conventions.md#toc-requirement)).
- `.ai/credentials.md` `Last Updated` field filled in.
- Duplicate `.dev-docs Convention` row removed from [`.ai/index.md` → Maintenance & Safety](.ai/index.md#maintenance--safety).
- README project structure diagram updated to match reality (`.archive/`, `.dev-docs/`, `.vscode/`, `.github/TODO/`, `.github/debug/`, `.github/tmp/`).
- `.vscode/settings.json` comment about `settings.local.json` corrected — VS Code does not auto-read that file.
- [Stale Instruction Files](.ai/maintenance.md#stale-instruction-files) step 3 disambiguated when the original directory no longer exists.
- `pre-commit` hook now uses NUL-delimited paths (`git diff -z` / `xargs -0`) for filename-safety.
- Light-touch deduplication: `.dev-docs` and date-auto-fill rules now have one canonical home and are linked from elsewhere.
- README footer points to the real `LICENSE` file instead of a `[LICENSE]` placeholder.

### Added
- `dev-specs.md` is now indexed in `.ai/index.md` and the meta explicitly instructs the AI to read it at session start.
- `.vscode/mcp.json` documented in [`.ai/index.md` → Meta & System](.ai/index.md#meta--system).
- `.github/prompts/ai-new-module.prompt.md` — slash command that scaffolds a new module's `.ai/instruct.md` and `.dev-docs/index.md`, updates the root key-directories table, and runs `/ai-update-index`.
- `.github/tmp/README.md` placeholder so the gitignored directory exists in fresh clones.
- Root `AGENTS.md` for non-Copilot agent tools (Codex, Claude Code, Aider, etc.).
- Root `LICENSE` file (MIT placeholder — edit before publishing).
- This `CHANGELOG.md`.

### Changed
- `.example-module/.ai/instruct.md` and `TEMPLATE-USAGE.md` updated to the flat per-module `.env` convention (matching `.ai/credentials.md`).
- The "AI-INSTRUCT drift check" claim was removed from the Git Hooks section of the meta because the hook does not implement it.

## [3.0.0] — Initial V3 release

- Depth-Priority Hierarchical AI-INSTRUCT system: per-directory `.ai/instruct.md` files with deeper-wins precedence.
- Global shared files in `.ai/`: `conventions.md`, `maintenance.md`, `credentials.md`, `index.md`.
- AI tooling under `.github/`: `copilot-instructions.md`, `dev-specs.md`, `prompts/`, `agents/`, `skills/`, `hooks/`.
- Slash commands: `/ai-update-index`, `/ai-archive`.
- Read-only `project-explorer` agent and `project-navigation` skill.
- Pre-commit hook for credential-leak detection.

---

## How to bump this template version

When you change the template structure (not a downstream project's content):

1. Update `Template Version` in `.github/copilot-instructions.md`.
2. Add an entry above under a new `## [X.Y.Z] — YYYY-MM-DD` heading.
3. Move items from `[Unreleased]` into the new version block.
