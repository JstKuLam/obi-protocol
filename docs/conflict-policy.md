# Conflict Policy

## Canonical Resolution

If multiple docs could represent the same thing:

1. Prefer `status: active`.
2. Prefer the highest `version`.
3. Prefer the file linked from `Index.md`.
4. If still ambiguous, ask one concise question.

## Archiving

Archive only when the existing doc is no longer a valid representation of the
project because of a major product, scope, or architecture change.

Archive path:

```text
Projects/<Project>/Archive/<DocName>.v<N>.md
```

The active replacement keeps the canonical name:

```text
Projects/<Project>/<DocName>.md
```

## Forbidden Names

Do not create canonical docs with:

- `final`
- `new`
- `latest`
- date suffixes
- random model names

