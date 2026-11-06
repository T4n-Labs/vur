#!/bin/sh
# fix-shlibs.sh — sinkronkan common/shlibs untuk radare2 6.2.6
f=../../common/shlibs
ver=6.2.6
pkg="radare2-${ver}_1"

# hapus entri radare2 lama
sed -i -E '/^(libr_[a-z]+|libsdb)\.so\.[0-9.]+ radare2-/d' "$f"

# tambahkan entri baru
for l in core config cons util flag arch asm bin anal lang debug egg bp \
         search io socket syscall fs magic reg main muta esil; do
	echo "libr_$l.so.$ver $pkg"
done >> "$f"
echo "libsdb.so.2.6.2 $pkg" >> "$f"