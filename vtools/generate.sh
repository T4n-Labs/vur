#!/bin/bash

echo "[" > index.json
first=1

for dir in $(bash tools/scan.sh); do

    template="$dir/template"

    pkgname=$(grep "^pkgname=" "$template" | cut -d= -f2)
    version=$(grep "^version=" "$template" | cut -d= -f2)
    desc=$(grep "^short_desc=" "$template" | cut -d= -f2- | sed 's/"//g')

    category=$(echo $dir | cut -d/ -f1)

    if [ $first -eq 0 ]; then
        echo "," >> index.json
    fi

    echo "  {" >> index.json
    echo "    \"name\": \"$pkgname\"," >> index.json
    echo "    \"version\": \"$version\"," >> index.json
    echo "    \"category\": \"$category\"," >> index.json
    echo "    \"description\": \"$desc\"" >> index.json
    echo -n "  }" >> index.json

    first=0

done

echo "" >> index.json
echo "]" >> index.json

# Script For Generate JSON/Metadata VUR