# 10. Build Options

[« Functions (Lifecycle)](09-functions-lifecycle.md) · [Daftar Isi](README.md) · Selanjutnya: [INSTALL/REMOVE Scripts »](11-install-remove-scripts.md)

Beberapa paket bisa dibangun dengan opsi build berbeda untuk mengaktifkan
atau menonaktifkan fitur tambahan. Koleksi source paket XBPS memungkinkan
hal ini dengan beberapa penyesuaian sederhana pada file `template`.

## Variabel Build Options

- **`build_options`** — Mengeset opsi build yang didukung source paket.
- **`build_options_default`** — Mengeset opsi build default yang dipakai
  source paket.
- **`desc_option_<option>`** — Mengeset deskripsi untuk opsi build
  `option`. Harus cocok dengan keyword yang diset di `build_options`.
  Catatan: jika opsi build cukup umum, deskripsinya sebaiknya ditambahkan
  ke `common/options.description` alih-alih di sini.

Setelah mendefinisikan variabel-variabel wajib tersebut, kamu bisa memeriksa
variabel `build_option_<option>` untuk mengetahui apakah opsi tersebut
diset, dan menyesuaikan source paket sesuai kebutuhan. Selain itu, tersedia
fungsi-fungsi berikut:

- **`vopt_if()`** — `vopt_if <option> <if_true> [<if_false>]`
  Menghasilkan `if_true` jika `option` diset, atau `if_false` jika tidak.

- **`vopt_with()`** — `vopt_with <option> [<flag>]`
  Menghasilkan `--with-<flag>` jika opsi diset, atau `--without-<flag>`
  jika tidak. Jika `flag` tidak disebutkan, defaultnya `option`. Contoh:
  - `vopt_with dbus`
  - `vopt_with xml xml2`

- **`vopt_enable()`** — `vopt_enable <option> [<flag>]`
  Sama seperti `vopt_with`, tapi memakai `--enable-<flag>` dan
  `--disable-<flag>`.

- **`vopt_conflict()`** — `vopt_conflict <option 1> <option 2>`
  Menampilkan error dan keluar (exit) jika kedua opsi diset bersamaan.

- **`vopt_bool()`** — `vopt_bool <option> <property>`
  Menghasilkan `-D<property>=true` jika opsi diset, atau
  `-D<property>=false` jika tidak.

- **`vopt_feature()`** — `vopt_feature <option> <property>`
  Sama seperti `vopt_bool`, tapi memakai `-D<property>=enabled` dan
  `-D<property>=disabled`.

## Contoh

Contoh berikut menunjukkan cara mengubah source paket yang memakai GNU
configure agar mendukung opsi build baru untuk gambar PNG:

```
# Template file for 'foo'
pkgname=foo
version=1.0
revision=1
build_style=gnu-configure
configure_args="... $(vopt_with png)"
makedepends="... $(vopt_if png libpng-devel)"
...

# Package build options
build_options="png"
desc_option_png="Enable support for PNG images"

# Untuk membangun paket secara default dengan opsi `png`:
#
# build_options_default="png"

...
```

## Perintah `xbps-src` Terkait Build Options

Melihat opsi build yang didukung sebuah source paket:

```
$ ./xbps-src show-options foo
```

Mengaktifkan opsi build lewat flag `-o`:

```
$ ./xbps-src -o option,option1 <cmd> foo
```

Menonaktifkan opsi build dengan awalan `~`:

```
$ ./xbps-src -o ~option,~option1 <cmd> foo
```

Kedua cara di atas bisa dipakai bersamaan untuk mengaktifkan dan/atau
menonaktifkan beberapa opsi sekaligus:

```
$ ./xbps-src -o option,~option1,~option2 <cmd> foo
```

Opsi build juga bisa dilihat untuk paket biner via `xbps-query(8)`:

```
$ xbps-query -R --property=build-options foo
```

Opsi build paket global yang permanen bisa diset lewat variabel
`XBPS_PKG_OPTIONS` di file konfigurasi `etc/conf`. Opsi build per-paket bisa
diset lewat `XBPS_PKG_OPTIONS_<pkgname>`.

> **Catatan:** jika `pkgname` mengandung tanda hubung (`-`), tanda tersebut
> harus diganti dengan underscore (`_`). Contoh:
> `XBPS_PKG_OPTIONS_xorg_server=opt`.

Daftar opsi build paket yang didukung beserta deskripsinya didefinisikan di
file `common/options.description`.
