# Developer Docs

This section is for maintainers working on firmware provenance, architecture, scripts, and validation policy.

## Maintainer Charter

### Purpose

This repository is the canonical, reproducible workflow for running ESP32-H2 as an OpenThread RCP. It exists to remove fragmented setup knowledge and unstable flashing practices.

### Scope Boundaries

In scope:

1. RCP firmware build, flash, validation, and troubleshooting.
2. Environment checks and deterministic script entry points.
3. Provenance tracking for upstream firmware baseline and local overrides.

Out of scope:

1. Sensor-node firmware provisioning.
2. Server application behavior beyond host-side RCP integration.
3. Fleet orchestration.

### Design Principles

1. Reproducibility over convenience.
2. Single source of truth in-repo.
3. Deterministic, scriptable workflows.
4. Clear separation of concerns.
5. Minimal abstraction unless it improves reliability.

### Success Criteria

A new maintainer can clone the repository, run setup, build/flash firmware, and verify operation without external guides or ad-hoc patching.

### Ownership And Change Rule

This repository is authoritative for the lab RCP workflow. Any intentional divergence from upstream firmware baseline must be captured in [Upstream Notes](upstream-notes.md).

## Core References

1. [User Guide](user-guide.md)
2. [Architecture](architecture.md)
3. [Flashing](flashing.md)
4. [Validation](validation.md)
5. [Troubleshooting](troubleshooting.md)
6. [Upstream Notes](upstream-notes.md)

## Repository Principles

1. Keep the workflow reproducible from a clean machine.
2. Prefer deterministic scripts over manual ad-hoc steps.
3. Keep terminology and operational instructions aligned across docs.

## GitHub Pages Publishing Model

This site deploys through GitHub Actions artifact deployment (not branch publishing).

1. `Settings -> Pages -> Build and deployment -> Source = GitHub Actions`
