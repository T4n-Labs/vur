#!/bin/bash
set -e
INDEX="index.json"
PACKAGES="packages.json"
SEARCH="search.json"
CATEGORIES="categories.json"

# Arch List
ALL_ARCHS="x86_64 x86_64-musl i686 aarch64 aarch64-musl armv7l armv7l-musl armv6l armv6l-musl"

# Fungsi untuk mengekspansi wildcard (*) menjadi arsitektur spesifik
# Contoh: "x86_64*" -> "x86_64 x86_64-musl"
expand_archs() {
    local input="$1"
    local result=""
    for word in $input; do
        if [[ "$word" == *"*" ]]; then
            local base="${word%\*}" # Hapus tanda *
            result="$result $base ${base}-musl"
        else
            result="$result $word"
        fi
    done
    # Hapus duplikat (sort -u) dan rapikan spasi (xargs)
    echo "$result" | tr ' ' '\n' | sort -u | tr '\n' ' ' | xargs
}

# ---------------------------------------------------------------------------
# Fungsi BARU: ekstrak field dependency (hostmakedepends / makedepends / depends)
# dari sebuah file template Void.
#
# Mendukung 3 bentuk penulisan yang lazim di template Void:
#   1) Satu baris:        makedepends="a b c"
#   2) Multi-baris:       makedepends="
#                          a
#                          b
#                        "
#   3) Lanjutan backslash:
#                        makedepends="a \
#                          b"
#
# Output: JSON array, mis. ["a","b","c"]. Jika field tidak ada -> []
# ---------------------------------------------------------------------------
get_deps_json() {
    local field="$1"
    local file="$2"
    awk -v field="$field" '
    function cleanup(s,   parts, n, i, out) {
        gsub(/"/, "", s)        # buang tanda kutip
        gsub(/\\/, "", s)       # buang backslash continuation
        n = split(s, parts, /[ \t\n]+/)   # pisah berdasarkan whitespace
        out = ""
        for (i = 1; i <= n; i++) {
            if (parts[i] != "") {
                if (out != "") out = out ","
                out = out "\"" parts[i] "\""
            }
        }
        return "[" out "]"
    }
    # state 0 = mencari field, state 1 = di dalam nilai multi-baris
    BEGIN { state = 0; buf = ""; done = 0 }
    {
        if (state == 0) {
            if (!done && $0 ~ "^"field"=") {
                buf = substr($0, index($0,"=")+1)
                q = gsub(/"/, "&", buf)        # hitung jumlah tanda kutip
                if (q >= 2) {                  # ditutup di baris yang sama
                    print cleanup(buf)
                    done = 1
                } else if (q == 1) {           # kutip buka, lanjut ke baris berikut
                    state = 1
                } else {                       # tanpa kutip, satu kata
                    print cleanup(buf)
                    done = 1
                }
            }
        } else {
            buf = buf " " $0
            q = gsub(/"/, "&", buf)
            if (q >= 2) {                      # kutip tutup ditemukan
                print cleanup(buf)
                state = 0
                done = 1
            }
        }
    }
    END {
        if (!done) {
            if (state == 1) print cleanup(buf)   # nilai tidak pernah ditutup (template rusak)
            else           print "[]"           # field sama sekali tidak ada
        }
    }
    ' "$file"
}

echo "Generating VUR index..."
echo "[" > $INDEX
echo "[" > $PACKAGES
echo "[" > $SEARCH
first=true

for category in core extra multilib; do
  for pkg in $category/*; do
    template="$pkg/template"
    if [ -f "$template" ]; then
      pkgname=$(basename "$pkg")
      path="$category/$pkgname"
      version=$(grep "^version=" "$template" | cut -d= -f2)
      desc=$(grep "^short_desc=" "$template" | cut -d= -f2- | tr -d '"' | sed 's/\${[^}]*}//g' | sed 's/([^)]*)//g' | xargs)
      archs_raw=$(grep "^archs=" "$template" | cut -d= -f2 | tr -d '"')

      if [ -z "$archs_raw" ]; then
        archs_raw="$ALL_ARCHS"
      fi

      archs_expanded=$(expand_archs "$archs_raw")
      archs_json="[\"$(echo "$archs_expanded" | sed 's/ /", "/g')\"]"

      homepage=$(grep "^homepage=" "$template" | cut -d= -f2 | tr -d '"')
      maintainer=$(grep "^maintainer=" "$template" | cut -d= -f2- | tr -d '"')
      distributor=$(grep "^distributor=" "$template" | cut -d= -f2- | tr -d '"')

      # --- FIELD BARU: ekstrak 3 daftar dependency dari template ---
      hostmakedepends_json=$(get_deps_json "hostmakedepends" "$template")
      makedepends_json=$(get_deps_json "makedepends" "$template")
      depends_json=$(get_deps_json "depends" "$template")

      if [ "$first" = true ]; then
        first=false
      else
        echo "," >> $INDEX
        echo "," >> $PACKAGES
        echo "," >> $SEARCH
      fi

      # index.json
      echo "  {\"name\":\"$pkgname\",\"category\":\"$category\",\"path\":\"$path\"}" >> $INDEX

      # packages.json
      echo "  {" >> $PACKAGES
      echo "    \"name\": \"$pkgname\"," >> $PACKAGES
      echo "    \"category\": \"$category\"," >> $PACKAGES
      echo "    \"path\": \"$path\"," >> $PACKAGES
      echo "    \"version\": \"$version\"," >> $PACKAGES
      echo "    \"archs\": $archs_json," >> $PACKAGES
      echo "    \"description\": \"$desc\"," >> $PACKAGES
      echo "    \"homepage\": \"$homepage\"," >> $PACKAGES
      echo "    \"maintainer\": \"$maintainer\"," >> $PACKAGES
      echo "    \"distributor\": \"$distributor\"," >> $PACKAGES
      echo "    \"hostmakedepends\": $hostmakedepends_json," >> $PACKAGES
      echo "    \"makedepends\": $makedepends_json," >> $PACKAGES
      echo "    \"depends\": $depends_json" >> $PACKAGES
      echo -n "  }" >> $PACKAGES

      # search.json
      echo "  {\"name\":\"$pkgname\",\"desc\":\"$desc\",\"path\":\"$path\"}" >> $SEARCH
    fi
  done
done

echo "]" >> $INDEX
echo "]" >> $PACKAGES
echo "]" >> $SEARCH

# categories.json
cat <<EOF > $CATEGORIES
[
  {"name":"core"},
  {"name":"extra"},
  {"name":"multilib"}
]
EOF

echo "Index generation complete." 