# 7. Menangani Patch & Build Style Scripts

[« Repositories & Update Check](06-repositories-dan-update-check.md) · [Daftar Isi](README.md) · Selanjutnya: [Build Helper Scripts »](08-build-helper-scripts.md)

## Menangani Patch

Terkadang software perlu di-patch, paling umum untuk memperbaiki bug yang
ditemukan atau memperbaiki kompilasi dengan software baru.

Untuk ini, `xbps-src` punya fungsi patching. Ia akan mencari semua file yang
cocok dengan glob `srcpkgs/$pkgname/patches/*.{diff,patch}` dan otomatis
menerapkan semua file yang ditemukan memakai `patch(1)` dengan opsi `-Np1`.
Ini terjadi selama fase `do_patch()`. Variabel `PATCHESDIR` tersedia di
template, menunjuk ke direktori `patches`.

Perilaku patching bisa diubah dengan cara berikut:

- Membuat file bernama `series` di direktori `patches`, berisi daftar
  patch (dipisah baris baru) yang akan diterapkan sesuai urutan yang
  ditulis. Jika file ini ada, `xbps-src` hanya akan menerapkan patch yang
  disebutkan di file `series`.
- Membuat file dengan nama sama seperti salah satu patch, tapi dengan
  ekstensi `.args`, untuk mengatur argumen yang dipassing ke `patch(1)`.
  Contoh: jika `foo.patch` butuh argumen khusus yang tidak bisa dipakai
  saat menerapkan patch lain, buat `foo.patch.args` berisi argumen
  tersebut.

## Build Style Scripts

Variabel `build_style` menentukan metode build untuk memasang dan
menginstall sebuah paket. Nilainya harus berupa nama script yang tersedia
di direktori `void-packages/common/build-style`. Perlu diingat, paket yang
dibutuhkan untuk menjalankan script `build_style` harus didefinisikan lewat
`$hostmakedepends`.

Berikut daftar lengkap script `build_style` yang tersedia:

- **(kosong / tidak diset)** — Template harus (minimal) mendefinisikan
  fungsi `do_install()`, dan opsional fase build lain seperti
  `do_configure()`, `do_build()`, dll., serta bisa meng-override
  `do_fetch()` dan `do_extract()` default yang mengunduh dan mengekstrak
  file dari variabel `distfiles`.
- **`cargo`** — Untuk paket Rust yang memakai Cargo. Argumen konfigurasi
  (mis. `--features`) bisa diset di `configure_args`, dipassing ke cargo
  saat `do_build`.
- **`cmake`** — Untuk paket yang memakai CMake. Argumen konfigurasi
  dipassing via `configure_args`. Variabel `cmake_builddir` bisa
  didefinisikan untuk menentukan direktori build di bawah `build_wrksrc`,
  menggantikan default `build`.
- **`configure`** — Untuk paket yang memakai script `configure` non-GNU.
  Minimal `--prefix=/usr` harus dipassing via `configure_args`.
- **`fetch`** — Untuk paket yang hanya mengambil file dan dipasang apa
  adanya lewat `do_install()`.
- **`gnu-configure`** — Untuk paket yang memakai script `configure`
  kompatibel GNU autotools. Argumen konfigurasi tambahan bisa dipassing
  via `configure_args`.
- **`gnu-makefile`** — Untuk paket yang memakai GNU make. Argumen build
  bisa dipassing via `make_build_args`, argumen install via
  `make_install_args`. Target build bisa di-override via
  `make_build_target`, target install via `make_install_target`. Build
  style ini berusaha mengompensasi makefile yang tidak menghormati
  environment variable; makefile yang ditulis dengan baik (yang misalnya
  melakukan append `+=` ke variabel) sebaiknya mengeset `make_use_env` di
  body template.
- **`go`** — Untuk program Go yang mengikuti struktur paket standar.
  Variabel `go_import_path` harus diset ke import path paket, mis.
  `github.com/github/hub` untuk program `hub`. Info ini bisa ditemukan di
  file `go.mod` pada project Go modern. Diharapkan distfile berisi paket
  itu sendiri, namun dependency-nya akan diunduh dengan `go get`.
- **`R-cran`** — Untuk paket yang tersedia di CRAN (The Comprehensive R
  Archive Network). Build style ini mengharuskan `pkgname` diawali
  `R-cran-`, dan semua tanda hubung (`-`) di versi CRAN diganti dengan
  huruf `r` di variabel `version`. Lokasi `distfiles` akan otomatis diset,
  begitu juga dependency ke `R`.
- **`gemspec`** — Untuk paket yang memakai file
  [gemspec](https://guides.rubygems.org/specification-reference/) untuk
  membangun gem Ruby, lalu memasangnya. Command `gem` bisa di-override via
  `gem_cmd`. `configure_args` bisa dipakai untuk argumen saat kompilasi.
  Jika paket tidak memakai extension terkompilasi, pertimbangkan memakai
  build style `gem` saja.
- **`gem`** — Untuk paket yang dipasang lewat gem dari
  [RubyGems](https://rubygems.org/). Command `gem` bisa di-override via
  `gem_cmd`. `distfiles` diset otomatis oleh build style ini jika template
  tidak mengesetnya. Jika gem menyediakan extension yang harus
  dikompilasi, pertimbangkan memakai build style `gemspec`.
- **`ruby-module`** — Untuk paket berupa modul Ruby yang dipasang lewat
  `ruby install.rb`. Argumen install tambahan bisa diset via
  `make_install_args`.
- **`perl-ModuleBuild`** — Untuk paket yang memakai metode Perl
  [Module::Build](https://metacpan.org/pod/Module::Build).
- **`perl-module`** — Untuk paket yang memakai metode build Perl
  [ExtUtils::MakeMaker](http://perldoc.perl.org/ExtUtils/MakeMaker.html).
- **`raku-dist`** — Untuk paket yang memakai metode build `raku-install-dist`
  milik Raku dengan rakudo.
- **`waf3`** — Untuk paket yang memakai metode build `waf` Python3 dengan
  python3.
- **`slashpackage`** — Untuk paket yang memakai hierarki `/package` dan
  `package/compile` untuk build, seperti `daemontools` atau software `djb`
  lainnya.
- **`qmake`** — Untuk paket yang memakai profil qmake Qt5/Qt6 (`*.pro`).
  Argumen qmake untuk fase configure bisa dipassing via `configure_args`,
  argumen build via `make_build_args`, argumen install via
  `make_install_args`. Target build/install bisa di-override via
  `make_build_target`/`make_install_target`.
- **`meson`** — Untuk paket yang memakai sistem Meson Build. Opsi
  konfigurasi bisa dipassing via `configure_args`, command meson bisa
  di-override via `meson_cmd`, dan lokasi out-of-source build via
  `meson_builddir`.
- **`void-cross`** — Untuk paket cross-toolchain yang dipakai membangun
  sistem Void. Tidak ada variabel wajib (target triplet ditebak otomatis),
  tapi ada beberapa opsional: `cross_gcc_skip_go` untuk skip `gccgo`;
  argumen configure per-subproject via `cross_*_configure_args` (`*` bisa
  `binutils`, `gcc_bootstrap`, `gcc`, `glibc`/`musl`); `configure_args`
  juga dipassing ke gcc awal maupun akhir. `CFLAGS`/`LDFLAGS` custom untuk
  libc bisa diset via `cross_(glibc|musl)_(cflags|ldflags)`.
- **`zig-build`** — Untuk paket yang memakai sistem build
  [Zig](https://ziglang.org). Argumen tambahan bisa dipassing ke
  invocation `zig build` via `configure_args`.
- **`texmf`** — Untuk zip/tarball texmf yang perlu masuk ke
  `/usr/share/texmf-dist`. Termasuk penanganan file duplikat.
- **`tree-sitter`** — Untuk grammar bahasa tree-sitter.

### Build style khusus Python

Untuk paket yang memakai metode build modul Python (`setup.py` atau
[PEP 517](https://www.python.org/dev/peps/pep-0517/)), pilih salah satu:

- **`python3-module`** — untuk membangun modul Python 3.x.
- **`python3-pep517`** — untuk membangun modul Python 3.x yang menyediakan
  deskripsi build PEP 517 tanpa script `setup.py`.

Environment variable untuk `build_style` tertentu bisa dideklarasikan di
file dengan nama sesuai nama `build_style`, contoh:

```
common/environment/build-style/gnu-configure.sh
```
