# Kelas Paket: Font

> **Ringkasan:** Paket font adalah jenis paket yang paling sederhana. Selalu diatur dengan dua variabel: `depends="font-util"` dan `font_dirs`.

---

## 1. Dua Variabel Wajib untuk Font

| Variabel | Fungsi |
|---|---|
| `depends="font-util"` | Dibutuhkan untuk meregenerasi *font cache* saat paket dipasang atau dihapus. |
| `font_dirs` | Diisi direktori tempat paket memasang font-nya. |

`font_dirs` dipakai oleh trigger [`x11-fonts`](../09_xbps-triggers/04-trigger-desktop-bahasa-font.md) untuk membangun ulang cache font saat pemasangan/penghapusan paket.

---

## 2. Contoh Template Font

```bash
# Template file for 'font-foo-ttf'
pkgname=font-foo-ttf
version=1.0
revision=1
depends="font-util"
font_dirs="/usr/share/fonts/TTF"
short_desc="Foo font family (TrueType)"
maintainer="Nama Kamu <kamu@contoh.com>"
distributor="Nama Kamu <kamu@contoh.com>"
license="OFL-1.1"
homepage="https://example.org/foo-font"
distfiles="https://example.org/foo-font-${version}.tar.xz"
checksum="..."

do_install() {
	vmkdir usr/share/fonts/TTF
	vcopy "*.ttf" usr/share/fonts/TTF
}
```

> Contoh bersifat ilustrasi. Nama paket, lisensi, dan lokasi file akan berbeda untuk setiap font.

Contoh nilai `font_dirs` dari manual (beberapa direktori sekaligus):

```bash
font_dirs="/usr/share/fonts/TTF /usr/share/fonts/X11/misc"
```

---

## Intinya

- Paket font **selalu** mengatur `depends="font-util"` dan `font_dirs`.
- `font_dirs` berisi direktori font yang dipasang paket; trigger `x11-fonts` memakainya untuk memperbarui cache.

---

<!-- nav -->
[← Kelas Paket: Haskell](../07_subpackage-dan-kelas-paket/06-paket-haskell.md) | [Daftar Isi](../DaftarISI.md) | [Mengganti Nama Paket →](../08_pemeliharaan-paket/01-mengganti-nama-paket.md)
