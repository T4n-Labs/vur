#!/bin/bash

set -e

INDEX="index.json"
PACKAGES="packages.json"
SEARCH="search.json"
CATEGORIES="categories.json"

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
      version=$(grep "^version=" "$template" | cut -d= -f2)
      desc=$(grep "^short_desc=" "$template" | cut -d= -f2- | tr -d '"' | sed 's/\${[^}]*}//g' | sed 's/([^)]*)//g' | xargs)
      homepage=$(grep "^homepage=" "$template" | cut -d= -f2 | tr -d '"')
      maintainer=$(grep "^maintainer=" "$template" | cut -d= -f2- | tr -d '"')

      if [ "$first" = true ]; then
        first=false
      else
        echo "," >> $INDEX
        echo "," >> $PACKAGES
        echo "," >> $SEARCH
      fi

      # index.json
      echo "  {\"name\":\"$pkgname\",\"category\":\"$category\"}" >> $INDEX

      # packages.json
      echo "  {" >> $PACKAGES
      echo "    \"name\": \"$pkgname\"," >> $PACKAGES
      echo "    \"version\": \"$version\"," >> $PACKAGES
      echo "    \"category\": \"$category\"," >> $PACKAGES
      echo "    \"description\": \"$desc\"," >> $PACKAGES
      echo "    \"homepage\": \"$homepage\"," >> $PACKAGES
      echo "    \"maintainer\": \"$maintainer\"" >> $PACKAGES
      echo -n "  }" >> $PACKAGES

      # search.json
      echo "  {\"name\":\"$pkgname\",\"desc\":\"$desc\"}" >> $SEARCH

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
