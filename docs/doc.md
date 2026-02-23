# Dokumentasi VUR (Void User Repository)

Dokumentasi ini menjelaskan **cara menggunakan VUR** dan **cara membuat template paket** untuk VUR menggunakan `xbps-src`. Ditujukan untuk pengguna Void Linux, developer, dan maintainer paket.

---

## Prasyarat

Sebelum menggunakan VUR, pastikan:

* Menggunakan **Void Linux**
* Sudah menginstal `git`
* Sudah menginstal `xbps-src`

```sh
sudo xbps-install -S git xtools
```

Pastikan `xbps-src` sudah terkonfigurasi:

```sh
xbps-src binary-bootstrap
```

---

## Cara Menggunakan VUR

### 1. Clone Repository VUR

```sh
git clone https://gitlab.com/vur/vur.git
cd vur
```

Struktur utama:

```
VUR/
├── core/
├── extra/
└── multilib/
```

---

### 2. Build Paket dari VUR

Misalnya ingin membuild paket `foo` dari kategori `extra`:

```sh
cd extra/foo
xbps-src pkg foo
```

Hasil build akan berada di:

```
hostdir/binpkgs/
```

---

### 3. Install Paket dari VUR

```sh
sudo xbps-install --repository=hostdir/binpkgs foo
```

Atau install semua dependensi otomatis:

```sh
sudo xbps-install --repository=hostdir/binpkgs foo
```

---

## Cara Membuat Template Paket VUR

### 1. Tentukan Kategori

Pilih lokasi template:

* `core/` → paket sistem / penting
* `extra/` → software tambahan
* `multilib/` → paket 32-bit

Contoh:

```sh
cd extra
mkdir hello-vur
cd hello-vur
```

---

### 2. Buat File `template`

File `template` **wajib ada**.

Struktur minimal:

```sh
pkgname=hello-vur
version=1.0.0
revision=1
build_style=gnu-makefile
short_desc="Contoh paket VUR"
maintainer="Your Name <you@email.com>"
license="MIT"
homepage="https://example.com"
distfiles="https://example.com/hello-${version}.tar.gz"
checksum=SKIP
```

---

### 3. Penjelasan Field Penting

* **pkgname** : nama paket (lowercase, unik)
* **version** : versi upstream
* **revision** : revisi template (mulai dari 1)
* **build_style** : metode build (`gnu-makefile`, `cmake`, `python3-module`, dll)
* **short_desc** : deskripsi singkat
* **maintainer** : penanggung jawab paket
* **license** : lisensi software
* **distfiles** : source code upstream
* **checksum** : SHA256 source (hindari `SKIP` jika memungkinkan)

---

### 4. Build & Test Template

Dari root VUR:

```sh
xbps-src pkg hello-vur
```

Jika error, perbaiki sampai build sukses.

---

### 5. Menambahkan File Tambahan (Opsional)

Jika butuh patch atau file tambahan:

```
hello-vur/
├── template
└── files/
    └── fix-path.patch
```

Patch akan otomatis diaplikasikan oleh `xbps-src`.

---

## Contoh Build Style Umum

* `gnu-makefile`
* `cmake`
* `meson`
* `python3-module`
* `cargo`
* `go`

Contoh Python:

```sh
build_style=python3-module
```

---

## Aturan & Best Practice

* Jangan duplikasi paket repo resmi Void
* Gunakan source resmi upstream
* Jangan sertakan binary prebuilt
* Pastikan template bisa dibuild bersih
* Update jika upstream berubah

---

## Kontribusi ke VUR

1. Fork repository VUR
2. Tambahkan / perbaiki template
3. Test build lokal
4. Buat Merge Request (MR)

---

## Troubleshooting

### Gagal Download Source

* Periksa URL `distfiles`
* Pastikan versi benar

### Checksum Salah

```sh
xbps-src fetch
xbps-src verify
```

---

## Catatan Penting

Paket VUR bersifat **tidak resmi**.
Gunakan dengan risiko masing-masing.

---

> VUR — dari komunitas Void, untuk komunitas Void 🐧

## Informasi Tambahan
- Manual Official : [Manual.md](https://github.com/void-linux/void-packages/blob/master/Manual.md)
- Website : [xbps-src tutorials](https://xbps-src-tutorials.github.io/)