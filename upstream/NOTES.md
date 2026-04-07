## Firmware Provenance

Source path used for this Phase 0 bootstrap:

- Local snapshot: `_reference/esp-idf-master/examples/openthread/ot_rcp`
- Upstream project: https://github.com/espressif/esp-idf/tree/v6.0/examples/openthread/ot_rcp
- Copied: 2026-04-07

Notes:

- The source was copied from a local mirror named `esp-idf-master`.
- The intended canonical upstream baseline for this repo is ESP-IDF `v6.0`.
- On the next sync pass, validate the copied example against the upstream `v6.0` tag and update this note with the exact commit/tag evidence used.

## Modifications

1. `sdkconfig.defaults`
Changed:
`CONFIG_OPENTHREAD_RCP_USB_SERIAL_JTAG=y`

Reason:
Selects native USB Serial JTAG transport (ESP32-H2 USB Type-C port) instead of UART bridge transport.

Symbol reference:
`examples/openthread/ot_rcp/sdkconfig.ci.rcp_usb`
