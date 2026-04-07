# Validation

Flashing alone is not success. Validate at four stages.

## Validation Matrix

| Stage | Check | Pass Criteria | Fail Indicators |
| --- | --- | --- | --- |
| 1. Flash | `idf.py flash` result | Exit code `0`, no write/hash errors | Non-zero exit, write failure, hash mismatch |
| 2. Boot | Serial monitor output | Clean startup, OpenThread RCP init messages, no crash loop | Guru Meditation, watchdog resets, reboot loop |
| 3. RCP Link | Host-side Spinel attach | Host connects without timeout, stable agent process | `spinelFrame` timeout, `TimeoutError`, repeated reset failures |
| 4. System | End-to-end Thread operation | Nodes attach and telemetry flows to host stack | Join failures, no traffic, unstable links |

## Stage 1 And 2 Commands (Linux)

```bash
. "${HOME}/esp/esp-idf/export.sh"
./scripts/build_rcp.sh
PORT=/dev/ttyACM0 ./scripts/flash_rcp.sh
PORT=/dev/ttyACM0 ./scripts/monitor.sh
```

## Stage 3 Expectations

When host stack attaches to the RCP:

1. No repeated `Device did not respond to reset`.
2. No immediate `TimeoutError`.
3. Host agent remains running.

## Stage 4 Expectations

System validation is external to this repo but required for release confidence:

1. Thread network forms or rejoins correctly.
2. Sensor nodes attach.
3. Data reaches host/server pipeline.

## Release Gate

Treat a board as deployment-ready only if all four stages pass.
