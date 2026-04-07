# Flashing

## Prerequisites

### Linux (native)

1. ESP-IDF toolchain installed (`./scripts/setup.sh`).
2. ESP-IDF environment loaded in current shell:
`. "${HOME}/esp/esp-idf/export.sh"`
3. USB-connected ESP32-H2-DevKitM-1 on native ESP32-H2 USB port.
4. User has serial permissions (see Linux permission fix section).

### Windows (native)

1. ESP-IDF installed via Espressif Installer Manager.
2. ESP-IDF PowerShell terminal.
3. USB-connected ESP32-H2-DevKitM-1 on native ESP32-H2 USB port.

Use native Linux or native Windows. WSL2 is not a supported path for this workflow.

## Select The Correct USB Port

The ESP32-H2-DevKitM-1 has two USB-C ports. Use the native ESP32-H2 USB port, not the CP210x UART bridge port.

## Find Your Device Port

### Linux

```bash
ls /dev/ttyACM*
```

Expected result with board connected: one of the listed devices is typically `/dev/ttyACM0`.

### Windows

1. Open Device Manager.
2. Expand `Ports (COM & LPT)`.
3. Plug and unplug the board to confirm which `COM` port appears.

## First Flash On A Blank Board

If first flash does not auto-enter download mode:

1. Hold `BOOT`.
2. Press and release `RESET` once.
3. Release `BOOT`.
4. Retry flash command.

After first successful programming, auto-reset is usually sufficient.

## Full Linux Flash Sequence

```bash
. "${HOME}/esp/esp-idf/export.sh"
./scripts/doctor.sh
./scripts/build_rcp.sh
PORT=/dev/ttyACM0 ./scripts/flash_rcp.sh
PORT=/dev/ttyACM0 ./scripts/monitor.sh
```

If your board enumerates as a different ACM port, replace `/dev/ttyACM0`.

## Full Windows Flash Sequence (ESP-IDF PowerShell)

```powershell
cd firmware\rcp
idf.py set-target esp32h2
idf.py build
idf.py -p COM3 flash
idf.py -p COM3 monitor
```

Replace `COM3` with your detected port.

## Linux Permission Fix

If flashing fails with `Permission denied`:

```bash
sudo usermod -a -G dialout "$USER"
```

Then log out and log back in before retrying.

## Notes

1. Default flow does not include `erase-flash` because that wipes NVS.
2. If transport mismatch is suspected, verify `CONFIG_OPENTHREAD_RCP_USB_SERIAL_JTAG=y` in `firmware/rcp/sdkconfig.defaults`, then run `idf.py fullclean` and rebuild.
