#!/bin/bash

categories=("core" "extra" "multilib")

for cat in "${categories[@]}"; do
    for pkg in "$cat"/*; do
        if [ -f "$pkg/template" ]; then
            echo "$pkg"
        fi
    done
done

# Script For Scan Package