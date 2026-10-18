# Build Style

> **Ringkasan:** `build_style` memberi tahu `xbps-src` **cara membangun dan memasang** paketmu. Ibarat memilih "mode masak" yang sudah disiapkan sehingga kamu tidak perlu menulis semua langkah dari nol.

---

## 1. Apa Itu Build Style?

Variabel `build_style` meminta **nama skrip** yang tersedia di direktori `void-packages/common/build-style`.

```bash
build_style=gnu-configure
```

> **Penting:** paket yang dibutuhkan untuk menjalankan skrip `build_style` harus didefinisikan lewat `$hostmakedepends`.

---

## 2. Jika `build_style` Tidak Diatur

Template **minimal harus** mendefinisikan fungsi `do_install()`. Template juga boleh mendefinisikan fase lain seperti `do_configure()`, `do_build()`, dan seterusnya, serta boleh menimpa `do_fetch()` dan `do_extract()` bawaan yang mengunduh dan mengekstrak file dari `distfiles`.

```bash
# Tanpa build_style
do_build() {
	${CC} ${CFLAGS} -o foo foo.c
}

do_install() {
	vbin foo
}
```

---

## 3. Daftar Build Style (Dikelompokkan)

### Build system umum

| Build style | Untuk paket yang memakai | Catatan |
|---|---|---|
| `gnu-configure` | Skrip `configure` ala **GNU autotools** | Argumen tambahan lewat `configure_args`. |
| `configure` | Skrip `configure` **non-GNU** | Minimal `--prefix=/usr` lewat `configure_args`. |
| `gnu-makefile` | **GNU make** | Lihat detail di bawah. |
| `cmake` | **CMake** | `configure_args`; `cmake_builddir` untuk mengganti direktori build (default `build`). |
| `meson` | **Meson** | `configure_args`; `meson_cmd` mengganti perintah meson; `meson_builddir` lokasi build out-of-source. |
| `qmake` | **Qt5/Qt6 qmake** (`*.pro`) | `configure_args`, `make_build_args`, `make_install_args`, `make_build_target`, `make_install_target`. |
| `slashpackage` | Hierarki `/package` dan `package/compile` | Contoh: `daemontools` atau perangkat lunak `djb`. |
| `waf3` | **waf** dengan Python 3 | |
| `fetch` | Paket yang **hanya mengunduh file** | Dipasang apa adanya lewat `do_install()`. |

### Bahasa pemrograman

| Build style | Untuk | Catatan |
|---|---|---|
| `cargo` | Program **Rust** | Argumen (misal `--features`) lewat `configure_args`, diteruskan ke cargo saat `do_build`. |
| `go` | Program **Go** | Wajib set `go_import_path`. Dependensi diunduh dengan `go get`. |
| `zig-build` | Sistem build **Zig** | Argumen tambahan lewat `configure_args`. |
| `python3-module` | Modul **Python 3** (`setup.py`) | |
| `python3-pep517` | Modul Python 3 dengan **PEP 517** tanpa `setup.py` | |
| `gem` | Paket **RubyGems** | `gem_cmd` bisa diganti; `distfiles` diatur oleh build style jika tidak ditulis. |
| `gemspec` | Paket Ruby dengan file **gemspec** | Cocok untuk ekstensi yang dikompilasi. |
| `ruby-module` | Modul Ruby yang dipasang via `ruby install.rb` | Argumen tambahan lewat `make_install_args`. |
| `perl-module` | Perl **ExtUtils::MakeMaker** | |
| `perl-ModuleBuild` | Perl **Module::Build** | |
| `raku-dist` | **Raku** (`raku-install-dist` dengan rakudo) | |
| `R-cran` | Paket **CRAN** (R) | Nama harus diawali `R-cran-`. |
| `haskell-stack`, `cabal` | Paket **Haskell** | Lihat [Paket Haskell](../07_subpackage-dan-kelas-paket/06-paket-haskell.md). |

### Khusus lainnya

| Build style | Untuk | Catatan |
|---|---|---|
| `void-cross` | *Cross-toolchain* untuk membangun sistem Void | Lihat detail di bawah. |
| `texmf` | Zip/tarball texmf yang masuk ke `/usr/share/texmf-dist` | Termasuk penanganan duplikat. |
| `tree-sitter` | **Tata bahasa tree-sitter** | |

---

## 4. Detail Beberapa Build Style

### `gnu-makefile`

Argumen build lewat `make_build_args`, argumen install lewat `make_install_args`. Target build bisa ditimpa dengan `make_build_target`, target install dengan `make_install_target`.

Build style ini berusaha **mengimbangi Makefile yang tidak menghormati variabel lingkungan**. Makefile yang ditulis dengan baik (misalnya memakai `+=` untuk menambah variabel) sebaiknya mengatur **`make_use_env`** di badan template.

### `go`

- `go_import_path` **harus diatur** ke import path paket, contoh `github.com/github/hub` untuk program `hub`. Informasi ini ada di file `go.mod` pada proyek Go modern.
- `distfile` diharapkan sudah berisi paketnya; dependensi akan diunduh dengan `go get`.

### `R-cran`

- `pkgname` **harus diawali** `R-cran-`.
- Tanda hubung (`-`) pada versi CRAN harus diganti dengan karakter **`r`** di variabel `version`.
- Lokasi `distfiles` otomatis diatur, dan paket otomatis bergantung pada `R`.

### `gemspec` vs `gem`

- `gemspec`: membangun gem Ruby dari file gemspec lalu memasangnya; `gem_cmd` bisa diganti; `configure_args` untuk argumen kompilasi. Jika paket **tidak** memakai ekstensi terkompilasi, pertimbangkan `gem`.
- `gem`: memasang gem dari RubyGems. Jika gem punya ekstensi yang harus dikompilasi, pertimbangkan `gemspec`.

### `void-cross`

Untuk paket *cross-toolchain*. Tidak ada variabel wajib (triplet target disimpulkan otomatis), tetapi ada beberapa variabel opsional:

| Variabel | Fungsi |
|---|---|
| `cross_gcc_skip_go` | Lewati `gccgo`. |
| `cross_*_configure_args` | Argumen configure per sub-proyek; `*` dapat berupa `binutils`, `gcc_bootstrap` (gcc awal), `gcc` (gcc final), `glibc` (atau `musl`). |
| `configure_args` | Diteruskan tambahan ke **gcc awal dan final**. |
| `cross_(glibc\|musl)_(cflags\|ldflags)` | `CFLAGS` dan `LDFLAGS` khusus untuk libc. |

---

## 5. Variabel Lingkungan per Build Style

Variabel lingkungan khusus untuk sebuah `build_style` bisa ditulis di berkas yang namanya sama dengan nama build style-nya. Contoh:

```
common/environment/build-style/gnu-configure.sh
```

---

## 6. Memilih Build Style: Panduan Cepat

```
Ada skrip ./configure ala GNU?          → gnu-configure
Ada skrip configure non-GNU?            → configure
Hanya ada Makefile?                     → gnu-makefile
Ada CMakeLists.txt?                     → cmake
Ada meson.build?                        → meson
Proyek Rust (Cargo.toml)?               → cargo
Proyek Go (go.mod)?                     → go
Modul Python?                           → python3-module / python3-pep517
Tidak ada yang cocok?                   → tanpa build_style, tulis do_install() sendiri
```

---

## Intinya

- `build_style` memilih skrip siap pakai dari `common/build-style`.
- Tanpa `build_style`, minimal tulis `do_install()`.
- Fungsi di template **menimpa** fungsi dengan nama sama dari build style.
- Variabel lingkungan per build style disimpan di `common/environment/build-style/<nama>.sh`.

---

<!-- nav -->
[← Dependensi Runtime, `shlibs`, dan Paket Virtual](../03_dependensi/02-dependensi-runtime-shlibs-virtual.md) | [Daftar Isi](../DaftarISI.md) | [Build Helper →](../04_proses-build/02-build-helper.md)
