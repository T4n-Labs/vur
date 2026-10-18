# Fungsi di Template (Hook Fase Build)

> **Ringkasan:** Kamu bisa mengubah perilaku unduh, kompilasi, dan pemasangan dengan mendefinisikan **fungsi** di template. Ada tiga jenis: `pre_...` (sebelum), `do_...` (inti), dan `post_...` (sesudah).

---

## 1. Tiga Jenis Fungsi

| Awalan | Arti | Kapan dipakai |
|---|---|---|
| `pre_<fase>()` | Aksi **sebelum** fase inti | Menyiapkan sesuatu sebelum fase berjalan. |
| `do_<fase>()` | Aksi **inti** fase | Menggantikan perilaku bawaan fase tersebut. |
| `post_<fase>()` | Aksi **sesudah** fase inti | Merapikan atau menambah sesuatu setelah fase selesai. |

> **Tips pemula:** Kalau `build_style` kamu sudah mengerjakan sebagian besar pekerjaan, cukup tambahkan `pre_...` atau `post_...` untuk penyesuaian kecil, tanpa menimpa seluruh `do_...`.

---

## 2. Daftar Lengkap Fungsi (Berurutan)

| Urutan | Fungsi | Keterangan |
|---|---|---|
| 1 | `pre_fetch()` | Aksi sebelum `do_fetch()`. |
| 2 | `do_fetch()` | Jika didefinisikan dan `distfiles` **tidak** diatur, dipakai untuk mengunduh sumber yang dibutuhkan. |
| 3 | `post_fetch()` | Aksi setelah `do_fetch()`. |
| 4 | `pre_extract()` | Aksi setelah `post_fetch()`. |
| 5 | `do_extract()` | Jika didefinisikan dan `distfiles` **tidak** diatur, dipakai untuk mengekstrak sumber. |
| 6 | `post_extract()` | Aksi setelah `do_extract()`. |
| 7 | `pre_patch()` | Aksi setelah `post_extract()`. |
| 8 | `do_patch()` | Jika didefinisikan, dipakai untuk menyiapkan lingkungan build dan menjalankan hook penerapan patch. |
| 9 | `post_patch()` | Aksi setelah `do_patch()`. |
| 10 | `pre_configure()` | Aksi setelah `post_patch()`. |
| 11 | `do_configure()` | Aksi untuk mengonfigurasi paket. `${configure_args}` tetap harus diteruskan jika memakai skrip configure GNU. |
| 12 | `post_configure()` | Aksi setelah `do_configure()`. |
| 13 | `pre_build()` | Aksi setelah `post_configure()`. |
| 14 | `do_build()` | Aksi untuk membangun paket. |
| 15 | `post_build()` | Aksi setelah `do_build()`. |
| 16 | `pre_check()` | Aksi setelah `post_build()`. |
| 17 | `do_check()` | Aksi untuk menjalankan tes paket. |
| 18 | `post_check()` | Aksi setelah `do_check()`. |
| 19 | `pre_install()` | Aksi setelah `post_check()`. |
| 20 | `do_install()` | Aksi untuk memasang file paket ke *fake destdir*. |
| 21 | `post_install()` | Aksi setelah `do_install()`. |
| - | `do_clean()` | Aksi untuk membersihkan setelah suatu fase paket berhasil. |

---

## 3. Aturan Prioritas

> Fungsi yang didefinisikan **di template** punya **prioritas lebih tinggi** daripada fungsi dengan nama yang sama dari skrip `build_style`.

Artinya: jika `gnu-configure` sudah punya `do_configure()` bawaan, lalu kamu menulis `do_configure()` sendiri di template, maka **versi milikmu** yang dipakai.

---

## 4. Direktori Kerja Tiap Fungsi

Direktori kerja saat ini (*current working directory*) untuk fungsi diatur sebagai berikut:

| Fungsi | Direktori kerja |
|---|---|
| `pre_fetch`, `pre_extract`, `do_clean` | `<masterdir>` |
| `do_fetch`, `post_fetch` | `XBPS_BUILDDIR` |
| `do_extract` sampai `do_patch` | `wrksrc` |
| `post_patch` sampai `post_install` | `build_wrksrc` jika didefinisikan, selain itu `wrksrc` |

---

## 5. Contoh Pemakaian

### Menyesuaikan sedikit lewat hook

```bash
# Template file for 'foo'
pkgname=foo
version=1.0
revision=1
build_style=gnu-configure
# ...variabel lain...

post_install() {
	vlicense COPYING
	vdoc README
}
```

### Menimpa fase sepenuhnya

```bash
do_build() {
	make ${makejobs} CC="${CC}" CFLAGS="${CFLAGS}"
}

do_install() {
	vbin foo
	vman foo.1
}
```

### Menyiapkan sesuatu sebelum konfigurasi

```bash
pre_configure() {
	autoreconf -fi
}
```

---

## Intinya

- Tiga jenis fungsi: `pre_`, `do_`, `post_` untuk setiap fase.
- Fungsi di template **menimpa** fungsi dari build style.
- Perhatikan direktori kerja tiap fungsi agar path relatif tidak salah.
- Pakai `post_install()` untuk hal-hal seperti memasang lisensi dan dokumentasi.

---

<!-- nav -->
[← Build Helper](../04_proses-build/02-build-helper.md) | [Daftar Isi](../DaftarISI.md) | [Menangani Patch →](../04_proses-build/04-patch.md)
