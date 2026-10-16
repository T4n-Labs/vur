# 9. Functions (Siklus Hidup Build)

[« Build Helper Scripts](08-build-helper-scripts.md) · [Daftar Isi](README.md) · Selanjutnya: [Build Options »](10-build-options.md)

Fungsi-fungsi berikut bisa didefinisikan untuk mengubah perilaku bagaimana
paket diunduh, dikompilasi, dan dipasang.

- **`pre_fetch()`** — Aksi yang dijalankan sebelum `do_fetch()`.
- **`do_fetch()`** — Jika didefinisikan dan `distfiles` tidak diset,
  dipakai untuk mengambil source yang dibutuhkan.
- **`post_fetch()`** — Aksi yang dijalankan setelah `do_fetch()`.
- **`pre_extract()`** — Aksi yang dijalankan setelah `post_fetch()`.
- **`do_extract()`** — Jika didefinisikan dan `distfiles` tidak diset,
  dipakai untuk mengekstrak source yang dibutuhkan.
- **`post_extract()`** — Aksi yang dijalankan setelah `do_extract()`.
- **`pre_patch()`** — Aksi yang dijalankan setelah `post_extract()`.
- **`do_patch()`** — Jika didefinisikan, dipakai untuk menyiapkan
  environment build dan menjalankan hook untuk menerapkan patch.
- **`post_patch()`** — Aksi yang dijalankan setelah `do_patch()`.
- **`pre_configure()`** — Aksi yang dijalankan setelah `post_patch()`.
- **`do_configure()`** — Aksi untuk mengonfigurasi paket; `${configure_args}`
  tetap harus dipassing jika memakai script GNU configure.
- **`post_configure()`** — Aksi yang dijalankan setelah `do_configure()`.
- **`pre_build()`** — Aksi yang dijalankan setelah `post_configure()`.
- **`do_build()`** — Aksi untuk membangun paket.
- **`post_build()`** — Aksi yang dijalankan setelah `do_build()`.
- **`pre_check()`** — Aksi yang dijalankan setelah `post_build()`.
- **`do_check()`** — Aksi untuk menjalankan pemeriksaan (test) paket.
- **`post_check()`** — Aksi yang dijalankan setelah `do_check()`.
- **`pre_install()`** — Aksi yang dijalankan setelah `post_check()`.
- **`do_install()`** — Aksi untuk memasang file paket ke `fake destdir`.
- **`post_install()`** — Aksi yang dijalankan setelah `do_install()`.
- **`do_clean()`** — Aksi untuk membersihkan setelah fase paket berhasil.

> Fungsi yang didefinisikan di template lebih diutamakan daripada fungsi
> dengan nama sama yang didefinisikan oleh script `build_style`.

## Working Directory per Fungsi

Direktori kerja (current working directory) untuk fungsi-fungsi di atas
diatur sebagai berikut:

| Fungsi | Working Directory |
|---|---|
| `pre_fetch`, `pre_extract`, `do_clean` | `<masterdir>` |
| `do_fetch`, `post_fetch` | `XBPS_BUILDDIR` |
| `do_extract` s/d `do_patch` | `wrksrc` |
| `post_patch` s/d `post_install` | `build_wrksrc` (jika didefinisikan), jika tidak `wrksrc` |
