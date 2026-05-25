# [PROJECT_NAME]

> [One-sentence description of what this project does.]

---

## Quick Start

```bash
# 1. Clone and install
git clone [repo-url]
cd [project-name]

# 2. Install git hooks (credential safety checks)
bash .github/hooks/install-hooks.sh        # or: pwsh .github/hooks/install-hooks.ps1

# 3. Set up environment variables
cp .env.example .env
# Edit .env with your actual values

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
├── .example-module/             ← Example module with its own .ai/instruct.md
│
├── .env.example                 ← Environment variable template (committed)
├── .gitignore
├── AGENTS.md                    ← Discovery anchor for non-Copilot AI agents
├── CHANGELOG.md
├── LICENSE
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
