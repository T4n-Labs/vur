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

echo "Generating VUR index..."
echo "[" > $INDEX
echo "[" > $PACKAGES
echo "[" > $SEARCH
first=true

for category in core extra multilib; do
  for pkg in $category/*; do
    template="$pkg/template"
    if [ -f "$template" ]; then
      pkgname=$(grep "^pkgname=" "$template" | cut -d= -f2)
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
      echo "    \"archs\": $archs_json," >> $PACKAGES      # <-- Tidak pakai kutip, karena sudah berupa array
      echo "    \"description\": \"$desc\"," >> $PACKAGES
      echo "    \"homepage\": \"$homepage\"," >> $PACKAGES
      echo "    \"maintainer\": \"$maintainer\"," >> $PACKAGES
      echo "    \"distributor\": \"$distributor\"" >> $PACKAGES
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