# Subpackage

> **Ringkasan:** Satu template bisa menghasilkan **beberapa paket biner sekaligus**. Paket-paket tambahan ini disebut **subpackage**, misalnya `foo` dan `foo-devel` yang berasal dari satu proses build.

---

## 1. Kenapa Perlu Subpackage?

Pada contoh-contoh sebelumnya, template hanya menghasilkan **satu** paket biner. Dengan sedikit tambahan, satu template/build bisa menghasilkan banyak paket. Contoh umum:

- `foo` → program/library utama
- `foo-devel` → header dan file pengembangan
- `foo-doc` → dokumentasi besar
- `foo-data` → data besar

Dengan begitu pengguna biasa tidak perlu memasang file yang tidak dibutuhkan.

---

## 2. Cara Membuat Subpackage

Definisikan fungsi baru dengan format penamaan:

```
<namasubpkg>_package()
```

Contoh lengkap:

```bash
# Template file for 'foo'
pkgname=foo
version=1.0
revision=1
build_style=gnu-configure
short_desc="A short description max 72 chars"
maintainer="name <email>"
distributor="name <email>"
license="GPL-3.0-or-later"
homepage="http://www.foo.org"
distfiles="http://www.foo.org/foo-${version}.tar.gz"
checksum="fea0a94d4b605894f3e2d5572e3f96e4413bcad3a085aae7367c2cf07908b2ff"

# foo-devel is a subpkg
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

### Penjelasan

| Bagian | Arti |
|---|---|
| `foo-devel_package() { ... }` | Mendefinisikan subpackage bernama `foo-devel`. |
| `short_desc+=" - development files"` | Menambahkan keterangan ke deskripsi singkat. |
| `depends="${sourcepkg}>=${version}_${revision}"` | Subpackage bergantung pada paket utama dengan versi yang sesuai. |
| `pkg_install() { ... }` | Fungsi yang **memindahkan file** dari paket utama ke subpackage. |

---

## 3. Symlink Wajib

Semua subpackage membutuhkan **symlink tambahan** ke paket utama. Tanpa itu, dependensi yang membutuhkan subpackage tidak akan menemukan `template`-nya.

```
 /srcpkgs
  |- foo <- directory (main pkg)
  |  |- template
  |- foo-devel <- symlink to `foo`
```

Membuatnya:

```bash
cd srcpkgs
ln -s foo foo-devel
```

---

## 4. Aturan Penting

- Paket **utama** harus menyebutkan **semua dependensi build** yang dibutuhkan untuk membangun **semua subpackage** di template.
- Subpackage diproses **setelah** paket utama menyelesaikan fase `install`.
- Fungsi `pkg_install()` di subpackage biasanya dipakai untuk **memindahkan file** dari `destdir` paket utama ke `destdir` subpackage.
- Fungsi bantu `vinstall`, `vmkdir`, `vcopy`, dan `vmove` adalah pembungkus yang menyederhanakan pembuatan, penyalinan, dan pemindahan file/direktori antara:
  - `destdir` paket utama (**`$DESTDIR`**), dan
  - `destdir` subpackage (**`$PKGDESTDIR`**).

---

## 5. Urutan Pemrosesan

Subpackage diproses **selalu berurutan alfabet**. Untuk memaksa urutan khusus, deklarasikan variabel **`subpackages`** dengan urutan yang diinginkan.

```bash
subpackages="foo-libs foo-devel"
```

---

## 6. Alur Visual

```
Template foo
    │
    ├── Build & install paket utama ──► $DESTDIR (isi semua file)
    │
    └── foo-devel_package()
            └── pkg_install(): vmove usr/include, usr/lib/*.so, ...
                    │
                    ▼
               $PKGDESTDIR (hanya file pengembangan)
```

Hasilnya dua paket biner:

```
foo-1.0_1.x86_64.xbps
foo-devel-1.0_1.x86_64.xbps
```

---

## Intinya

- Subpackage dibuat dengan fungsi `<nama>_package()`.
- Selalu buat **symlink** subpackage ke direktori paket utama di `srcpkgs`.
- Subpackage diproses setelah `install` paket utama; `pkg_install()` memindahkan file dengan `vmove` dkk.
- Urutan default alfabet; ubah dengan variabel `subpackages`.

---

<!-- nav -->
[← Menulis Layanan runit](../06_skrip-dan-layanan/04-layanan-runit.md) | [Daftar Isi](../DaftarISI.md) | [Paket 32-bit →](../07_subpackage-dan-kelas-paket/02-paket-32bit.md)
