# Kelas Paket: Development, Data, dan Dokumentasi

> **Ringkasan:** Tiga jenis subpackage yang paling sering dijumpai: **`-devel`** (file pengembangan), **`-data`** (data besar), dan **`-doc`** (dokumentasi). Masing-masing punya aturan kapan sebaiknya dibuat.

---

## 1. Paket Development (`-devel`)

Paket development biasanya dihasilkan sebagai subpackage. Isinya **hanya file yang dibutuhkan untuk pengembangan**:

- header,
- static library,
- symlink shared library,
- file pkg-config,
- dokumentasi API,
- skrip lain yang hanya berguna saat mengembangkan perangkat lunak target.

### Dependensi Paket `-devel`

Paket development **harus bergantung** pada paket yang dibutuhkan untuk me-*link* shared library yang disediakannya.

**Contoh:** jika `libfoo` menyediakan `libfoo.so.2` dan proses link membutuhkan `-lbar`, maka paket yang menyediakan library `libbar` harus ditambahkan sebagai dependensi, dan kemungkinan besar harus bergantung pada **paket development-nya**.

Jika paket development menyediakan file **pkg-config**, periksa dependensi untuk link dinamis atau statis, lalu tambahkan paket **development** yang sesuai sebagai dependensi.

### File yang Biasa Dipindahkan (C dan C++)

Gunakan `vmove` untuk memindahkan file-file berikut dari paket utama:

| Jenis file | Lokasi |
|---|---|
| Header | `usr/include` |
| Static library | `usr/lib/*.a` |
| Symlink shared library | `usr/lib/*.so` |
| Aturan CMake | `usr/lib/cmake`, `usr/share/cmake` |
| File pkg-config | `usr/lib/pkgconfig`, `usr/share/pkgconfig` |
| Makro autoconf | `usr/share/aclocal` |
| File XML GObject introspection | `usr/share/gir-1.0` |
| Binding Vala | `usr/share/vala` |

```bash
foo-devel_package() {
	short_desc+=" - development files"
	depends="${sourcepkg}>=${version}_${revision}"
	pkg_install() {
		vmove usr/include
		vmove "usr/lib/*.a"
		vmove "usr/lib/*.so"
		vmove usr/lib/cmake
		vmove usr/lib/pkgconfig
	}
}
```

---

## 2. Paket Data (`-data`)

Subpackage `-data` dipakai untuk **memisahkan data yang tidak bergantung arsitektur** dan berukuran **besar/sangat besar** dari bagian utama paket yang bergantung arsitektur.

Kamu yang memutuskan apakah `-data` masuk akal untuk paketmu. Jenis ini umum untuk:

- **game** (grafik, suara, musik),
- **library komponen** (CAD),
- **materi kartu/peta**.

Paket utama harus punya:

```bash
depends="${pkgname}-data-${version}_${revision}"
```

(mungkin ditambah dependensi non-otomatis lainnya).

---

## 3. Paket Dokumentasi (`-doc`)

Paket yang ditujukan untuk interaksi pengguna tidak selalu **mewajibkan** bagian dokumentasinya. Contoh: pengguna yang tidak ingin mengembangkan dengan Qt5 tidak perlu memasang paket `qt5-doc` yang besar. Seorang ahli mungkin juga tidak membutuhkannya atau lebih suka versi online.

### Kapan Membuat `-doc`?

Umumnya paket `-doc` berguna jika:

1. Paket utama bisa dipakai **dengan atau tanpa** dokumentasi, **dan**
2. **Ukuran** dokumentasi tidak benar-benar kecil.

Paket dasar dan subpackage `-devel` sebaiknya dijaga tetap **kecil**, agar saat membangun paket yang bergantung padanya tidak perlu memasang dokumentasi besar tanpa alasan. **Ukuran bagian dokumentasi** adalah pedoman untuk memutuskan apakah perlu memecah paket `-doc`.

---

## 4. Perbandingan

| Jenis | Isi | Dibutuhkan saat | Wajib dependensi dari paket utama? |
|---|---|---|---|
| `-devel` | Header, `.a`, `.so`, pkg-config, dll | **Mengembangkan** perangkat lunak | Tidak (`-devel` yang bergantung pada paket utama) |
| `-data` | Data besar bebas arsitektur | **Menjalankan** program | **Ya** (`depends="${pkgname}-data-..."`) |
| `-doc` | Dokumentasi besar | Membaca dokumentasi | Tidak (opsional bagi pengguna) |

---

## Intinya

- `-devel`: file untuk kompilasi; dependensinya harus lengkap sehingga proses link berhasil.
- `-data`: data besar bebas arsitektur; paket utama **wajib bergantung** padanya.
- `-doc`: pecah hanya jika dokumentasi besar dan paket tetap bisa dipakai tanpanya.

---

<!-- nav -->
[← Paket 32-bit](../07_subpackage-dan-kelas-paket/02-paket-32bit.md) | [Daftar Isi](../DaftarISI.md) | [Kelas Paket: Python →](../07_subpackage-dan-kelas-paket/04-paket-python.md)
