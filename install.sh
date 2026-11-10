#!/usr/bin/env bash
# Installer for syscheck. Usage:
#   curl -fsSL https://raw.githubusercontent.com/WeiYuFeng612/syscheck/main/install.sh | sudo bash
# Tries GitHub first, then the jsDelivr mirror (for networks where GitHub is blocked).

set -euo pipefail

REPO="WeiYuFeng612/syscheck"
BRANCH="main"
PREFIX="${PREFIX:-/usr/local/bin}"
SOURCES=(
    "https://raw.githubusercontent.com/$REPO/$BRANCH/syscheck"
    "https://cdn.jsdelivr.net/gh/$REPO@$BRANCH/syscheck"
)

if [ "$(id -u)" -ne 0 ]; then
    echo "Please run as root (e.g. pipe to 'sudo bash')." >&2
    exit 1
fi

fetch() {
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL --connect-timeout 10 -o "$2" "$1"
    elif command -v wget >/dev/null 2>&1; then
        wget -q -T 10 -O "$2" "$1"
    else
        echo "Neither curl nor wget is installed." >&2
        exit 1
    fi
}

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

for url in "${SOURCES[@]}"; do
    echo "Downloading $url"
    if fetch "$url" "$tmp" && head -1 "$tmp" | grep -q '^#!/usr/bin/env bash'; then
        install -m 0755 "$tmp" "$PREFIX/syscheck"
        echo "Installed: $("$PREFIX/syscheck" --version) -> $PREFIX/syscheck"
        echo "Run 'syscheck' (as root for full results) or 'syscheck --help'."
        exit 0
    fi
    echo "  failed, trying next source..." >&2
done

echo "Download failed from all sources." >&2
exit 1
