# Retrospective

## Purpose

This document preserves high-value historical context from early bootstrap notes while removing raw email dumps, personal contact data, and planning noise.

It exists so future maintainers can understand why this repository was created and what decisions shaped the current workflow.

## Background

In early 2026, a field deployment issue was traced to an RCP reliability problem at a site referenced as "Allister". Existing flashing guidance in circulation was fragmented and required manual adaptation (including cross-target substitutions and WSL-specific steps), which increased risk and slowed response.

This repository was created to establish one canonical, reproducible ESP32-H2 OpenThread RCP workflow owned by the project team.

## Timeline (Condensed)

1. February 9-23, 2026: Site-visit coordination and schedule churn.
2. March 18, 2026: RCP suspected as root cause; legacy references shared (OpenThread codelab and separate ad-hoc instructions).
3. March 31-April 7, 2026: Urgent requests for walkthrough and pre-site remediation steps.
4. April 7-8, 2026: Critical-path objective set: flash and validate spare ESP32-H2 RCP before on-site fix window.
5. April 2026 (this repo bootstrap): Phases 0-2 executed to move from ad-hoc instructions to a repo-native workflow (firmware baseline, scripts, and operational docs).

## Key Decisions Preserved

1. Use ESP32-H2 native USB Serial/JTAG transport (`/dev/ttyACM*` or `COM*`) as canonical path.
2. Do not use the CP210x UART bridge as the default RCP transport path.
3. Support native Linux and native Windows workflows; do not support WSL2 in canonical docs.
4. Pin expected ESP-IDF line to `v6.0.x` and fail fast on environment mismatches.
5. Keep this repository scoped to RCP firmware lifecycle (build, flash, validate, troubleshoot).
6. Keep sensor-node provisioning/configuration artifacts out of the RCP firmware tree.

## What Was Intentionally Excluded

1. Raw email thread content.
2. Personal contact information and signatures.
3. Emotional/internal commentary from early scratch notes.
4. Redundant planning text already implemented in scripts/docs.

## Open Historical Note

An ESPHome sensor YAML attachment was referenced during incident coordination and is not part of this repository by design. Sensor-node configuration should live in a separate sensor-firmware repository.

## Source Provenance For This Retrospective

This summary was distilled from the now-removed `working/` planning and legacy context files that were used during repository bootstrap.
