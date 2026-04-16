---
name: obi
description: Sync project documentation to Obsidian when the user says /obi, @obi, obi sync, /obi audit, /obi release, or asks to generate/update project docs in Obsidian.
---

# OBI Skill

Use this skill when the user triggers OBI with `/obi`, `@obi`, `obi sync`,
`/obi audit`, `/obi release`, or equivalent language about syncing docs to
Obsidian.

## Protocol

Read and follow:

- `~/.obi/protocol/OBI_PROTOCOL.md`
- `~/.obi/protocol/docs/command-contract.md`
- `~/.obi/protocol/docs/conflict-policy.md`
- `~/.obi/protocol/docs/project-detection.md`

## Local Config

Read `~/.obi/config.toml` if present. If it is missing, infer the vault path
from available Obsidian MCP/config context. Ask one concise question only if the
vault cannot be found.

## Write Path

Prefer Obsidian MCP tools if available. If unavailable, write markdown files
directly under the configured vault path. Never delete existing docs unless the
user explicitly asks.

## Default Behavior

- `/obi`: generate/update canonical project docs and write a sync report.
- `/obi audit`: report drift and conflicts. Do not modify docs unless asked.
- `/obi release`: update changelog and release-oriented notes from current work.

