# Manual Paket Sumber XBPS (Bahasa Indonesia)

Dokumentasi lengkap tentang cara membuat paket sumber untuk **XBPS**, sistem
manajemen paket bawaan **Void Linux**. Dokumen asli (Bahasa Inggris) telah
dipecah menjadi beberapa bagian agar lebih mudah dibaca, baik untuk pemula
maupun yang sudah mahir.

> Ditujukan juga sebagai referensi untuk pengembangan **T4n OS** (turunan Void
> Linux berbasis musl libc).

## Daftar Isi / Struktur Project

| # | File | Isi |
|---|------|-----|
| 1 | [01-pengantar-dan-fase-build.md](01-pengantar-dan-fase-build.md) | Pengantar `template`, contoh dasar, dan tahapan (`phase`) build |
| 2 | [02-konvensi-penamaan.md](02-konvensi-penamaan.md) | Aturan penamaan paket: library, modul bahasa, binding, program |
| 3 | [03-fungsi-dan-variabel-global.md](03-fungsi-dan-variabel-global.md) | Fungsi bawaan (`vinstall`, `vmove`, dst.) dan variabel global `xbps-src` |
| 4 | [04-variabel-wajib-dan-opsional.md](04-variabel-wajib-dan-opsional.md) | Variabel wajib (`pkgname`, `version`, dst.) dan puluhan variabel opsional |
| 5 | [05-dependencies.md](05-dependencies.md) | Penjelasan `hostmakedepends`, `makedepends`, `checkdepends`, `depends` |
| 6 | [06-repositories-dan-update-check.md](06-repositories-dan-update-check.md) | Repository (`bootstrap`, `debug`, `nonfree`) & pengecekan versi upstream |
| 7 | [07-patch-dan-build-style.md](07-patch-dan-build-style.md) | Cara kerja patch dan daftar lengkap `build_style` |
| 8 | [08-build-helper-scripts.md](08-build-helper-scripts.md) | Daftar `build_helper` (rust, python3, meson, qemu, dst.) |
| 9 | [09-functions-lifecycle.md](09-functions-lifecycle.md) | Fungsi siklus hidup build: `pre_*`, `do_*`, `post_*` |
| 10 | [10-build-options.md](10-build-options.md) | Cara membuat opsi build (`build_options`, `vopt_*`) |
| 11 | [11-install-remove-scripts.md](11-install-remove-scripts.md) | File `INSTALL`/`REMOVE` dan `INSTALL.msg`/`REMOVE.msg` |
| 12 | [12-akun-sistem-dan-runit.md](12-akun-sistem-dan-runit.md) | Membuat user/group sistem & menulis service runit |
| 13 | [13-32bit-dan-subpackages.md](13-32bit-dan-subpackages.md) | Paket 32-bit dan cara membuat subpackage |
| 14 | [14-kelas-paket.md](14-kelas-paket.md) | Paket `-devel`, `-data`, `-doc`, Python, Go, Haskell, Font |
| 15 | [15-rename-remove-package.md](15-rename-remove-package.md) | Prosedur mengganti nama & menghapus paket |
| 16 | [16-xbps-triggers.md](16-xbps-triggers.md) | Daftar lengkap XBPS Triggers dan fungsinya |
| 17 | [17-catatan-dan-kontribusi.md](17-catatan-dan-kontribusi.md) | Catatan umum, dokumentasi khusus Void, dan cara kontribusi via git |

## Cara Membaca

- **Pemula**: mulai dari file 1–4 untuk memahami dasar struktur `template`.
- **Menengah**: file 5–11 membahas dependency, build style, dan opsi build.
- **Advanced / maintainer**: file 12–17 membahas runit, subpackage, triggers,
  hingga alur kontribusi.

Semua istilah teknis (nama variabel, fungsi, command) **sengaja dibiarkan
dalam Bahasa Inggris/kode asli** agar tetap sinkron dengan kode sumber
`void-packages`, sementara penjelasannya diterjemahkan ke Bahasa Indonesia.
