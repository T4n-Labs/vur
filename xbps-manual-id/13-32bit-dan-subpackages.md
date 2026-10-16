# 13. Paket 32-bit & Subpackages

[« Akun Sistem & Runit](12-akun-sistem-dan-runit.md) · [Daftar Isi](README.md) · Selanjutnya: [Kelas Paket »](14-kelas-paket.md)

## Paket 32-bit

Paket 32-bit dibangun otomatis jika builder-nya x86 (32-bit), tapi ada
beberapa variabel yang bisa mengubah perilaku ini:

- **`lib32depends`** — Jika diset, dependency yang tercantum di sini akan
  dipakai, menggantikan deteksi otomatis oleh `xbps-src` dan `depends`.
  Dependency harus ditentukan dengan operator versi, contoh:
  `lib32depends="foo>=0 blah<2.0"`.
- **`lib32disabled`** — Jika diset, tidak ada paket 32-bit yang akan
  dibangun.
- **`lib32files`** — File tambahan yang dimasukkan ke paket **32-bit**.
  Berisi path absolut dipisah spasi, contoh:
  `lib32files="/usr/bin/blah /usr/include/blah."`.
- **`lib32symlinks`** — Membuat symlink dari nama file target yang
  disimpan di direktori `lib32`. Berisi basename file target, contoh:
  `lib32symlinks="foo"`.
- **`lib32mode`** — Jika kosong, hanya shared/static library dan file
  pkg-config yang disalin ke paket **32-bit**. Jika diset `full`, semua
  file disalin ke paket 32-bit apa adanya (tanpa modifikasi).

## Subpackages

Pada contoh di file-file sebelumnya, hanya satu paket biner yang dihasilkan.
Namun dengan beberapa penyesuaian sederhana, banyak paket biner bisa
dihasilkan dari satu template/build — ini disebut **subpackages**.

Untuk membuat subpackage tambahan, template harus mendefinisikan fungsi baru
dengan penamaan: `<subpkgname>_package()`. Contoh:

```
# Template file for 'foo'
pkgname=foo
version=1.0
revision=1
build_style=gnu-configure
short_desc="A short description max 72 chars"
maintainer="name <email>"
license="GPL-3.0-or-later"
homepage="http://www.foo.org"
distfiles="http://www.foo.org/foo-${version}.tar.gz"
checksum="fea0a94d4b605894f3e2d5572e3f96e4413bcad3a085aae7367c2cf07908b2ff"

# foo-devel adalah subpackage
foo-devel_package() {
	short_desc+=" - development files"
	depends="${sourcepkg}>=${version}_${revision}"
	pkg_install() {
		vmove usr/include
		vmove "usr/lib/*.a"
		vmove "usr/lib/*.so"
		vmove usr/lib/pkgconfig
	}
}
```

Semua subpackage butuh symlink tambahan ke paket `main`, jika tidak,
dependency yang membutuhkan paket-paket tersebut tidak akan menemukan
`template`-nya. Contoh:

```
 /srcpkgs
  |- foo <- direktori (paket utama)
  |  |- template
  |- foo-devel <- symlink ke `foo`
```

Paket utama harus mendeklarasikan semua **build dependency** yang dibutuhkan
untuk membangun semua subpackage yang didefinisikan di template.

Poin penting soal `subpackages`: mereka diproses **setelah** paket utama
selesai menjalankan fase `install`-nya. Fungsi `pkg_install()` yang
didefinisikan di dalamnya umumnya dipakai untuk memindahkan file dari
destdir paket `main` ke destdir subpackage.

Fungsi helper `vinstall`, `vmkdir`, `vcopy`, dan `vmove` hanyalah wrapper
yang menyederhanakan proses membuat, menyalin, dan memindahkan file/direktori
antara destdir paket utama (`$DESTDIR`) ke destdir subpackage
(`$PKGDESTDIR`).

Subpackage selalu diproses berurutan sesuai abjad. Untuk memaksa urutan
kustom, variabel `subpackages` bisa dideklarasikan dengan urutan yang
diinginkan.
