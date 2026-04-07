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

## 2) Setup And Build

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

## 3) Upload (Flash) Firmware

### Linux

```bash
PORT=/dev/ttyACM0 ./scripts/flash_rcp.sh
```

### Windows

```powershell
idf.py -p COM3 flash
```

Replace `COM3` with your board port from Device Manager.

## 4) First-Flash Boot Mode (if needed)

If flash does not start on a blank board:

1. Hold `BOOT`.
2. Press and release `RESET`.
3. Release `BOOT`.
4. Retry flash.

## 5) Commissioning Checklist

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

## 6) Quick Recovery

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

## Related Docs

1. [Flashing](flashing.md)
2. [Validation](validation.md)
3. [Troubleshooting](troubleshooting.md)
