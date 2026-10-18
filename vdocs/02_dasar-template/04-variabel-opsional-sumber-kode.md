# Variabel Opsional: Sumber Kode

> **Ringkasan:** Variabel untuk mengatur **dari mana** kode sumber diunduh, bagaimana diverifikasi, dan **di mana** ia diekstrak.

---

## 1. `distfiles`

URL **lengkap** menuju file distribusi kode sumber dari upstream.

- Beberapa file dipisahkan dengan **spasi**.
- Ekstensi yang didukung: `.tar.lzma`, `.tar.xz`, `.txz`, `.tar.bz2`, `.tbz`, `.tar.gz`, `.tgz`, `.gz`, `.bz2`, `.tar`, atau `.zip`.
- Untuk menentukan **nama file tujuan**, tambahkan `>namafile` di belakang URL.

```bash
distfiles="http://foo.org/foo-1.0.tar.gz http://foo.org/bar-1.0.tar.gz>bar.tar.gz"
```

### Variabel Singkatan Situs Hosting

Agar tidak mengulang URL panjang, tersedia variabel untuk situs hosting umum:

| Variabel | Nilai |
|---|---|
| `CPAN_SITE` | `https://cpan.perl.org/modules/by-module` |
| `DEBIAN_SITE` | `http://ftp.debian.org/debian/pool` |
| `FREEDESKTOP_SITE` | `https://freedesktop.org/software` |
| `GNOME_SITE` | `https://ftp.gnome.org/pub/GNOME/sources` |
| `GNU_SITE` | `https://ftp.gnu.org/gnu` |
| `KERNEL_SITE` | `https://www.kernel.org/pub/linux` |
| `MOZILLA_SITE` | `https://ftp.mozilla.org/pub` |
| `NONGNU_SITE` | `https://download.savannah.nongnu.org/releases` |
| `PYPI_SITE` | `https://files.pythonhosted.org/packages/source` |
| `SOURCEFORGE_SITE` | `https://downloads.sourceforge.net/sourceforge` |
| `UBUNTU_SITE` | `http://archive.ubuntu.com/ubuntu/pool` |
| `XORG_SITE` | `https://www.x.org/releases/individual` |
| `KDE_SITE` | `https://download.kde.org/stable` |
| `VIDEOLAN_SITE` | `https://download.videolan.org/pub/videolan` |

Contoh pemakaian (ilustrasi):

```bash
distfiles="${GNU_SITE}/hello/hello-${version}.tar.gz"
```

---

## 2. `checksum`

Hash **SHA256** yang cocok dengan `${distfiles}`.

- Beberapa hash dipisahkan **spasi**.
- **Urutannya harus sama** dengan urutan di `${distfiles}`.

```bash
checksum="kkas00xjkjas"
```

### Kasus Khusus: File yang Hash-nya Selalu Berubah

Beberapa server membuat arsip secara *on the fly* (contoh: *snapshot tarball* dari situs `https://*.googlesource.com/`), sehingga hash file berubah setiap diunduh.

Solusinya: gunakan hash dari **isi arsip**, dengan menambahkan awalan **`@`** pada hash. Untuk tarball, hash isi arsip bisa dicari dengan:

```bash
tar xf <tarball.ext> --to-stdout | sha256sum
```

> **Tips pemula:** Untuk file biasa, hash cukup dihitung dengan `sha256sum namafile.tar.gz` pada file yang sudah diunduh.

---

## 3. `wrksrc`

Nama direktori tempat kode sumber diekstrak. Default: `${pkgname}-${version}`.

Variabel ini perlu diatur jika hasil ekstraksi upstream **tidak** bernama `${pkgname}-${version}`.

---

## 4. `build_wrksrc`

Direktori **relatif terhadap `${wrksrc}`** yang dipakai saat membangun paket.

Berguna jika file build (misalnya `Makefile`) berada di sub-folder dalam kode sumber.

---

## 5. `create_wrksrc`

Biasanya, setelah ekstraksi, jika terdapat **beberapa file/direktori tingkat atas** atau **tidak ada direktori sama sekali** (hanya file), semuanya akan dibungkus ke dalam satu lapis direktori tambahan.

Set `create_wrksrc` untuk **memaksa** perilaku pembungkusan ini.

---

## 6. `skip_extraction`

Daftar nama file yang **tidak perlu diekstrak** pada fase `extract`. Nilainya harus cocok dengan *basename* URL mana pun yang ada di `${distfiles}`.

```bash
skip_extraction="foo-${version}.tar.gz"
```

> Biasanya dipakai bersama fungsi [`vsrcextract`](03-fungsi-global.md#vsrcextract) atau [`vsrccopy`](03-fungsi-global.md#vsrccopy) yang mengambil file langsung dari `$XBPS_SRCDISTDIR`.

---

## 7. `fetch_cmd`

Executable yang dipakai untuk mengunduh URL di `distfiles` pada fase `do_fetch`.

---

## 8. `changelog`

URL yang menunjuk ke *changelog* upstream. **File teks mentah (raw text) lebih disukai.**

---

## Contoh Gabungan

```bash
distfiles="${SOURCEFORGE_SITE}/foo/foo-${version}.tar.xz
 https://example.org/extra-${version}.zip>extra.zip"
checksum="aaaaaaaa...  bbbbbbbb..."
skip_extraction="extra.zip"
changelog="https://example.org/foo/raw/master/CHANGELOG"
```

Perhatikan baris lanjutan `distfiles` diberi **satu spasi** indentasi, sesuai konvensi.

---

## Intinya

- `distfiles` + `checksum` = apa yang diunduh dan bagaimana diverifikasi (urutannya harus sama).
- Awalan `@` pada checksum untuk arsip yang dibuat *on the fly*.
- `wrksrc`, `build_wrksrc`, `create_wrksrc` mengatur lokasi kerja hasil ekstraksi.
- `skip_extraction` melewati ekstraksi file tertentu.

---

<!-- nav -->
[← Fungsi Global (Fungsi Bantu `v...`)](../02_dasar-template/03-fungsi-global.md) | [Daftar Isi](../DaftarISI.md) | [Variabel Opsional: Konfigurasi Build →](../02_dasar-template/05-variabel-opsional-build.md)
