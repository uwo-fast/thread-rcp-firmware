#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=/dev/null
[ -f "${REPO_ROOT}/.env" ] && { set -a; . "${REPO_ROOT}/.env"; set +a; }

failures=0

pass() {
    echo "PASS: $1"
}

fail() {
    echo "FAIL: $1"
    failures=$((failures + 1))
}

# Check IDF_PATH is set and points to a directory.
if [ -n "${IDF_PATH:-}" ]; then
    if [ -d "${IDF_PATH}" ]; then
        pass "IDF_PATH is set: ${IDF_PATH}"
    else
        fail "IDF_PATH is set but does not exist: ${IDF_PATH}"
    fi
else
    fail "IDF_PATH is not set. Run: . \${HOME}/esp/esp-idf/export.sh"
fi

# Check idf.py is available.
has_idf_py=0
if command -v idf.py >/dev/null 2>&1; then
    has_idf_py=1
    pass "idf.py is available on PATH"
else
    fail "idf.py not found on PATH. Source ESP-IDF export script first."
fi

# Check ESP-IDF version is v6.0.x.
if [ "${has_idf_py}" -eq 1 ]; then
    idf_version_line="$(idf.py --version 2>/dev/null | head -n 1 || true)"
    if [[ "${idf_version_line}" =~ v([0-9]+)\.([0-9]+)(\.[0-9]+)? ]]; then
        idf_major="${BASH_REMATCH[1]}"
        idf_minor="${BASH_REMATCH[2]}"
        if [ "${idf_major}" -eq 6 ] && [ "${idf_minor}" -eq 0 ]; then
            pass "ESP-IDF version is compatible (${idf_version_line})"
        else
            fail "ESP-IDF version must be v6.0.x, got: ${idf_version_line}"
        fi
    else
        fail "Could not determine ESP-IDF version from: ${idf_version_line:-<empty>}"
    fi
fi

# Check Python version is 3.9-3.13.
if command -v python3 >/dev/null 2>&1; then
    py_version="$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}")')"
    py_major="$(python3 -c 'import sys; print(sys.version_info.major)')"
    py_minor="$(python3 -c 'import sys; print(sys.version_info.minor)')"

    if [ "${py_major}" -eq 3 ] && [ "${py_minor}" -ge 9 ] && [ "${py_minor}" -le 13 ]; then
        pass "Python version is compatible (${py_version})"
    else
        fail "Python version must be 3.9-3.13, got: ${py_version}"
    fi
else
    fail "python3 not found on PATH"
fi

# Check esptool.py is available.
if command -v esptool.py >/dev/null 2>&1; then
    pass "esptool.py is available on PATH"
else
    fail "esptool.py not found on PATH"
fi

# Optional port validation only when PORT is set.
if [ -n "${PORT:-}" ]; then
    if [ -c "${PORT}" ]; then
        pass "PORT exists as character device: ${PORT}"
    else
        fail "PORT is set but not a character device: ${PORT}"
    fi
else
    echo "INFO: PORT not set; skipping port check."
fi

if [ "${failures}" -gt 0 ]; then
    echo
    echo "Doctor checks failed (${failures})."
    exit 1
fi

echo
echo "All doctor checks passed."
