# OBI Command Contract

## `/obi`

Generate or update project docs in Obsidian.

Expected behavior:

- Detect project.
- Read repo context and existing Obsidian docs.
- Classify project type.
- Generate the minimal useful document set.
- Update active canonical docs.
- Write a sync report.

## `/obi audit`

Audit only unless the user asks to repair.

Checks:

- Missing `Index.md`.
- Missing required frontmatter.
- Multiple active docs with the same `doc_type`.
- Stale docs where `updated_at` is older than project changes.
- Changelog missing recent material changes.

## `/obi release`

Generate release notes and release-oriented changelog entries.

Inputs:

- Git diff/status/log when available.
- Deployment notes and runbooks.
- Existing active docs.

