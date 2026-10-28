#!/bin/sh
# Update template ke rilis stabil terbaru (tag) dari GitHub rapid7/metasploit-framework.
# Pemakaian:
#   ./fetch.sh          # ambil tag stabil terbaru
#   ./fetch.sh 6.5.8    # paksa versi tertentu
set -e

TEMPLATE="template"
REPO="rapid7/metasploit-framework"

if [ ! -f "$TEMPLATE" ]; then
    echo "ERROR: '$TEMPLATE' tidak ditemukan. Jalankan dari srcpkgs/metasploit." >&2
    exit 1
fi

if [ -n "$1" ]; then
    VERSION="$1"
else
    echo "==> Mencari tag stabil terbaru di github.com/${REPO}..."
    # Hanya tag X.Y.Z murni (abaikan pre-release/tag aneh)
    VERSION=$(git ls-remote --tags --refs "https://github.com/${REPO}.git" \
        | awk '{sub("refs/tags/", "", $2); print $2}' \
        | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' \
        | sort -V | tail -n 1)
fi

if [ -z "$VERSION" ]; then
    echo "ERROR: gagal menentukan versi." >&2
    exit 1
fi

CURRENT=$(sed -n 's/^version=//p' "$TEMPLATE")
URL="https://github.com/${REPO}/archive/refs/tags/${VERSION}.tar.gz"

echo "==> Versi saat ini : $CURRENT"
echo "==> Versi target   : $VERSION"

TMP=$(mktemp)
trap 'rm -f "$TMP"' EXIT

echo "==> Mengunduh $URL (untuk menghitung checksum)..."
curl -fsSL "$URL" -o "$TMP"

SHA256=$(sha256sum "$TMP" | awk '{print $1}')
if [ -z "$SHA256" ]; then
    echo "ERROR: gagal menghitung SHA256." >&2
    exit 1
fi

sed -i "s/^version=.*/version=${VERSION}/" "$TEMPLATE"
sed -i "s/^checksum=.*/checksum=${SHA256}/" "$TEMPLATE"

# Versi baru -> revision kembali ke 1
if [ "$CURRENT" != "$VERSION" ]; then
    sed -i "s/^revision=.*/revision=1/" "$TEMPLATE"
fi

echo "==> checksum: $SHA256"
echo "==> Template diperbarui ke ${VERSION}."
echo "==> Cek juga required_ruby_version & Gemfile.lock di rilis baru sebelum build."
