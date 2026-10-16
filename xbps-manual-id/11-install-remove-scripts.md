# 11. File INSTALL/REMOVE & INSTALL.msg/REMOVE.msg

[« Build Options](10-build-options.md) · [Daftar Isi](README.md) · Selanjutnya: [Akun Sistem & Runit »](12-akun-sistem-dan-runit.md)

## File INSTALL dan REMOVE

Shell snippet `INSTALL` dan `REMOVE` bisa dipakai untuk menjalankan aksi
tertentu pada tahap tertentu ketika paket biner dipasang, diperbarui, atau
dihapus. Ada beberapa variabel yang selalu diset oleh `xbps` saat script ini
dijalankan:

- **`$ACTION`** — untuk kondisi aksinya: `pre` atau `post`.
- **`$PKGNAME`** — nama paket.
- **`$VERSION`** — versi paket.
- **`$UPDATE`** — diset `yes` jika paket sedang di-upgrade, `no` jika
  paket sedang dipasang atau dihapus.
- **`$CONF_FILE`** — path lengkap ke `xbps.conf`.
- **`$ARCH`** — arsitektur target tempat script dijalankan.

Contoh bagaimana script `INSTALL` atau `REMOVE` dibuat:

```
# INSTALL
case "$ACTION" in
pre)
	# Aksi yang dijalankan sebelum file paket di-unpack.
	...
	;;
post)
	if [ "$UPDATE" = "yes" ]; then
		# Aksi yang dijalankan jika paket sedang diperbarui.
		...
	else
		# Aksi yang dijalankan jika paket sedang dipasang.
		...
	fi
	;;
esac
```

Subpackage juga bisa punya file `INSTALL` dan `REMOVE` sendiri; cukup buat
`srcpkgs/<pkgname>/<subpkg>.INSTALL` atau
`srcpkgs/<pkgname>/<subpkg>.REMOVE`.

> **Catatan:** selalu gunakan path relatif terhadap direktori kerja saat
> ini, karena jika tidak, script yang dijalankan lewat `chroot(2)` tidak
> akan berfungsi dengan benar.

> **Catatan:** jangan gunakan script INSTALL/REMOVE untuk menampilkan
> pesan — lihat bagian berikutnya untuk itu.

## File INSTALL.msg dan REMOVE.msg

File `INSTALL.msg` dan `REMOVE.msg` bisa dipakai untuk menampilkan pesan
masing-masing pada saat post-install atau pre-remove.

Idealnya file ini tidak melebihi 80 karakter per baris.

Subpackage juga bisa punya file `INSTALL.msg` dan `REMOVE.msg` sendiri;
cukup buat `srcpkgs/<pkgname>/<subpkg>.INSTALL.msg` atau
`srcpkgs/<pkgname>/<subpkg>.REMOVE.msg`.

Fitur ini sebaiknya hanya dipakai untuk pesan yang kritis, seperti
memperingatkan pengguna soal breaking changes.
