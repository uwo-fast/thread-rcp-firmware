#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
: "${IDF_PATH:?IDF_PATH not set - run: . \${HOME}/esp/esp-idf/export.sh}"

if ! command -v idf.py >/dev/null 2>&1; then
    echo "ERROR: idf.py not found on PATH."
    echo "Run: . \${HOME}/esp/esp-idf/export.sh"
    exit 1
fi

if [ ! -d "${REPO_ROOT}/firmware/rcp" ]; then
    echo "ERROR: Missing firmware project: ${REPO_ROOT}/firmware/rcp"
    exit 1
fi

cd "${REPO_ROOT}/firmware/rcp"
idf.py set-target esp32h2
idf.py build
