# Developer Docs

This section is for maintainers working on firmware provenance, architecture, scripts, or validation policy.

## Core References

1. [Architecture](architecture.md)
2. [Flashing](flashing.md)
3. [Validation](validation.md)
4. [Troubleshooting](troubleshooting.md)
5. [Upstream Notes](upstream-notes.md)

## Repository Principles

1. Keep the workflow reproducible from a clean machine.
2. Prefer deterministic scripts over manual ad-hoc steps.
3. Track all upstream divergence in `upstream-notes.md`.
4. Keep scope focused on RCP firmware lifecycle.

## GitHub Pages Publishing Model

This site is intended to deploy through GitHub Actions artifact deployment (not branch publishing).

Repository setting expected:

1. `Settings -> Pages -> Build and deployment -> Source = GitHub Actions`
