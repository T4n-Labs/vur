# 1. Pengantar & Fase Build

[« Kembali ke Daftar Isi](README.md) · Selanjutnya: [Konvensi Penamaan »](02-konvensi-penamaan.md)

## Pengantar

Repository `void-packages` berisi semua "resep" untuk mengunduh, mengompilasi,
dan membangun paket biner untuk Void Linux. File paket sumber ini disebut
**template**.

File `template` adalah shell script yang mendefinisikan **variabel** dan
**fungsi**, yang kemudian diproses oleh `xbps-src` (pembangun paket) untuk
menghasilkan paket biner. Shell yang digunakan `xbps-src` adalah **GNU bash**
— `xbps-src` tidak menargetkan kompatibilitas dengan POSIX `sh`.

Menurut konvensi, semua template dimulai dengan komentar yang menyatakan
bahwa file tersebut adalah `template file` untuk paket tertentu. Sebagian
besar baris sebaiknya dijaga di bawah 80 kolom; variabel yang berisi banyak
nilai boleh dipecah ke baris baru, dengan baris lanjutan diindentasi satu
spasi.

### Contoh template sederhana

```
# Template file for 'foo'
pkgname=foo
version=1.0
revision=1
build_style=gnu-configure
short_desc="Package description, no more than 72 characters"
maintainer="name <email>"
license="GPL-3.0-or-later"
homepage="http://www.foo.org"
distfiles="http://www.foo.org/foo-${version}.tar.gz"
checksum="fea0a94d4b605894f3e2d5572e3f96e4413bcad3a085aae7367c2cf07908b2ff"
```

File template berisi definisi untuk mengunduh, membangun, dan memasang
(install) file paket ke sebuah **fake destdir**; setelah itu, paket biner
dapat dihasilkan berdasarkan definisi yang ditentukan di dalamnya.

Jangan khawatir jika ada hal yang belum jelas — semua `variabel` dan `fungsi`
akan dijelaskan lebih lanjut di bagian berikutnya. File `template` ini harus
dibuat di dalam direktori yang namanya sama dengan `$pkgname`, contoh:
`void-packages/srcpkgs/foo/template`.

Jika semuanya berjalan lancar setelah menjalankan:

```
$ ./xbps-src pkg <pkgname>
```

maka paket biner bernama `foo-1.0_1.<arch>.xbps` akan dihasilkan di
repository lokal `hostdir/binpkgs`.

## Fase Build Paket

Proses membangun sebuah paket terdiri dari fase-fase berikut:

- **`setup`** — Menyiapkan environment untuk membangun paket.

- **`fetch`** — Mengunduh source yang dibutuhkan oleh `source package`,
  sesuai variabel `distfiles` atau fungsi `do_fetch()`.

- **`extract`** — Mengekstrak file `distfiles` ke `$wrksrc`, atau menjalankan
  fungsi `do_extract()`; direktori inilah yang digunakan untuk mengompilasi
  `source package`.

- **`patch`** — Menerapkan semua patch di direktori `patches` milik paket,
  dan bisa juga digunakan untuk operasi lain sebelum tahap konfigurasi.

- **`configure`** — Menjalankan konfigurasi `source package`, mis. `GNU
  configure scripts`.

- **`build`** — Mengompilasi/menyiapkan source files melalui `make` atau
  metode kompatibel lainnya.

- **`check`** (opsional) — Memeriksa hasil fase `build` dengan menjalankan
  testsuite bawaan paket. Jika fungsi default `do_check` dari build style
  yang dipakai tidak melakukan apa-apa, template harus mengatur
  `make_check_target` dan/atau `make_check_args` dengan tepat, atau membuat
  fungsi `do_check()` sendiri. Jika testsuite terlalu lama atau tidak bisa
  berjalan di semua environment, `make_check` harus diset sesuai kebutuhan,
  atau `do_check` disesuaikan untuk membatasi testsuite, kecuali
  `XBPS_CHECK_PKGS` bernilai `full`.

- **`install`** — Memasang file paket ke destdir paket
  `<masterdir>/destdir/<pkgname>-<version>`, via `make install` atau metode
  kompatibel lainnya.

- **`pkg`** — Membangun paket biner dari file yang tersimpan di **package
  destdir**, dan mendaftarkannya ke repository lokal.

- **`clean`** — Membersihkan paket (jika didefinisikan).

`xbps-src` mendukung menjalankan hanya fase tertentu saja; jika fase tersebut
berhasil dijalankan, fase itu akan dilewati di kemudian hari (kecuali direktori
kerjanya `${wrksrc}` dihapus dengan `xbps-src clean`).
