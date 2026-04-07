# User Guide

This guide is for researchers who need to flash and commission an ESP32-H2 board as a Thread RCP device.

## 1) Prerequisites

### Linux (recommended)

1. USB cable connected to the **native ESP32-H2 USB port** on the dev board.
2. Shell access with Python available.
3. Repo cloned locally.

### Windows (native)

1. ESP-IDF installed via Espressif Installer Manager.
2. Use ESP-IDF PowerShell terminal.
3. USB cable connected to the **native ESP32-H2 USB port** on the dev board.

WSL2 is not supported for this workflow.

## 2) Board Connection And Port Detection

The ESP32-H2-DevKitM-1 has two USB-C ports. Use the **native ESP32-H2 USB port**, not the CP210x UART bridge port.

Find your board port:

Linux:

```bash
ls /dev/ttyACM*
```

Windows:

1. Open Device Manager.
2. Expand `Ports (COM & LPT)`.
3. Plug/unplug board to identify the `COM*` port.

## 3) Setup And Build

### Linux

```bash
./scripts/setup.sh
. "${HOME}/esp/esp-idf/export.sh"
./scripts/doctor.sh
./scripts/build_rcp.sh
```

### Windows (ESP-IDF PowerShell)

```powershell
cd firmware\rcp
idf.py set-target esp32h2
idf.py build
```

## 4) Upload (Flash) Firmware

### Linux

```bash
PORT=/dev/ttyACM0 ./scripts/flash_rcp.sh
```

### Windows

```powershell
idf.py -p COM3 flash
```

Replace `COM3` with your board port from Device Manager.

If Linux reports `Permission denied`, run:

```bash
sudo usermod -a -G dialout "$USER"
```

Then log out and back in.

Default workflow does not include `erase-flash` so NVS is preserved.

## 5) First-Flash Boot Mode (if needed)

If flash does not start on a blank board:

1. Hold `BOOT`.
2. Press and release `RESET`.
3. Release `BOOT`.
4. Retry flash.

After first successful programming, auto-reset is usually enough.

## 6) Commissioning Checklist

After uploading firmware, validate readiness before field use.

1. Open monitor and confirm stable boot:
   Linux:

```bash
PORT=/dev/ttyACM0 ./scripts/monitor.sh
```

Windows:

```powershell
idf.py -p COM3 monitor
```

2. Confirm no crash/reboot loops in serial output.
3. Confirm host-side Spinel link initializes without timeout errors.
4. Confirm target system can communicate over the Thread network.

## 7) Quick Recovery

If commissioning fails:

1. Re-check you are on native ESP32-H2 USB port (not UART bridge port).
2. Re-check port detection (`/dev/ttyACM*` or `COM*`).
3. Run clean rebuild:

```bash
cd firmware/rcp
idf.py fullclean
idf.py set-target esp32h2
idf.py build
```

4. Reflash and monitor again.

## 8) Validation Gates

Flashing alone is not success. Validate at four stages:

| Stage       | Check                       | Pass Criteria                                              | Fail Indicators                                                |
| ----------- | --------------------------- | ---------------------------------------------------------- | -------------------------------------------------------------- |
| 1. Flash    | Firmware upload result      | Exit code `0`, no write/hash errors                        | Non-zero exit, write failure, hash mismatch                    |
| 2. Boot     | Serial monitor output       | Clean startup, OpenThread RCP init messages, no crash loop | Guru Meditation, watchdog resets, reboot loop                  |
| 3. RCP Link | Host-side Spinel attach     | Host connects without timeout, stable agent process        | `spinelFrame` timeout, `TimeoutError`, repeated reset failures |
| 4. System   | End-to-end Thread operation | Nodes attach and telemetry flows to host stack             | Join failures, no traffic, unstable links                      |

Treat a board as deployment-ready only if all four stages pass.

## 9) Troubleshooting Triage

| Symptom                                         | Likely Cause                                            | Fix                                                                                    |
| ----------------------------------------------- | ------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| `/dev/ttyACM0` not found                        | Wrong cable, wrong USB port, disconnected board         | Use native ESP32-H2 USB port, verify cable, reconnect board                            |
| `Permission denied` on `/dev/ttyACM*`           | Linux user not in `dialout`                             | `sudo usermod -a -G dialout "$USER"` and log in again                                  |
| Flash repeatedly fails on first attempt         | Board not in download mode                              | Hold `BOOT`, tap `RESET`, release `BOOT`, retry flash                                  |
| Host reports `spinelFrame` timeouts             | Wrong hardware port (UART bridge instead of native USB) | Move cable to native ESP32-H2 USB port                                                 |
| Host reports `spinelFrame` timeouts after flash | Firmware built with UART transport                      | Confirm `CONFIG_OPENTHREAD_RCP_USB_SERIAL_JTAG=y`, then `idf.py fullclean` and rebuild |
| `idf.py: command not found`                     | ESP-IDF environment not loaded                          | Linux: `. "${HOME}/esp/esp-idf/export.sh"`; Windows: use ESP-IDF PowerShell            |
| Stale or inconsistent build behavior            | Old build cache / target residue                        | `cd firmware/rcp && idf.py fullclean && idf.py set-target esp32h2 && idf.py build`     |

Spinel timeout log pattern:

```text
universal_silabs_flasher.spinel DEBUG Device did not respond to reset
...
TimeoutError
[WARNING] otbr-agent exited with code 1
```

Recovery sequence:

1. Confirm cable is on native ESP32-H2 USB port.
2. Confirm host sees expected serial device (`/dev/ttyACM*` or `COM*`).
3. Confirm firmware transport symbol in `firmware/rcp/sdkconfig.defaults`.
4. Run clean rebuild.
5. Reflash and monitor boot logs.
