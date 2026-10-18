# Apa Itu XBPS Source Packages?

> **Ringkasan:** Mengenal "resep" pembuatan paket di Void Linux (disebut *template*), alat yang memprosesnya (`xbps-src`), dan hasil akhirnya berupa paket `.xbps`.

---

## 1. Gambaran Besar

**XBPS** adalah sistem paket bawaan (*native*) milik **Void Linux**. Kalau kamu pernah memakai `apt` (Debian/Ubuntu) atau `pacman` (Arch Linux), XBPS adalah padanannya di Void.

Dokumentasi ini membahas sisi "dapur"-nya: **bagaimana cara membuat paket baru** dari kode sumber (*source code*) sampai menjadi paket siap pasang.

Repositori yang menyimpan semua "resep" paket Void Linux bernama **`void-packages`**. Setiap resep disebut **`template`**.

### Analogi: Memasak

| Dunia memasak | Dunia XBPS |
|---|---|
| Buku resep | Repositori `void-packages` |
| Satu lembar resep | Satu file `template` |
| Koki | `xbps-src` (pembuat paket / *package builder*) |
| Bahan mentah | Kode sumber dari pengembang asli (*upstream*) |
| Makanan siap saji | Paket biner `.xbps` |

---

## 2. Istilah Penting

Biar tidak bingung di bagian-bagian berikutnya, kenali dulu istilah-istilah ini:

| Istilah | Artinya |
|---|---|
| **`void-packages`** | Repositori git berisi semua template paket Void Linux. |
| **`template`** | File "resep" untuk satu paket. Isinya skrip shell berisi variabel dan fungsi. |
| **`xbps-src`** | Program yang membaca template lalu mengunduh, mengompilasi, dan mengemas paket. |
| **`srcpkgs`** | Folder di dalam `void-packages` tempat semua template disimpan. |
| **Paket sumber** (*source package*) | Resep + file pendukungnya (template, patch, dll). |
| **Paket biner** (*binary package*) | Hasil jadi berekstensi `.xbps` yang bisa dipasang pengguna. |
| **Upstream** | Pengembang asli perangkat lunak yang kamu paketkan. |
| **`distfiles`** | File sumber (biasanya `.tar.gz`) yang diunduh dari upstream. |
| **`destdir`** | Direktori sementara tempat hasil instalasi dikumpulkan sebelum dikemas. |
| **Subpackage** | Paket tambahan yang dihasilkan dari satu template yang sama (misalnya `foo-devel`). |

---

## 3. Apa Itu Template?

File **template** adalah **skrip shell** yang mendefinisikan:

- **variabel** (nama paket, versi, URL unduhan, lisensi, dst.), dan
- **fungsi** (langkah-langkah khusus kalau cara standar tidak cukup).

Semua itu diproses oleh `xbps-src` untuk menghasilkan paket biner.

> **Penting:** Shell yang dipakai `xbps-src` adalah **GNU bash**, bukan POSIX `sh`. Jadi fitur khas bash boleh dipakai di template.

### Konvensi Penulisan

- Template selalu diawali komentar yang menyatakan bahwa itu *template file* untuk paket tertentu.
- Usahakan sebagian besar baris **kurang dari 80 kolom**.
- Variabel yang berisi banyak nilai boleh dipecah ke beberapa baris. Baris lanjutan **diberi indentasi satu spasi**.

---

## 4. Contoh Template Paling Sederhana

```bash
# Template file for 'foo'
pkgname=foo
version=1.0
revision=1
build_style=gnu-configure
short_desc="Package description, no more than 72 characters"
maintainer="name <email>"
distributor="name <email>"
license="GPL-3.0-or-later"
homepage="http://www.foo.org"
distfiles="http://www.foo.org/foo-${version}.tar.gz"
checksum="fea0a94d4b605894f3e2d5572e3f96e4413bcad3a085aae7367c2cf07908b2ff"
```

### Penjelasan Baris demi Baris

| Baris | Fungsi |
|---|---|
| `# Template file for 'foo'` | Komentar pembuka sesuai konvensi. |
| `pkgname=foo` | Nama paket. |
| `version=1.0` | Versi perangkat lunak dari upstream. |
| `revision=1` | Nomor revisi paket (dimulai dari 1). |
| `build_style=gnu-configure` | Cara membangun paket: memakai skrip `configure` ala GNU autotools. |
| `short_desc="..."` | Deskripsi singkat, **maksimal 72 karakter**. |
| `maintainer="name <email>"` | Nama dan email pemelihara paket. |
| `license="GPL-3.0-or-later"` | Lisensi perangkat lunak. |
| `homepage="..."` | Halaman utama upstream. |
| `distfiles="..."` | URL file sumber yang akan diunduh. `${version}` otomatis terisi dari variabel `version`. |
| `checksum="..."` | Sidik jari (hash SHA256) file sumber untuk memastikan file tidak rusak atau diganti. |

Template berisi definisi untuk **mengunduh, membangun, dan memasang** file paket ke sebuah **`fake destdir`** (direktori palsu/sementara, bukan sistem aslimu). Setelah itu, paket biner dibuat dari isi direktori tersebut.

> **Tenang saja** kalau belum paham semuanya. Setiap variabel dan fungsi akan dibahas pelan-pelan di bagian berikutnya.

---

## 5. Di Mana Template Disimpan?

Template harus berada di folder yang **namanya sama dengan `$pkgname`**:

```
void-packages/srcpkgs/foo/template
```

Struktur umum satu paket di dalam `srcpkgs` (sebagian besar bersifat opsional dan akan dibahas nanti):

```
void-packages/
├── srcpkgs/
│   └── foo/
│       ├── template        <- wajib: resep utama
│       ├── patches/        <- opsional: patch untuk kode sumber
│       ├── files/          <- opsional: file tambahan ($FILESDIR)
│       ├── update          <- opsional: aturan cek versi baru
│       ├── INSTALL         <- opsional: skrip saat pasang paket
│       ├── REMOVE          <- opsional: skrip saat hapus paket
│       ├── INSTALL.msg     <- opsional: pesan setelah pasang
│       └── REMOVE.msg      <- opsional: pesan sebelum hapus
└── common/                 <- skrip & data bersama (build-style, shlibs, dll)
```

---

## 6. Membangun Paket

Setelah template siap, jalankan dari folder `void-packages`:

```bash
./xbps-src pkg <nama-paket>
```

Jika semuanya lancar, akan terbentuk paket biner bernama:

```
foo-1.0_1.<arch>.xbps
```

di repositori lokal `hostdir/binpkgs`.

### Membaca Nama Paket Hasil Build

```
foo-1.0_1.x86_64.xbps
 │   │  │   │
 │   │  │   └── arsitektur (contoh: x86_64)
 │   │  └────── revisi (revision)
 │   └───────── versi (version)
 └───────────── nama paket (pkgname)
```

---

## 7. Persiapan Sebelum Mulai (Tambahan)

> Catatan: bagian ini **bukan dari Manual.md**, melainkan langkah umum yang dijelaskan di README repositori `void-packages`. Selalu rujuk README resmi untuk versi terbaru.

Secara garis besar kamu perlu:

1. Meng-*clone* repositori `void-packages`.
2. Menyiapkan lingkungan build (*masterdir*/chroot) lewat perintah bootstrap bawaan `xbps-src`.

```bash
git clone https://github.com/void-linux/void-packages.git
cd void-packages
./xbps-src binary-bootstrap
```

---

## Intinya

- **Template** = resep paket berupa skrip bash; **`xbps-src`** = koki yang menjalankannya.
- Template ditaruh di `srcpkgs/<pkgname>/template`.
- Perintah dasar membangun paket: `./xbps-src pkg <pkgname>`.
- Hasilnya: file `.xbps` di `hostdir/binpkgs`.

---

<!-- nav -->
[← Daftar Isi](../DaftarISI.md) | [Daftar Isi](../DaftarISI.md) | [Fase Build Paket →](../01_pengenalan/02-fase-build.md)
