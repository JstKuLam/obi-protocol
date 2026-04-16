# OBI Protocol

## Purpose

OBI turns a project repository into a small, consistent set of living Obsidian
documents. The AI agent must analyze the project, generate missing docs, update
existing canonical docs, and record what changed.

## Default Commands

- `/obi` or `@obi`: run project documentation sync.
- `/obi audit`: inspect docs for drift, duplicates, missing sections, and stale
  metadata without changing content unless the user asks.
- `/obi release`: generate release-focused notes from code, git history, and
  deployment context.

## Project Detection

1. If the current working directory is inside a repository or project folder,
   use that as the project.
2. If the user mentions a project name, search configured project roots and the
   Obsidian project index.
3. If multiple candidates remain, ask one concise clarification question.
4. If no project is found, stop and explain what information is needed.

## Document Set

Always maintain:

- `Index.md`
- `Overview.md`
- `Technical Spec.md`
- `Decision Log.md`
- `Changelog.md`
- `Sync Report.md`

Add when useful:

- `Requirements.md` for product/application work.
- `User Stories.md` for user-facing products.
- `Runbook.md` for deployment or infrastructure projects.
- `Operations.md` for bots, jobs, agents, and automations.

Do not generate every possible document by default. Choose the smallest useful
set based on project type.

## Canonical Layout

```text
Projects/<Project>/
  Index.md
  Overview.md
  Requirements.md
  User Stories.md
  Technical Spec.md
  Decision Log.md
  Changelog.md
  Runbook.md
  Operations.md
  Sync Report.md
  Archive/
```

## Update Policy

- Update active canonical docs in place.
- Create a new canonical file only when no active file exists.
- Archive old versions only for major scope, product, or architecture changes.
- Never create ad hoc names like `final`, `new`, `latest`, or date-suffixed
  canonical docs.
- `Changelog.md` is append-first and should not be versioned.

## Read Policy

When asked to read project docs:

1. Read `Index.md` first.
2. Prefer documents with `status: active`.
3. Ignore `Archive/` unless the user asks for history.
4. If no index exists, reconstruct it from frontmatter and create it during the
   next `/obi` sync.

## Write Policy

1. Prefer Obsidian MCP if available.
2. If MCP is unavailable, write directly to the configured vault path.
3. If the vault path is unknown, ask one concise question.
4. Never delete existing project docs unless the user explicitly asks.
5. Record every write in `Sync Report.md`.

## Quality Gates

Before finishing a sync:

- Every active doc has required frontmatter.
- `Index.md` links to the active canonical docs.
- `Sync Report.md` states generated files, updated files, sources, and uncertain
  assumptions.
- No duplicate active docs share the same `doc_type`.

