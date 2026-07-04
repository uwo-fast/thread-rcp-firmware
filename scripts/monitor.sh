#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=/dev/null
[ -f "${REPO_ROOT}/.env" ] && { set -a; . "${REPO_ROOT}/.env"; set +a; }
PORT="${PORT:-/dev/ttyACM0}"
: "${IDF_PATH:?IDF_PATH not set - run: . \${HOME}/esp/esp-idf/export.sh}"

if ! command -v idf.py >/dev/null 2>&1; then
    echo "ERROR: idf.py not found on PATH."
    echo "Run: . \${HOME}/esp/esp-idf/export.sh"
    exit 1
fi

cd "${REPO_ROOT}/firmware/rcp"
idf.py -p "${PORT}" monitor
