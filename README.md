# OBI Protocol

OBI is a portable protocol for syncing AI-generated project documentation into
an Obsidian vault. It is designed to work across Codex, Claude, Antigravity, and
other IDE/CLI agents with minimal per-tool adapters.

## Goals

- Let users trigger documentation sync with `/obi`, `@obi`, or `obi sync`.
- Generate missing project docs instead of only copying existing markdown.
- Keep one canonical active doc per type to avoid Obsidian clutter.
- Prefer Obsidian MCP when available, with direct filesystem writes as fallback.
- Keep local paths and vault details out of the Git repo.

## Setup Modes

- `obi setup full`: install/check Obsidian, select or create a vault, configure
  adapters, and run a smoke test.
- `obi setup existing`: use an existing vault and configure protocol/adapters.
- `obi setup repo`: add project/team rules without personal paths.
- `obi doctor`: validate vault, config, adapters, and read/write access.
- `obi uninstall`: remove OBI-managed adapter blocks and files.

## Install

```bash
git clone https://github.com/JstKuLam/obi-protocol ~/.obi/protocol
bash ~/.obi/protocol/scripts/install.sh
```

For local development from a checkout:

```bash
bash ./scripts/install.sh
```

## Common Setup

Full setup for a new or existing local Obsidian install:

```bash
obi setup full --vault-name MyBrain --vault-path "$HOME/Documents/Obsidian/MyBrain" --ide all
```

Existing vault setup:

```bash
obi setup existing --vault-path "$HOME/Documents/Obsidian/MyBrain" --ide all
```

Repo/team adapter only:

```bash
obi setup repo --repo-path "$PWD" --ide antigravity
```

Validate the local setup:

```bash
obi doctor
```

Full setup never deletes existing Obsidian vaults. GUI pickers are optional in
future adapters; CLI flags are the compatibility baseline.

## Default Vault Config

Local machine config lives at:

```text
~/.obi/config.toml
```

Example:

```toml
vault_path = "/Users/example/Documents/Obsidian/MyVault"
projects_root = "/Users/example/Projects"
default_project_folder = "Projects"
write_mode = "mcp-preferred"
canonical_policy = "update-active-docs"
```

## Trigger Contract

The following phrases should activate OBI in supported AI tools:

- `/obi`
- `@obi`
- `obi sync`
- `đẩy docs lên Obsidian`
- `sync tài liệu sang Obsidian`

See [OBI_PROTOCOL.md](./OBI_PROTOCOL.md) for the full behavior.
