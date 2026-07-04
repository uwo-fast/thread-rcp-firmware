# thread-rcp-firmware

Reproducible firmware workflow for running an [ESP32-H2-DevKitM-1](https://docs.espressif.com/projects/esp-dev-kits/en/latest/esp32h2/esp32-h2-devkitm-1/user_guide.html#getting-started) as an OpenThread RCP.

## Prerequisites

### Linux (native, recommended)

- Python 3.9-3.13
- ESP-IDF (target baseline: v6.0 workflow)
- USB access to board on `/dev/ttyACM*`

### Windows (native)

- ESP-IDF via Espressif Installer Manager (EIM)
- ESP-IDF PowerShell terminal
- USB access to board on `COM*`

WSL2 is not supported for this workflow.

## Quick Start

### Linux

```bash
./scripts/setup.sh
. "${HOME}/esp/esp-idf/export.sh"
./scripts/doctor.sh
./scripts/build_rcp.sh
PORT=/dev/ttyACM0 ./scripts/flash_rcp.sh
PORT=/dev/ttyACM0 ./scripts/monitor.sh
```

### Windows (ESP-IDF PowerShell)

```powershell
# Open ESP-IDF PowerShell first (EIM shortcut)
cd firmware\rcp
idf.py set-target esp32h2
idf.py build
idf.py -p COM3 flash
idf.py -p COM3 monitor
```

## Documentation

- [docs/index.md](./docs/index.md)
- [docs/user-guide.md](./docs/user-guide.md)
- [docs/developer-docs.md](./docs/developer-docs.md)

## Docs Site

- Static site generator: MkDocs + Material
- Deploy model: GitHub Pages via GitHub Actions artifact deployment (`.github/workflows/pages.yml`)
- Site-only exclusion: `docs/retrospective.md` is kept in-repo but excluded from published site

## License

Original work in this repository (scripts, documentation, and CI) is licensed
under the [Apache License 2.0](LICENSE).

The firmware under `firmware/rcp/` is derived from the Espressif `ot_rcp` example
and remains under its upstream CC0-1.0 terms; see the SPDX headers in those files.
