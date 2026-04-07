# Architecture

For operational commissioning steps, use [User Guide](user-guide.md). For maintainer policy and design constraints, use [Developer Docs](developer-docs.md).

## System Diagram

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

## RCP-Host Link

The host and RCP communicate using Spinel, a serial framing protocol used by OpenThread RCP deployments.

Transport path for this repository:

1. Host process (`otbr-agent` or other Spinel client)
2. USB cable
3. ESP32-H2 native USB Serial JTAG interface (CDC-ACM)
4. OpenThread RCP firmware
5. 802.15.4 radio

## Hardware Interface Choice

The ESP32-H2-DevKitM-1 has two USB-C ports:

1. Native ESP32-H2 USB (USB Serial/JTAG)
2. CP210x UART bridge

Canonical workflow uses the native ESP32-H2 USB port.

Reasons:

1. No extra driver install on Linux or Windows 10/11 for CDC-ACM.
2. Aligns with first-class `ot_rcp` USB transport configuration.
3. Removes bridge-chip path as an avoidable failure point for Spinel transport.

## Runtime Port Expectations

1. Linux: `/dev/ttyACM*` (typically `/dev/ttyACM0`)
2. Windows: `COM*`

## What Runs Where

1. ESP32-H2 board: OpenThread RCP firmware from `firmware/rcp`.
2. Host/server: Spinel client stack such as `otbr-agent`.

## Scope Boundaries

In scope:

1. RCP firmware build
2. RCP flashing
3. RCP validation and troubleshooting docs

Out of scope:

1. Sensor node firmware (for example ESPHome node YAML and node flashing)
2. Server application behavior beyond host-side Spinel attachment
3. Fleet orchestration
