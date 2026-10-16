# 14. Beberapa Kelas Paket

[« 32-bit & Subpackages](13-32bit-dan-subpackages.md) · [Daftar Isi](README.md) · Selanjutnya: [Rename & Remove Package »](15-rename-remove-package.md)

## Development Packages

Paket development, umumnya dihasilkan sebagai subpackage, hanya boleh
berisi file yang dibutuhkan untuk development — yaitu header, static
library, symlink shared library, file pkg-config, dokumentasi API, atau
script lain yang hanya berguna saat mengembangkan software target.

Paket development sebaiknya bergantung pada paket yang dibutuhkan untuk
me-link terhadap shared library yang disediakan. Misalnya, jika `libfoo`
menyediakan shared library `libfoo.so.2` dan proses linking membutuhkan
`-lbar`, maka paket yang menyediakan shared library `libbar` harus
ditambahkan sebagai dependency — dan kemungkinan besar harus bergantung
pada paket development-nya juga.

Jika paket development menyediakan file `pkg-config`, kamu harus memeriksa
dependency apa saja yang dibutuhkan paket untuk linking dinamis atau
statis, dan menambahkan paket `development` yang sesuai sebagai dependency.

Paket development untuk bahasa C dan C++ biasanya melakukan `vmove` pada
subset file berikut dari paket utama:

- Header files: `usr/include`
- Static libraries: `usr/lib/*.a`
- Symlink shared library: `usr/lib/*.so`
- Cmake rules: `usr/lib/cmake`, `usr/share/cmake`
- Package config files: `usr/lib/pkgconfig`, `usr/share/pkgconfig`
- Autoconf macros: `usr/share/aclocal`
- GObject introspection XML files: `usr/share/gir-1.0`
- Vala bindings: `usr/share/vala`

## Data Packages

Jenis subpackage umum lainnya adalah subpackage `-data`. Jenis subpackage
ini dipakai untuk memisahkan data yang tidak bergantung arsitektur, atau
berukuran besar, dari bagian utama paket yang bergantung arsitektur.
Terserah kamu untuk memutuskan apakah subpackage `-data` masuk akal untuk
paketmu. Jenis ini umum dipakai untuk game (grafis, suara, musik), library
sebagian (CAD), atau materi peta (maps). Paket utama kemudian harus punya
`depends="${pkgname}-data-${version}_${revision}"`, kemungkinan selain
dependency non-otomatis lainnya.

## Documentation Packages

Paket yang ditujukan untuk interaksi pengguna tidak selalu membutuhkan
bagian dokumentasinya secara mutlak. Pengguna yang tidak ingin
mengembangkan dengan Qt5 misalnya, tidak butuh memasang paket
`qt5-doc` yang (besar). Seorang expert mungkin juga tidak butuh, atau
memilih memakai versi online-nya.

Secara umum, paket `-doc` berguna jika paket utama bisa dipakai baik dengan
maupun tanpa dokumentasi, dan ukuran dokumentasinya tidak terlalu kecil.
Paket dasar dan subpackage `-devel` sebaiknya dijaga tetap kecil, sehingga
saat membangun paket yang bergantung pada paket tertentu, tidak perlu
memasang dokumentasi berukuran besar tanpa alasan. Jadi, ukuran bagian
dokumentasi sebaiknya menjadi panduanmu untuk memutuskan apakah perlu
memisahkan subpackage `-doc`.

## Python Packages

Paket Python sebaiknya dibangun dengan `build_style` `python3-module` jika
memungkinkan. Ini mengeset beberapa environment variable yang dibutuhkan
untuk mendukung cross compilation. Mendukung juga pembangunan modul python
untuk beberapa versi dari satu template. `build_style` `python3-pep517`
menyediakan cara untuk membangun paket python yang menyediakan definisi
build-system sesuai [PEP 517](https://www.python.org/dev/peps/pep-0517/)
tanpa script `setup.py` tradisional. `python3-pep517` tidak menyediakan
build backend spesifik, jadi paket perlu menambahkan provider backend yang
sesuai ke `hostmakedepends`.

Paket Python yang bergantung pada `python3-setuptools` sebaiknya memetakan
dependency `setup_requires` di `setup.py` ke `hostmakedepends` di template,
dan dependency `install_requires` ke `depends`; sertakan `python3` di
`depends` jika tidak ada dependency python lain. Jika paket menyertakan
compiled extension, paket `python3-devel` harus ditambahkan ke
`makedepends`, begitu juga paket python lain yang menyediakan native
library yang di-link oleh extension tersebut (meski paket itu juga ada di
`hostmakedepends` untuk memenuhi `setuptools`).

**Catatan:** `setuptools` Python akan mencoba memakai `pip` atau
`EasyInstall` untuk mengambil dependency yang hilang saat build time. Jika
kamu melihat warning soal deprecation `EasyInstall` atau python eggs
muncul di `${wrksrc}/.eggs` setelah membangun paket, maka paket tersebut
harus ditambahkan ke `hostmakedepends`.

Variabel berikut bisa memengaruhi cara paket python dibangun dan
dikonfigurasi saat post-install:

- **`pycompile_module`** — Secara default, file dan direktori yang
  dipasang ke `usr/lib/pythonX.Y/site-packages` (kecuali `*-info` dan
  `*.so`) di-*byte-compile* saat instalasi sebagai modul python. Variabel
  ini menentukan subset mana yang harus di-byte-compile, jika default-nya
  salah. Beberapa modul python bisa ditentukan dipisah spasi, contoh:
  `pycompile_module="foo blah"`. Jika modul python memasang file (bukan
  direktori) ke `site-packages`, gunakan nama file-nya, contoh:
  `pycompile_module="fnord.py"`.
- **`pycompile_dirs`** — Menentukan direktori python yang harus di-
  byte-compile secara rekursif oleh versi python target. Berbeda dengan
  `pycompile_module`, path apa pun bisa ditentukan, contoh:
  `pycompile_dirs="usr/share/foo"`.
- **`python_version`** — Menentukan versi mayor Python yang didukung.
  Umumnya versi ini ditebak dari shebang, install path, atau build style.
  Hanya dibutuhkan untuk beberapa aplikasi multi-bahasa (mis. aplikasi
  ditulis dalam C tapi command-nya ditulis dalam Python), atau file
  Python tunggal yang berada di `/usr/bin`. Jika `python_version` diset
  `ignore`, shebang yang mengandung python tidak akan ditulis ulang.
  Gunakan ini hanya jika paket memang tidak boleh memakai versi python
  sistem.
- **`python_extras`** — Extra modul Python yang diperhitungkan saat
  verifikasi dependency modul Python. Bisa dipakai untuk memastikan set
  dependency tambahan ikut diperiksa. Contoh: `python_extras="all"`.
- **`nopyprovides`** — Jika diset, tidak membuat entri `provides` untuk
  modul Python di paket.
- **`noverifypydeps`** — Jika diset, tidak memverifikasi dependency modul
  Python.

Selain itu, tersedia juga variabel-variabel berguna untuk dipakai di
template:

| Variabel    | Nilai                             |
|-------------|-------------------------------------|
| py2_ver     | 2.X                                  |
| py2_lib     | usr/lib/python2.X                    |
| py2_sitelib | usr/lib/python2.X/site-packages      |
| py2_inc     | usr/include/python2.X                |
| py3_ver     | 3.X                                   |
| py3_lib     | usr/lib/python3.X                    |
| py3_sitelib | usr/lib/python3.X/site-packages      |
| py3_inc     | usr/include/python3.Xm                |

> **Catatan:** subpackage tambahan diperlukan untuk mendukung packaging di
> beberapa versi python sekaligus.

## Go Packages

Paket Go sebaiknya dibangun dengan `build_style` `go` jika memungkinkan.
`build_style` `go` menangani pengunduhan dependency Go dan setup cross
compilation.

Variabel template berikut memengaruhi cara paket Go dibangun:

- **`go_import_path`** — Import path paket yang disertakan di distfile,
  sesuai penggunaannya dengan `go get`. Contoh: program `hub` dari GitHub
  punya import path `github.com/github/hub`. Variabel ini **wajib**.
- **`go_package`** — Daftar import path (dipisah spasi) paket-paket yang
  harus dibangun. Default: `go_import_path`.
- **`go_build_tags`** — Daftar build tag opsional (dipisah spasi) yang
  dipassing ke Go.
- **`go_mod_mode`** — Mode download module. Bisa `off` untuk mengabaikan
  file `go.mod`, `default` untuk perilaku default Go, atau nilai apa pun
  yang diterima `go build -mod MODE`. Default `vendor` jika ada direktori
  vendor, jika tidak `default`.
- **`go_ldflags`** — Argumen yang dipassing ke tahap linking Go tool.

Environment variable berikut memengaruhi cara paket Go dibangun:

- **`XBPS_MAKEJOBS`** — Nilai yang dipassing ke flag `-p` di `go install`,
  untuk mengatur paralelisme kompiler Go.

Terkadang perlu melakukan operasi di dalam source tree Go. Ini biasanya
dibutuhkan program yang memakai `go-bindata` atau menyiapkan asset
tertentu. Jika memungkinkan, lakukan di `pre_build()`. Path ke source paket
di dalam `$GOPATH` tersedia sebagai `$GOSRCPATH`.

## Haskell Packages

Paket Haskell bisa dibangun dengan `build_style` `cabal` atau
`haskell-stack` — gunakan yang paling sesuai atau lebih didukung upstream;
terkadang hanya salah satunya yang memungkinkan. Untuk paket yang punya
bagian haskell tapi memakai `build_style` lain seperti `gnu-makefile`,
pastikan memakai `build_helper` `haskell`.

Variabel berikut memengaruhi paket yang dibangun dengan cabal:

- **`cabal_index_state`** — State index cabal hackage yang dipakai untuk
  mengambil dependency. Source paket project haskell sebaiknya dilengkapi
  file freeze yang mengeset index state; beberapa juga mengesetnya di
  file cabal project-nya. Jika tidak, ini harus diset ke timestamp ISO
  di template paket. Contoh: `2025-07-05T14:01:16Z`.
- **`configure_args`** — Argumen yang dipassing ke `cabal configure`.
  Tahap configure men-generate file `cabal.project.local`.
- **`make_build_args`** — Argumen yang dipassing ke `cabal build`.
- **`make_build_target`** — Target yang dipassing ke `cabal build`.
- **`make_check_args`** — Argumen yang dipassing ke `cabal test`.
- **`make_check_target`** — Target test yang dipassing ke cabal,
  menggantikan `"test"`.
- **`make_install_target`** — Target yang dipassing ke `cabal install`.

Dan variabel berikut memengaruhi paket yang dibangun dengan stack:

- **`stackage`** — Versi Stackage yang dipakai untuk membangun paket,
  mis. `lts-3.5`. Alternatifnya:
  - Siapkan konfigurasi `stack.yaml` untuk project dan taruh di
    `files/stack.yaml`.
  - Jika file `stack.yaml` sudah ada di source files, file itu yang
    akan dipakai.
- **`make_build_args`** — Dipassing apa adanya ke `stack build ...`,
  sehingga kamu bisa menambahkan parameter `--flag ...` di sini.

Untuk mem-patch dependency paket haskell, dependency tersebut harus diambil
secara eksplisit dari hackage dengan menambahkannya ke `distfiles`, alih-alih
membiarkan cabal atau stack mengunduhnya. Setelah diekstrak dan di-patch,
path ke versi yang sudah di-patch bisa ditambahkan ke `packages` di
`cabal.project` atau `stack.yaml`. Stack akan menemukannya otomatis jika
tidak ada file `stack.yaml` dengan cara memindai direktori. Build tool
kemudian akan memakai versi dependency yang sudah di-patch, alih-alih
mengunduhnya dari hackage.

## Font Packages

Paket font sangat mudah ditulis; selalu diset dengan variabel berikut:

- **`depends="font-util"`** — karena dibutuhkan untuk meregenerasi font
  cache saat instalasi/penghapusan paket.
- **`font_dirs`** — harus diset ke direktori tempat paket memasang
  font-nya.
