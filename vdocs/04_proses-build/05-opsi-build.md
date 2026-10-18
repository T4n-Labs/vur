# Opsi Build (Build Options)

> **Ringkasan:** Satu paket bisa dibangun dengan fitur yang berbeda-beda (misalnya dengan atau tanpa dukungan gambar PNG). **Opsi build** memungkinkan pengguna mengaktifkan atau menonaktifkan fitur tersebut tanpa mengubah template.

---

## 1. Variabel untuk Opsi Build

| Variabel | Fungsi |
|---|---|
| `build_options` | Daftar opsi build yang didukung paket sumber. |
| `build_options_default` | Opsi build yang **aktif secara default**. |
| `desc_option_<opsi>` | Deskripsi untuk opsi `<opsi>`. Harus cocok dengan kata kunci di `build_options`. |

> Jika opsi build cukup umum, deskripsinya sebaiknya ditambahkan ke `common/options.description` (bukan di template).

Setelah variabel di atas didefinisikan, kamu bisa memeriksa variabel **`build_option_<opsi>`** untuk mengetahui apakah opsi tersebut aktif, lalu menyesuaikan paket.

---

## 2. Fungsi Bantu `vopt_*`

| Fungsi | Keluaran |
|---|---|
| `vopt_if <opsi> <jika_true> [<jika_false>]` | `jika_true` bila opsi aktif; `jika_false` bila tidak aktif. |
| `vopt_with <opsi> [<flag>]` | `--with-<flag>` bila aktif; `--without-<flag>` bila tidak. Jika `flag` kosong, dipakai nama `opsi`. |
| `vopt_enable <opsi> [<flag>]` | Seperti `vopt_with`, tetapi `--enable-<flag>` / `--disable-<flag>`. |
| `vopt_conflict <opsi1> <opsi2>` | Menampilkan error dan berhenti jika **kedua opsi aktif bersamaan**. |
| `vopt_bool <opsi> <properti>` | `-D<properti>=true` bila aktif; `-D<properti>=false` bila tidak. |
| `vopt_feature <opsi> <properti>` | Seperti `vopt_bool`, tetapi `-D<properti>=enabled` / `-D<properti>=disabled`. |

Contoh untuk `vopt_with`:

```bash
$(vopt_with dbus)          # --with-dbus atau --without-dbus
$(vopt_with xml xml2)      # --with-xml2 atau --without-xml2
```

---

## 3. Contoh: Menambah Dukungan PNG

Template berikut menunjukkan paket yang memakai GNU configure dan menambah opsi **`png`**:

```bash
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

# To build the package by default with the `png` option:
#
# build_options_default="png"

...
```

Penjelasan:

- `$(vopt_with png)` menghasilkan `--with-png` **atau** `--without-png`.
- `$(vopt_if png libpng-devel)` menambahkan `libpng-devel` ke `makedepends` **hanya jika** opsi `png` aktif.
- Opsi `png` **tidak aktif secara default**, kecuali kamu mengaktifkan `build_options_default="png"`.

---

## 4. Memakai Opsi Build dari Command Line

Melihat opsi yang didukung paket sumber:

```bash
./xbps-src show-options foo
```

Mengaktifkan opsi dengan `-o`:

```bash
./xbps-src -o option,option1 <cmd> foo
```

Menonaktifkan opsi dengan awalan `~`:

```bash
./xbps-src -o ~option,~option1 <cmd> foo
```

Kombinasi aktif dan nonaktif sekaligus:

```bash
./xbps-src -o option,~option1,~option2 <cmd> foo
```

Melihat opsi build untuk **paket biner** lewat `xbps-query(8)`:

```bash
xbps-query -R --property=build-options foo
```

---

## 5. Pengaturan Permanen di `etc/conf`

| Variabel | Cakupan |
|---|---|
| `XBPS_PKG_OPTIONS` | Opsi build **global** (permanen). |
| `XBPS_PKG_OPTIONS_<pkgname>` | Opsi build **per paket**. |

> **Catatan:** jika `pkgname` mengandung tanda hubung (`-`), ganti dengan garis bawah (`_`).
> Contoh: `XBPS_PKG_OPTIONS_xorg_server=opt`.

Daftar opsi build yang didukung beserta deskripsinya tersimpan di berkas `common/options.description`.

---

## Intinya

- Definisikan `build_options`, `desc_option_<opsi>`, dan (opsional) `build_options_default`.
- Pakai `vopt_with`, `vopt_enable`, `vopt_if`, dsb. untuk menyesuaikan argumen dan dependensi.
- Aktifkan/nonaktifkan lewat `./xbps-src -o opsi,~opsi-lain <cmd> <pkg>`.
- Pengaturan permanen lewat `XBPS_PKG_OPTIONS` di `etc/conf`.

---

<!-- nav -->
[← Menangani Patch](../04_proses-build/04-patch.md) | [Daftar Isi](../DaftarISI.md) | [Repositori →](../05_repositori-dan-update/01-repositori.md)
