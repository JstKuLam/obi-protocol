# Project Detection

Use this order:

1. Current working directory repository root.
2. Current working directory project folder.
3. Project name explicitly mentioned by the user.
4. Configured `projects_root`.
5. Existing Obsidian `Projects/*/Index.md`.

Project name normalization:

- Keep filesystem name as stable project id.
- Use title case only for display title.
- Avoid renaming existing project folders.

