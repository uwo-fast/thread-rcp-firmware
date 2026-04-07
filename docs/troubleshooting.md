# Troubleshooting

## Quick Triage Table

| Symptom                                         | Likely Cause                                            | Fix                                                                                    |
| ----------------------------------------------- | ------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| `/dev/ttyACM0` not found                        | Wrong cable, wrong USB port, disconnected board         | Use ESP32-H2 native USB port, verify cable, reconnect board                            |
| `Permission denied` on `/dev/ttyACM*`           | Linux user not in `dialout`                             | `sudo usermod -a -G dialout "$USER"` and log in again                                  |
| Flash repeatedly fails on first attempt         | Board not in download mode                              | Hold `BOOT`, tap `RESET`, release `BOOT`, retry flash                                  |
| Host reports `spinelFrame` timeouts             | Wrong hardware port (UART bridge instead of native USB) | Move cable to native ESP32-H2 USB port                                                 |
| Host reports `spinelFrame` timeouts after flash | Firmware built with UART transport                      | Confirm `CONFIG_OPENTHREAD_RCP_USB_SERIAL_JTAG=y`, then `idf.py fullclean` and rebuild |
| `idf.py: command not found`                     | ESP-IDF environment not loaded                          | Linux: `. "${HOME}/esp/esp-idf/export.sh"`; Windows: use ESP-IDF PowerShell            |
| Stale or inconsistent build behavior            | Old build cache / target residue                        | `cd firmware/rcp && idf.py fullclean && idf.py set-target esp32h2 && idf.py build`     |

## Spinel Timeout Pattern

A transport mismatch often surfaces as repeated reset/timeout behavior in host logs. Typical pattern:

```text
universal_silabs_flasher.spinel DEBUG Device did not respond to reset
...
TimeoutError
[WARNING] otbr-agent exited with code 1
```

## Recovery Sequence

1. Confirm cable is on native ESP32-H2 USB port.
2. Confirm host sees expected serial device (`/dev/ttyACM*` or `COM*`).
3. Confirm firmware transport symbol in `firmware/rcp/sdkconfig.defaults`.
4. Run clean rebuild.
5. Reflash and monitor boot logs.
