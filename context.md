# context.md

## Purpose

This repository exists to provide a **canonical, reproducible, lab-owned firmware and workflow** for running an ESP32-H2 as a Thread Radio Co-Processor (RCP).

The goal is to eliminate:

- fragmented guides
- implicit setup knowledge
- environment inconsistencies
- unreliable flashing workflows

This repo is the **single source of truth** for:

- building RCP firmware
- flashing target hardware
- validating correct operation
- troubleshooting failures

---

## System Context

The system this firmware participates in is structured as:

```text
[ Sensor Node(s) ]
        |
        v
[ Thread Network ]
        |
        v
[ RCP (ESP32-H2 running OpenThread firmware) ]
        |
        v
[ Host / Server ]
```

This repository is responsible for **only one layer**:


> The RCP firmware running on the ESP32-H2

It does **not** directly manage:

- sensor firmware (ESPHome or otherwise)
- application/server logic
- higher-level network orchestration

---

## Design Principles

### 1. Reproducibility over convenience

The system must:

- work from a clean machine
- produce identical results across environments
- avoid reliance on undocumented state

### 2. Single source of truth

- No external guides required to build/flash
- No "follow this gist + modify this example"
- All required logic and instructions live in this repo

### 3. Deterministic workflow

Every step must be:

- scriptable
- testable
- verifiable

No manual, ambiguous, or interpretation-based steps.

### 4. Clear separation of concerns

This repo focuses on:

- RCP firmware build + flash + validation

It does **not** mix:

- sensor logic
- application-level networking
- unrelated embedded targets

### 5. Minimal abstraction

Avoid unnecessary tooling layers unless they:

- reduce complexity
- improve reliability

Vendor-native tools (ESP-IDF) are preferred over wrappers unless proven stable.

---

## Scope

### Included

- ESP32-H2 RCP firmware (based on ESP-IDF OpenThread)
- Build scripts
- Flashing scripts
- Environment setup and validation
- Documentation for usage and debugging
- Version pinning and configuration

### Not Included

- Sensor node firmware (ESPHome, etc.)
- Thread network orchestration logic
- Server-side configuration
- Multi-device fleet management

---

## Repository Structure

```text
.
|- firmware/
|  `- rcp/                 # ESP-IDF project (RCP firmware)
|
|- scripts/
|  |- setup.sh             # environment setup
|  |- doctor.sh            # environment + device validation
|  |- build_rcp.sh         # canonical build entrypoint
|  |- flash_rcp.sh         # canonical flash entrypoint
|  `- monitor.sh           # serial monitor
|
|- docs/
|  |- architecture.md
|  |- flashing.md
|  |- validation.md
|  |- troubleshooting.md
|  |- retrospective.md
|  `- upstream-notes.md
|
|- env.example
|- requirements.txt        # Python dependencies
|
`- context.md              # this file
```

---

## Workflow Overview

### High-level flow

1. Setup environment
2. Build firmware
3. Flash device
4. Validate operation

### Canonical usage

```bash
git clone <repo>
cd thread-rcp-firmware

./scripts/setup.sh
. "${HOME}/esp/esp-idf/export.sh"
./scripts/doctor.sh
./scripts/build_rcp.sh
PORT=/dev/ttyACM0 ./scripts/flash_rcp.sh
PORT=/dev/ttyACM0 ./scripts/monitor.sh
```

This is the **only supported workflow** initially.

---

## Firmware Source Strategy

The RCP firmware is:

- derived from ESP-IDF OpenThread examples
- copied into this repository
- modified for:
  - ESP32-H2 target
  - lab-specific configuration
  - stability and reproducibility

We **do not depend directly on upstream examples at runtime**.

### Rationale

Upstream examples:

- change structure over time
- are not guaranteed stable
- require manual adaptation

This repo:

- freezes a known-good baseline
- documents all modifications
- ensures consistent behavior

---

## Versioning and Pinning

All critical dependencies must be pinned:

- ESP-IDF version
- Python version range
- required Python packages
- firmware configuration defaults

Builds must fail clearly if:

- versions mismatch
- required tools are missing

---

## Environment Model

Two supported environments:

- **Linux (native)** - recommended; all scripts run natively; device shows as `/dev/ttyACM0`
- **Windows (native)** - via ESP-IDF installer (EIM) + ESP-IDF PowerShell terminal; device shows as `COM*`

macOS is not yet validated. WSL2 is not supported.

### Requirements

- Python (pinned version range)
- ESP-IDF toolchain
- USB serial access to device

All requirements are enforced via `setup.sh` and `doctor.sh`.

---

## Validation Philosophy

Flashing is not success.

Success requires validation at multiple levels.

### Stage 1 - Flash validation

- device accepts firmware
- no flashing errors

### Stage 2 - Runtime validation

- device boots correctly
- logs accessible via serial

### Stage 3 - RCP validation

- RCP responds to expected interface
- no crashes or resets

### Stage 4 - System validation (external)

- Thread network communication works
- integration with host confirmed

Each stage must be documented, testable, and repeatable.

---

## Failure Model

Common failure domains:

### Firmware

- incorrect target (e.g., `esp32c6` vs `esp32h2`)
- incompatible `sdkconfig`
- build errors

### Flashing

- serial port issues
- incorrect permissions
- partial/failed flash

### Environment

- ESP-IDF mismatch
- Python dependency issues
- broken toolchain

### Hardware

- faulty dev board
- incorrect wiring
- power instability

### Network / System

- Thread network not forming
- RCP not recognized by host

---

## Development Guidelines

### Modifying firmware

- changes must be documented in `docs/upstream-notes.md`
- must be reproducible from a clean state
- avoid ad-hoc local patches

### Adding scripts

- scripts must be idempotent
- fail loudly on error
- avoid hidden assumptions

### Documentation

- every required step must be documented
- no reliance on external guides unless explicitly referenced

---

## Anti-Patterns (Avoid)

- "Follow this guide + apply these patches manually"
- "Works on my machine" setups
- implicit environment dependencies
- mixing unrelated firmware targets
- unpinned toolchains
- requiring IDE-specific workflows

---

## Future Extensions (Not Initial Priority)

- sensor node firmware integration
- containerized dev environments
- CI validation (build + lint)
- prebuilt firmware artifacts
- multi-board support
- automated hardware testing

---

## Success Criteria

This repository is successful when a new user can:

1. clone the repo
2. run setup
3. flash firmware
4. verify operation

without external guidance, manual patching, or debugging environment issues.

---

## Ownership

This repository is the **authoritative implementation** of the lab's RCP firmware workflow.

Changes should prioritize clarity, reproducibility, and long-term maintainability over convenience hacks or short-term fixes.
