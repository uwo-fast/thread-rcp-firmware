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

This repository is authoritative for the lab RCP workflow. Any intentional divergence from upstream firmware baseline must be captured in this page.

## Architecture Snapshot

For operational commissioning steps, use [User Guide](user-guide.md). This section captures the maintainer-facing system model and interface decisions.

### System Diagram

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

This repository owns only the RCP firmware layer.

### RCP-Host Link

The host and RCP communicate using Spinel.

Transport path for this repository:

1. Host process (`otbr-agent` or other Spinel client)
2. USB cable
3. ESP32-H2 native USB Serial JTAG interface (CDC-ACM)
4. OpenThread RCP firmware
5. 802.15.4 radio

### Hardware Interface Choice

The ESP32-H2-DevKitM-1 has two USB-C ports:

1. Native ESP32-H2 USB (USB Serial/JTAG)
2. CP210x UART bridge

Canonical workflow uses the native ESP32-H2 USB port.

Reasons:

1. No extra driver install on Linux or Windows 10/11 for CDC-ACM.
2. Aligns with first-class `ot_rcp` USB transport configuration.
3. Removes bridge-chip path as an avoidable failure point for Spinel transport.

### Runtime Port Expectations

1. Linux: `/dev/ttyACM*` (typically `/dev/ttyACM0`)
2. Windows: `COM*`

### What Runs Where

1. ESP32-H2 board: OpenThread RCP firmware from `firmware/rcp`.
2. Host/server: Spinel client stack such as `otbr-agent`.

## Core References

1. [User Guide](user-guide.md)
2. Retrospective document (internal-history context; excluded from published site)

## Repository Principles

1. Keep the workflow reproducible from a clean machine.
2. Prefer deterministic scripts over manual ad-hoc steps.
3. Keep terminology and operational instructions aligned across docs.

## Firmware Provenance And Local Overrides

### Canonical Upstream Source

1. Repository: `https://github.com/espressif/esp-idf`
2. Tag: `v6.0`
3. Commit: `662a3be35475` (detached HEAD from `git clone --depth 1 --branch v6.0`)
4. Example path: `examples/openthread/ot_rcp`
5. Verified and re-synced: `2026-04-07`

### Verification Summary

1. A direct diff showed the initial local `_reference/esp-idf-master` snapshot was not identical to upstream `v6.0`.
2. `firmware/rcp` was re-seeded directly from the verified upstream `v6.0` example.
3. After re-seed, only the intentional local overrides listed below are maintained.

### Local Modifications

1. `firmware/rcp/sdkconfig.defaults`
2. Added:
   `CONFIG_OPENTHREAD_RCP_SPINEL_CONSOLE=y`
   `CONFIG_LOG_DEFAULT_LEVEL_INFO=y`
   `CONFIG_OPENTHREAD_RCP_USB_SERIAL_JTAG=y`
3. Reason:

- Enables RCP Spinel console by default and raises default log level for operational diagnostics.
- Selects native USB Serial JTAG transport (native ESP32-H2 USB port, `/dev/ttyACM*` or `COM*`) instead of UART bridge transport.

4. Symbol reference:
   `examples/openthread/ot_rcp/sdkconfig.ci.rcp_usb`

## GitHub Pages Publishing Model

This site deploys through GitHub Actions artifact deployment (not branch publishing).

1. `Settings -> Pages -> Build and deployment -> Source = GitHub Actions`
