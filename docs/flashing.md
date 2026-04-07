# Flashing

This page is a flashing deep dive. For the canonical end-to-end process, use [User Guide](user-guide.md).

## Supported Host Environments

1. Linux (native, recommended)
2. Windows (native)

WSL2 is not supported for this workflow.

## Select The Correct USB Port

The ESP32-H2-DevKitM-1 has two USB-C ports. Use the **native ESP32-H2 USB port**, not the CP210x UART bridge port.

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

After first successful programming, auto-reset is usually enough.

## Flash Command Examples

Linux:

```bash
PORT=/dev/ttyACM0 ./scripts/flash_rcp.sh
```

Windows (ESP-IDF PowerShell):

```powershell
idf.py -p COM3 flash
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
3. Baseline provenance and local upstream deviations are tracked in [Upstream Notes](upstream-notes.md).
4. For complete setup/build/commissioning sequence, return to [User Guide](user-guide.md).
