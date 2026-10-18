# Variabel Opsional: Metadata dan File Paket

> **Ringkasan:** Variabel yang mengatur **informasi tambahan paket** (kategori, alternatif, revert), **file konfigurasi**, **direktori yang dibuat saat pemasangan**, dan hal-hal yang berkaitan dengan paket biner hasil build.

---

## 1. File Konfigurasi dan File yang Berubah

### `conf_files`

Daftar **file konfigurasi** yang dimiliki paket biner. Harus berupa **path lengkap**; wildcard akan diperluas, dan beberapa entri dipisahkan spasi.

```bash
conf_files="/etc/foo.conf /etc/foo2.conf /etc/foo/*.conf"
```

> **Kenapa penting?** File yang terdaftar sebagai konfigurasi tidak akan ditimpa begitu saja saat paket diperbarui, sehingga perubahan yang dibuat pengguna tetap aman.

### `mutable_files`

Daftar file milik paket yang **diperkirakan akan berubah**. Perilakunya mirip `conf_files`, tetapi **tanpa asumsi** bahwa manusia yang akan mengeditnya.

---

## 2. Direktori yang Dibuat saat Pemasangan

### `make_dirs`

Daftar entri yang mendefinisikan **direktori beserta izinnya** yang dibuat saat paket dipasang.

Format satu entri: `dir mode user group`

```bash
make_dirs="/var/lib/foo 0750 foo foo"
```

Aturan:

- Mode, user, dan group **wajib ada di setiap baris**, bahkan jika nilainya `755 root root`.
- Menurut konvensi, hanya ada **satu entri per baris**.

Contoh beberapa entri:

```bash
make_dirs="/var/lib/foo 0750 foo foo
 /var/log/foo 0755 root root"
```

> Variabel ini diproses oleh trigger [`mkdirs`](../09_xbps-triggers/03-trigger-sistem.md#mkdirs).

---

## 3. Repositori

### `repository`

Menentukan **repositori** tempat paket akan ditempatkan. Nilai yang valid dibahas di [Repositori](../05_repositori-dan-update/01-repositori.md).

---

## 4. Metadata Paket

### `tags`

Daftar *tag* (kategori) yang didaftarkan ke metadata paket dan bisa dicari pengguna lewat `xbps-query`.

```bash
tags="browser chromium-based qt5 python3"
```

### `alternatives`

Daftar **alternatif** yang disediakan paket. Setiap alternatif terdiri dari tiga bagian yang dipisahkan titik dua: **grup**, **symlink**, dan **target**.

```bash
alternatives="vi:/usr/bin/vi:/usr/bin/nvi ex:/usr/bin/ex:/usr/bin/nvi-ex"
```

> **Analogi:** beberapa paket bisa menyediakan perintah yang sama (misalnya `vi`). Sistem alternatif memungkinkan pengguna memilih paket mana yang "memegang" perintah tersebut.

### `reverts`

Fitur unik XBPS yang memungkinkan **downgrade otomatis** dari paket yang rusak. Di `reverts`, kamu menuliskan daftar `pkgver` paket rusak yang ingin dibatalkan (*di-revert*) oleh paket hasil build ini.

Aturan:

- **Harus didefinisikan sebelum** `version` dan `revision`.
- Versi di `reverts` **harus lebih besar** daripada `version`.

```bash
reverts="2.0_1 2.0_2"
version=1.9
revision=2
```

Pada contoh ini, jika pengguna memiliki `2.0_1` atau `2.0_2` yang rusak, paket versi `1.9_2` dianggap sebagai "pembaruan" yang memulihkannya.

### `preserve`

Jika diatur, file milik paket **tidak dihapus** saat paket diperbarui, dipasang ulang, atau dihapus.

Terutama berguna untuk **paket kernel**, agar file kernel tidak hilang ketika paket dihapus (yang bisa merusak proses boot dan pemuatan modul pengguna). Pada kebanyakan kasus lain, **sebaiknya tidak dipakai**.

---

## 5. Subpackage dan Meta-package

### `subpackages`

Daftar subpackage (yang cocok dengan fungsi `foo_package()`) untuk **menimpa daftar hasil tebakan otomatis**. Hanya dipakai jika **urutan tertentu** dibutuhkan; pada sebagian besar kasus default sudah cukup.

### `metapackage`

Jika diset `yes`, paket **harus** berupa meta-package kosong, yaitu paket yang hanya bergantung pada paket-paket lain.

```bash
metapackage=yes
depends="foo bar baz"
```

---

## 6. Variabel yang Dipakai oleh Trigger

Variabel berikut menjadi "bahan bakar" bagi trigger XBPS tertentu (dibahas lengkap di [Bagian 9](../09_xbps-triggers/01-pengenalan-trigger.md)):

| Variabel | Fungsi | Trigger |
|---|---|---|
| `font_dirs` | Daftar direktori (path absolut) tempat paket font memasang fontnya. Contoh: `font_dirs="/usr/share/fonts/TTF /usr/share/fonts/X11/misc"` | `x11-fonts` |
| `dkms_modules` | Daftar modul DKMS yang dipasang/dihapus. Formatnya pasangan **nama modul** dan **versi modul**. Contoh: `dkms_modules="$pkgname $version zfs 4.14"` | `dkms` |
| `register_shell` | Daftar shell (path absolut) yang didaftarkan ke database shell sistem. Contoh: `register_shell="/bin/tcsh /bin/csh"` | `register-shell` |

---

## Intinya

- `conf_files` melindungi konfigurasi pengguna; `make_dirs` membuat direktori saat pemasangan.
- `tags` dan `alternatives` memperkaya metadata paket.
- `reverts` memungkinkan downgrade otomatis dari paket yang rusak (harus ditulis **sebelum** `version`/`revision`).
- `font_dirs`, `dkms_modules`, `register_shell` hanya berguna jika trigger terkait dipakai.

---

<!-- nav -->
[← Variabel Opsional: Konfigurasi Build](../02_dasar-template/05-variabel-opsional-build.md) | [Daftar Isi](../DaftarISI.md) | [Variabel Opsional: Pembatasan dan Pemeriksaan →](../02_dasar-template/07-variabel-opsional-pembatasan-dan-pemeriksaan.md)
