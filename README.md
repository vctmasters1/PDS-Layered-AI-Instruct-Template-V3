# [PROJECT_NAME]

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Copilot Ready](https://img.shields.io/badge/Copilot-ready-blueviolet)](.github/copilot-instructions.md)
[![AGENTS.md](https://img.shields.io/badge/AGENTS.md-discoverable-success)](AGENTS.md)
[![Template V3](https://img.shields.io/badge/PDS_AI--INSTRUCT-V3-informational)](.github/copilot-instructions.md)

> [One-sentence description of what this project does.]

---

## Why this template

This project is built on the **Depth-Priority Hierarchical AI-INSTRUCT V3** system: per-directory `.ai/instruct.md` files where **the deepest file always wins**. Coding agents (Copilot, Codex, Cursor, Aider) get the *right* rules at the *right* scope, automatically.

```mermaid
flowchart TD
    Meta[".github/copilot-instructions.md<br/>META: how layering works"] --> Root[".ai/instruct.md<br/>workspace-root authority"]
    Root --> ModA["[module-a]/.ai/instruct.md<br/>module authority"]
    Root --> ModB["[module-b]/.ai/instruct.md<br/>module authority"]
    ModA --> SubA1["[module-a]/[sub]/.ai/instruct.md<br/>deepest wins"]
    classDef meta fill:#eef,stroke:#88f;
    classDef root fill:#efe,stroke:#494;
    classDef mod fill:#fff,stroke:#aaa;
    classDef deep fill:#fee,stroke:#c44;
    class Meta meta;
    class Root root;
    class ModA,ModB mod;
    class SubA1 deep;
```

### How the pieces fit together

```mermaid
flowchart LR
    subgraph github[".github/"]
        Meta["copilot-instructions.md<br/>(META rules)"]
        Specs["dev-specs.md<br/>(platform facts)"]
        Prompts["prompts/<br/>/ai-onboard, /ai-commit,<br/>/ai-new-module, /ai-validate,<br/>/ai-update-index, /ai-archive"]
        Agents["agents/<br/>project-explorer (read-only)"]
        Skills["skills/<br/>project-navigation"]
        Hooks["hooks/<br/>pre-commit credential check"]
        Scripts["scripts/<br/>validate-instructions.ps1"]
    end

    subgraph ai[".ai/ (cross-cutting)"]
        Conv["conventions.md"]
        Maint["maintenance.md"]
        Creds["credentials.md"]
        Index["index.md (master)"]
    end

    Root[".ai/instruct.md<br/>root authority"]
    ModRules["[module]/.ai/instruct.md<br/>module authority"]
    Code["your source code"]

    Meta -.governs.-> Root
    Specs -.consulted by.-> Root
    Root --> ModRules
    ModRules --> Code

    Conv & Maint & Creds -.linked from.-> Root
    Conv & Maint & Creds -.linked from.-> ModRules
    Index -.indexes.-> Conv
    Index -.indexes.-> Maint
    Index -.indexes.-> Creds
    Index -.indexes.-> Root
    Index -.indexes.-> ModRules

    Prompts -.act on.-> Root
    Prompts -.act on.-> ModRules
    Agents -.scoped to.-> Code
    Skills -.briefed for.-> Code
    Hooks -.gate.-> Code
    Scripts -.audit.-> Root
    Scripts -.audit.-> ModRules

    classDef meta fill:#eef,stroke:#88f;
    classDef ai fill:#efe,stroke:#494;
    classDef code fill:#fff,stroke:#aaa;
    classDef gate fill:#fee,stroke:#c44;
    class Meta,Specs,Prompts,Agents,Skills meta;
    class Conv,Maint,Creds,Index,Root,ModRules ai;
    class Code code;
    class Hooks,Scripts gate;
```

Read the **vertical** chain (Meta → Root → Module → Code) as authority. Read the **`.ai/` cross-cutting block** as shared rules that any layer can link to without restating. Read **prompts / agents / skills / hooks / scripts** as tools that act on or audit the system.

What you get out of the box:

- **Layered rules** — global rules in [`.ai/`](.ai/), module-specific overrides per directory.
- **Slash commands** — `/ai-onboard`, `/ai-new-module`, `/ai-archive`, `/ai-update-index`, `/ai-validate`, `/ai-commit`.
- **Custom agents & skills** — read-only exploration agent, navigation skill, room to add your own.
- **Safety built-in** — pre-commit credential block, never-delete + archive convention, never-reset-db rule.
- **Multi-tool ready** — Copilot, Codex (via [AGENTS.md](AGENTS.md)), Cursor (via [`.cursor/rules/`](.cursor/rules/)), Aider.
- **Filled-in examples** — see [`.examples/`](.examples/) for `auth-api` (with real TypeScript code), `data-layer`, and `ui-component` showcases with **before/after** AI behavior.

---

## Quick Start

```bash
# 1. Clone
git clone [repo-url]
cd [project-name]

# 2. One-shot setup (installs hooks, scaffolds .env, runs validator)
bash setup.sh             # macOS / Linux / WSL / Git Bash
pwsh setup.ps1            # Windows PowerShell

# 3. Open in VS Code with Copilot, then in Copilot Chat:
#       /ai-onboard
#    (interactive wizard fills in every [PLACEHOLDER])

# 4. [Add your start commands here]
```

---

## Project Structure

```
[PROJECT_NAME]/
├── .github/                     ← AI tooling: instructions, prompts, agents, hooks
│   ├── copilot-instructions.md  ← META: how the .ai/ instruction system works
│   ├── dev-specs.md             ← Dev platform, target platform, frameworks config
│   ├── prompts/                 ← Slash-command prompt files (`/ai-*`)
│   ├── agents/                  ← Custom Copilot agents
│   ├── skills/                  ← Domain knowledge skill packs
│   ├── hooks/                   ← Git hook scripts (run install-hooks.sh / .ps1 to activate)
│   ├── todo/                    ← Project-level TODO list
│   ├── debug/                   ← AI-generated debug scripts (gitignored except README)
│   └── tmp/                     ← Ephemeral output files (gitignored except README)
│
├── .ai/                         ← Global shared instruction files
│   ├── instruct.md              ← Root-level authoritative AI instructions
│   ├── conventions.md           ← Naming and organization rules
│   ├── maintenance.md           ← Archive, never-delete, never-reset-db rules
│   ├── credentials.md           ← Credential warehousing and security rules
│   └── index.md                 ← Master index of all instruction sections
│
├── .vscode/                     ← Shared editor/MCP settings (committed)
├── .dev-docs/                   ← Dev notes for the workspace root (index + .old/)
├── .archive/                    ← Retired files, path-mirrored (read-only reference)
├── .example-module/             ← Bare scaffold for a new module
├── .examples/                   ← Filled-in module showcases (auth-api, data-layer, ui-component)
├── .cursor/rules/               ← Cursor pointer rules → .ai/ (no rule duplication)
│
├── .env.example                 ← Environment variable template (committed)
├── .gitignore
├── AGENTS.md                    ← Discovery anchor for non-Copilot AI agents
├── CHANGELOG.md
├── LICENSE
├── setup.sh / setup.ps1         ← One-shot installer (hooks + .env + validator)
├── TEMPLATE-USAGE.md            ← How to adapt this template to your project
└── README.md                    ← This file
```

---

## Documentation

| Document | Description |
|----------|-------------|
| [.ai/instruct.md](.ai/instruct.md) | Project architecture and rules for AI |
| [.ai/index.md](.ai/index.md) | Master index of all AI instruction sections |
| [TEMPLATE-USAGE.md](TEMPLATE-USAGE.md) | How to adapt this template to your project |

---

## AI Copilot Quick Reference

This project uses the **Depth-Priority Hierarchical AI-INSTRUCT** system. The authoritative inventory of slash commands, custom agents, and skills lives in [.ai/index.md → Meta & System](.ai/index.md#meta--system). Run `/ai-onboard` in Copilot Chat on a fresh clone to fill in every placeholder.

---

## License

See [LICENSE](LICENSE).
