# Variabel Wajib

> **Ringkasan:** Tujuh variabel yang **harus** ada di setiap template: `pkgname`, `version`, `revision`, `short_desc`, `maintainer`, `license`, dan `homepage`.

---

## 1. Daftar Variabel Wajib

| Variabel | Fungsi |
|---|---|
| `pkgname` | Nama paket. Harus sama dengan nama folder `srcpkgs/<pkgname>`. |
| `version` | Versi paket. |
| `revision` | Nomor revisi paket. |
| `short_desc` | Deskripsi singkat paket. |
| `maintainer` | Pemelihara paket. |
| `distributor` | Distributor paket. |
| `license` | Lisensi paket. |
| `homepage` | URL halaman utama upstream. |

Berikut penjelasan lengkap tiap variabel.

---

## 2. `pkgname`

String berisi nama paket, **harus cocok** dengan nama folder `srcpkgs/<pkgname>`.

```bash
pkgname=foo
```

---

## 3. `version`

String versi paket. Aturannya:

- **Tidak boleh** mengandung tanda hubung (`-`) atau garis bawah (`_`).
- **Harus** ada minimal **satu angka**.
- **Tidak boleh** memakai substitusi variabel shell.

```bash
version=1.0
```

> `pkgname` dan `version` dilarang mengandung karakter khusus. Karena itu keduanya **tidak perlu diberi tanda kutip**, dan sesuai konvensi memang sebaiknya **tidak** dikutip.

---

## 4. `revision`

Angka revisi paket.

- **Harus bernilai `1`** saat paket sumber pertama kali dibuat, atau saat diperbarui ke **versi upstream baru**.
- **Naikkan** hanya jika **paket biner hasil build berubah** (misalnya kamu mengubah opsi konfigurasi sehingga hasilnya berbeda).

```bash
revision=1
```

| Situasi | Nilai `revision` |
|---|---|
| Paket baru dibuat | `1` |
| Upstream rilis versi baru (`version` naik) | kembali ke `1` |
| Versi sama, tapi hasil paket biner berubah | naikkan (`2`, `3`, ...) |

---

## 5. `short_desc`

Deskripsi singkat paket, **maksimal 72 karakter**.

```bash
short_desc="A short description of the package"
```

---

## 6. `maintainer`

String berformat `nama <user@domain>`.

- Email **harus valid** dan bisa dihubungi.
- Paket yang memakai email `users.noreply.github.com` **tidak akan diterima**.

```bash
maintainer="Nama Kamu <kamu@contoh.com>"
```

---

## 7. `license`

Berisi lisensi perangkat lunak. Nilainya salah satu dari:

- **SPDX Short Identifier** (lihat daftar di <https://spdx.org/licenses>), contoh: `GPL-3.0-or-later`, `MIT`
- `Public Domain`
- string berawalan **`custom:`** untuk lisensi lain

### Beberapa Lisensi Sekaligus

Gunakan **SPDX license expression**:

```bash
license="MIT OR Apache-2.0"
license="MIT AND (LGPL-2.1-or-later OR BSD-3-Clause)"
```

Operator `AND`, `OR`, `WITH`, dan tanda kurung `()` didukung oleh `xlint`.

Format lama yang dipisahkan koma harus **diubah** ke format baru jika ditemukan. Contoh format lama: `GPL-3.0-or-later, custom:Hugware`.

### Meta-package Kosong

*Meta-package* yang tidak berisi file apa pun (sehingga tidak butuh lisensi) memakai `Public Domain`.

### Wajib Menyertakan File Lisensi

Untuk lisensi **`AGPL`, `MIT`, `BSD`, `ISC`, `X11`**, dan lisensi **`custom`**, file lisensi **harus disertakan** di dalam paket biner. Gunakan fungsi [`vlicense`](03-fungsi-global.md#vlicense).

```bash
post_install() {
	vlicense LICENSE
}
```

---

## 8. `homepage`

URL yang menunjuk ke halaman utama upstream.

```bash
homepage="http://www.foo.org"
```

---

## 9. Contoh Template Minimal

```bash
# Template file for 'foo'
pkgname=foo
version=1.0
revision=1
build_style=gnu-configure
short_desc="Package description, no more than 72 characters"
maintainer="Nama Kamu <kamu@contoh.com>"
license="GPL-3.0-or-later"
homepage="http://www.foo.org"
distfiles="http://www.foo.org/foo-${version}.tar.gz"
checksum="fea0a94d4b605894f3e2d5572e3f96e4413bcad3a085aae7367c2cf07908b2ff"
```

> `build_style`, `distfiles`, dan `checksum` bukan variabel "wajib" menurut daftar manual, tapi hampir selalu dipakai. Pembahasannya ada di bagian berikutnya.

---

## Intinya

- Variabel wajib: `pkgname`, `version`, `revision`, `short_desc`, `maintainer`, `license`, `homepage`.
- `pkgname` dan `version` tidak diberi tanda kutip.
- `revision` mulai dari `1` dan hanya naik jika paket biner berubah.
- Lisensi seperti MIT/BSD/AGPL wajib menyertakan file lisensi lewat `vlicense`.

---

<!-- nav -->
[← Aturan Penamaan Paket](../01_pengenalan/03-penamaan-paket.md) | [Daftar Isi](../DaftarISI.md) | [Variabel Global →](../02_dasar-template/02-variabel-global.md)
