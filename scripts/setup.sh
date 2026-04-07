#!/usr/bin/env bash
set -euo pipefail

IDF_VERSION="${IDF_VERSION:-v6.0}"
IDF_DIR="${IDF_DIR:-${HOME}/esp/esp-idf}"

if [ -d "${IDF_DIR}/.git" ]; then
    echo "ESP-IDF already present at ${IDF_DIR} - skipping clone."
else
    mkdir -p "$(dirname "${IDF_DIR}")"
    git clone -b "${IDF_VERSION}" --recursive \
        https://github.com/espressif/esp-idf.git "${IDF_DIR}"
fi

"${IDF_DIR}/install.sh" esp32h2

echo
echo "Done. Source the environment in your current shell before building:"
echo "  . ${IDF_DIR}/export.sh"
