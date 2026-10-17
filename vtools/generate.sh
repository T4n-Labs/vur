#!/bin/bash
set -e
INDEX="index.json"
PACKAGES="packages.json"
SEARCH="search.json"
CATEGORIES="categories.json"

# List Multi-Archs
ALL_ARCHS="x86_64 x86_64-musl i686 aarch64 aarch64-musl armv7l armv7l-musl armv6l armv6l-musl"

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
      
      archs=$(grep "^archs=" "$template" | cut -d= -f2 | tr -d '"')
      
      if [ -z "$archs" ]; then
        archs="$ALL_ARCHS"
      fi

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
      echo "    \"archs\": \"$archs\"," >> $PACKAGES 
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