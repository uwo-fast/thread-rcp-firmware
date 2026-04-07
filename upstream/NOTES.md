## Firmware Provenance

Canonical upstream source:

- Repository: `https://github.com/espressif/esp-idf`
- Tag: `v6.0`
- Commit: `662a3be35475` (detached HEAD from `git clone --depth 1 --branch v6.0`)
- Example path: `examples/openthread/ot_rcp`
- Verified and re-synced: `2026-04-07`

Verification summary:

1. A direct diff showed the initial local `_reference/esp-idf-master` snapshot was not identical to upstream `v6.0`.
2. `firmware/rcp` was re-seeded directly from the verified upstream `v6.0` example.
3. After re-seed, only one intentional local config override is maintained (see below).

## Local Modifications

1. `sdkconfig.defaults`
Added:
`CONFIG_OPENTHREAD_RCP_USB_SERIAL_JTAG=y`

Reason:
Selects native USB Serial JTAG transport (ESP32-H2 USB Type-C port, `/dev/ttyACM*` or `COM*`) instead of UART bridge transport.

Symbol reference:
`examples/openthread/ot_rcp/sdkconfig.ci.rcp_usb`
