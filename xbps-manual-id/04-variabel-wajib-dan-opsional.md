# 4. Variabel Wajib & Opsional

[« Fungsi & Variabel Global](03-fungsi-dan-variabel-global.md) · [Daftar Isi](README.md) · Selanjutnya: [Dependencies »](05-dependencies.md)

## Variabel Wajib

Daftar variabel yang **wajib** ada di sebuah template:

- **`homepage`** — URL yang menunjuk ke homepage upstream.

- **`license`** — String yang cocok dengan [SPDX Short
  identifier](https://spdx.org/licenses), `Public Domain`, atau string
  berawalan `custom:` untuk lisensi lain. Jika ada beberapa lisensi,
  tuliskan sebagai [SPDX license
  expression](https://spdx.github.io/spdx-spec/v3.0/annexes/SPDX-license-expressions/)
  (contoh: `MIT OR Apache-2.0`, `MIT AND (LGPL-2.1-or-later OR
  BSD-3-Clause)`). Penggunaan `AND`, `OR`, `WITH`, dan `()` didukung oleh
  `xlint`. Format lama yang dipisah koma harus dikonversi jika ditemukan
  (contoh: `GPL-3.0-or-later, custom:Hugware`).

  Meta-package kosong yang tidak memuat file apa pun (dan karenanya tidak
  butuh lisensi) sebaiknya menggunakan `Public Domain`.

  Catatan: lisensi `AGPL`, `MIT`, `BSD`, `ISC`, `X11`, dan lisensi custom
  mengharuskan file lisensi disertakan dalam paket biner.

- **`maintainer`** — String berformat `name <user@domain>`. Email di
  field ini harus valid dan bisa dihubungi. Paket yang menggunakan email
  `users.noreply.github.com` tidak akan diterima.

- **`pkgname`** — String nama paket, harus cocok dengan `srcpkgs/<pkgname>`.

- **`revision`** — Angka yang harus diset ke `1` saat source package
  dibuat, atau saat diperbarui ke versi upstream baru. Nilai ini hanya
  perlu dinaikkan jika paket biner yang dihasilkan mengalami perubahan.

- **`short_desc`** — String deskripsi singkat paket. Maksimal 72 karakter.

- **`version`** — String versi paket. Tidak boleh mengandung tanda hubung
  (`-`) atau underscore (`_`), dan minimal harus ada satu digit angka.
  Penggunaan substitusi variabel shell tidak diizinkan.

`pkgname` dan `version` dilarang mengandung karakter spesial. Karena itu,
keduanya tidak perlu (dan sesuai konvensi, sebaiknya tidak) diberi tanda
kutip.

## Variabel Opsional

- **`hostmakedepends`** — Daftar dependency **host** yang dibutuhkan untuk
  membangun paket, akan dipasang ke master directory. Tidak perlu
  menyebutkan versi karena versi terbaru di `srcpkgs` akan selalu dipakai.
  Contoh: `hostmakedepends="foo blah"`.

- **`makedepends`** — Daftar dependency **target** yang dibutuhkan untuk
  membangun paket, akan dipasang ke master directory. Sama seperti di
  atas, tidak perlu menyebutkan versi. Contoh: `makedepends="foo blah"`.

- **`checkdepends`** — Daftar dependency yang dibutuhkan untuk menjalankan
  test paket, yaitu script atau make rule di fungsi `do_check()` template.
  Contoh: `checkdepends="gtest"`.

- **`depends`** — Daftar dependency yang dibutuhkan untuk **menjalankan**
  paket. Dependency ini tidak dipasang ke master directory, hanya
  diperiksa apakah ada paket biner di repository lokal yang memenuhi
  versi yang dibutuhkan. Bisa memakai operator versi: `<`, `>`, `<=`,
  `>=`, atau `foo-1.0_1` untuk versi eksak. Jika operator versi tidak
  disebutkan (hanya nama paket), otomatis dianggap `>=0`. Contoh:
  `depends="foo blah>=1.0"`. Lihat bagian [Runtime
  dependencies](05-dependencies.md#runtime-dependencies) untuk detail
  lebih lanjut.

- **`bootstrap`** — Jika diaktifkan, source package dianggap bagian dari
  proses `bootstrap` dan dibutuhkan untuk membangun paket di dalam chroot.
  Hanya sedikit paket yang boleh mengeset ini.

- **`conflicts`** — Daftar paket opsional yang berkonflik dengan paket
  ini. Bisa memakai operator versi yang sama seperti `depends`. Contoh:
  `conflicts="foo blah>=0.42.3"`.

- **`distfiles`** — URL lengkap ke file distribusi source upstream. Bisa
  berisi beberapa file, dipisah spasi. File harus berakhiran salah satu
  dari: `.tar.lzma`, `.tar.xz`, `.txz`, `.tar.bz2`, `.tbz`, `.tar.gz`,
  `.tgz`, `.gz`, `.bz2`, `.tar`, atau `.zip`. Untuk mengatur nama file
  target, tambahkan `>filename` di akhir URL. Contoh:

  ```
  distfiles="http://foo.org/foo-1.0.tar.gz http://foo.org/bar-1.0.tar.gz>bar.tar.gz"
  ```

  Untuk menghindari repetisi, tersedia variabel khusus untuk beberapa situs
  hosting populer:

  | Variabel         | Nilai                                            |
  |------------------|---------------------------------------------------|
  | CPAN_SITE        | https://cpan.perl.org/modules/by-module            |
  | DEBIAN_SITE      | http://ftp.debian.org/debian/pool                  |
  | FREEDESKTOP_SITE | https://freedesktop.org/software                   |
  | GNOME_SITE       | https://ftp.gnome.org/pub/GNOME/sources            |
  | GNU_SITE         | https://ftp.gnu.org/gnu                            |
  | KERNEL_SITE      | https://www.kernel.org/pub/linux                   |
  | MOZILLA_SITE     | https://ftp.mozilla.org/pub                        |
  | NONGNU_SITE      | https://download.savannah.nongnu.org/releases      |
  | PYPI_SITE        | https://files.pythonhosted.org/packages/source     |
  | SOURCEFORGE_SITE | https://downloads.sourceforge.net/sourceforge      |
  | UBUNTU_SITE      | http://archive.ubuntu.com/ubuntu/pool              |
  | XORG_SITE        | https://www.x.org/releases/individual              |
  | KDE_SITE         | https://download.kde.org/stable                    |
  | VIDEOLAN_SITE    | https://download.videolan.org/pub/videolan         |

- **`checksum`** — Digest SHA256 yang cocok dengan `${distfiles}`. Bisa
  berisi beberapa file, dipisah spasi, **urutannya harus sama** dengan
  `${distfiles}`. Contoh: `checksum="kkas00xjkjas"`.

  Jika sebuah distfile berubah checksum-nya setiap kali diunduh (karena
  di-generate on-the-fly oleh server, seperti snapshot tarball dari
  `https://*.googlesource.com/`), checksum dari **isi arsip** bisa
  ditentukan dengan menambahkan tanda `@` di depan. Untuk tarball, checksum
  isi arsip bisa dicari dengan perintah:
  `tar xf <tarball.ext> --to-stdout | sha256sum`.

- **`wrksrc`** — Nama direktori tempat source paket diekstrak, default
  `${pkgname}-${version}`.

- **`build_wrksrc`** — Direktori relatif terhadap `${wrksrc}` yang dipakai
  saat membangun paket.

- **`create_wrksrc`** — Biasanya, setelah ekstraksi, jika ada banyak file
  dan/atau direktori top-level (atau tidak ada direktori sama sekali),
  semua file/direktori top-level tersebut akan dibungkus dalam satu lapis
  direktori tambahan. Set variabel ini untuk memaksa perilaku tersebut.

- **`build_style`** — Menentukan metode build untuk paket. Lihat daftar
  lengkap `build_style` di [file 7](07-patch-dan-build-style.md).

- **`build_helper`** — Daftar file di `common/build-helper` (dipisah
  spasi) yang akan di-*source* dan variabelnya tersedia di template. Mis.
  `build_helper="rust"`. Lihat [file 8](08-build-helper-scripts.md).

- **`configure_script`** — Nama script `configure` yang dijalankan pada
  fase `configure`, jika `${build_style}` adalah `configure` atau
  `gnu-configure`. Default: `./configure`.

- **`configure_args`** — Argumen yang dipassing ke script `configure`
  jika `${build_style}` adalah `configure` atau `gnu-configure`. Secara
  default, `prefix` harus diset ke `/usr`. Untuk `gnu-configure`, beberapa
  opsi sudah diset secara default:
  `--prefix=/usr --sysconfdir=/etc --infodir=/usr/share/info --mandir=/usr/share/man --localstatedir=/var`.

- **`make_cmd`** — Executable yang dijalankan pada fase `build` jika
  `${build_style}` adalah `configure`, `gnu-configure`, atau
  `gnu-makefile`. Default: `make`.

- **`make_build_args`** — Argumen untuk `${make_cmd}` pada fase build.
  Kosong secara default.

- **`make_check_args`** — Argumen untuk `${make_cmd}` pada fase check.
  Kosong secara default.

- **`make_install_args`** — Argumen untuk `${make_cmd}` pada fase install.

- **`make_build_target`** — Target build. Jika `${build_style}` adalah
  `configure`/`gnu-configure`/`gnu-makefile`, ini adalah target yang
  dipassing ke `${make_cmd}` pada fase build; jika kosong, target default
  yang dipakai. Jika `${build_style}` adalah `python3-pep517`, ini adalah
  path direktori paket yang akan dibangun sebagai Python wheel; jika
  kosong, default ke `.` (direktori saat ini).

- **`make_check_target`** — Target untuk `${make_cmd}` pada fase check.
  Default: `check`.

- **`make_install_target`** — Target instalasi. Untuk `configure`/
  `gnu-configure`/`gnu-makefile`, ini target yang dipassing ke
  `${make_command}` pada fase install; jika kosong, default `install`.
  Jika `${build_style}` adalah `python3-pep517`, ini adalah path wheel
  Python hasil build yang akan dipasang; jika kosong, `python3-pep517`
  akan mencari wheel yang cocok dengan nama & versi paket.

- **`make_check_pre`** — Ekspresi yang ditaruh sebelum `${make_cmd}`.
  Bisa dipakai untuk wrapper command atau mengeset environment variable
  untuk perintah check. Kosong secara default.

- **`patch_args`** — Argumen untuk perintah `patch(1)` saat menerapkan
  patch ke source paket selama `do_patch()`. Patch disimpan di
  `srcpkgs/<pkgname>/patches` dan harus berformat `-p1`. Default: `-Np1`.

- **`disable_parallel_build`** — Jika diset, paket tidak dibangun secara
  paralel dan `XBPS_MAKEJOBS` diset ke 1. Jika sebuah paket tidak cocok
  dengan `XBPS_MAKEJOBS` tapi tetap punya mekanisme build paralel sendiri,
  set variabel ini dan gunakan `XBPS_ORIG_MAKEJOBS` (menyimpan nilai asli
  `XBPS_MAKEJOBS`) di template.

- **`disable_parallel_check`** — Sama seperti di atas, tapi untuk fase
  test/check.

- **`make_check`** — Mengatur kondisi kapan fase `check` dijalankan.
  Opsi ini harus disertai komentar yang menjelaskan alasan test gagal.
  Nilai yang valid:
  - `yes` (default) — jalan jika `XBPS_CHECK_PKGS` diset.
  - `extended` — jalan jika `XBPS_CHECK_PKGS` bernilai `full`.
  - `ci-skip` — jalan lokal jika `XBPS_CHECK_PKGS` diset, tapi tidak
    dijalankan sebagai bagian dari pemeriksaan pull request.
  - `no` — tidak pernah dijalankan.

- **`keep_libtool_archives`** — Jika diaktifkan, arsip `GNU Libtool` tidak
  akan dihapus. Secara default, file-file ini selalu dihapus otomatis.

- **`skip_extraction`** — Daftar nama file yang tidak diekstrak pada fase
  `extract`. Harus cocok dengan basename URL yang ada di `${distfiles}`.
  Contoh: `skip_extraction="foo-${version}.tar.gz"`.

- **`nodebug`** — Jika diaktifkan, paket `-dbg` tidak akan dihasilkan
  meski `XBPS_DEBUG_PKGS` diset.

- **`conf_files`** — Daftar file konfigurasi yang dimiliki paket biner;
  memakai path lengkap, wildcard akan diekspansi, beberapa entri dipisah
  spasi. Contoh: `conf_files="/etc/foo.conf /etc/foo2.conf /etc/foo/*.conf"`.

- **`mutable_files`** — Daftar file yang dimiliki paket biner, dengan
  asumsi file tersebut akan berubah. Mirip `conf_files` tapi tanpa asumsi
  akan diedit manusia.

- **`make_dirs`** — Daftar entri yang mendefinisikan direktori dan izin
  yang dibuat saat instalasi. Tiap entri dipisah spasi, dan tiap entri itu
  sendiri berisi spasi. Contoh: `make_dirs="/dir 0750 user group"`. User,
  group, dan mode wajib ada di tiap baris, meski nilainya `755 root root`.
  Sesuai konvensi, satu baris hanya berisi satu entri
  `dir perms user group`.

- **`repository`** — Menentukan repository tempat paket ditempatkan.
  Lihat [file 6](06-repositories-dan-update-check.md) untuk daftar
  repository yang valid.

- **`nostrip`** — Jika diset, binary ELF dengan debug symbol tidak akan
  di-*strip*. Secara default, semua binary di-strip.

- **`nostrip_files`** — Daftar binary ELF (dipisah spasi) yang tidak akan
  di-strip dari debug symbol. Bisa ditulis dengan path lengkap atau
  filename saja.

- **`noshlibprovides`** — Jika diset, binary ELF tidak akan diperiksa
  untuk mengumpulkan SONAME yang disediakan shared library.

- **`noverifyrdeps`** — Jika diset, binary ELF dan shared library tidak
  akan diperiksa untuk reverse dependency-nya. Semua dependency harus
  ditentukan manual di `depends` jika opsi ini diaktifkan.

- **`skiprdeps`** — Daftar nama file (path absolut di `$DESTDIR`, dipisah
  spasi) yang tidak akan dipindai untuk runtime dependency. Berguna untuk
  file yang tidak dimaksudkan untuk dijalankan/dimuat di host, tapi
  dikirim ke perangkat target atau emulator.

- **`ignore_elf_files`** — Daftar file machine code (path absolut, dipisah
  spasi) di direktori `/usr/share` yang memang diharapkan dan diizinkan.

- **`ignore_elf_dirs`** — Daftar direktori (path absolut, dipisah spasi)
  di `/usr/share` yang diizinkan berisi file machine code.

- **`nocross`** — Jika diset, cross compilation tidak diizinkan dan akan
  langsung keluar (exit). Harus diisi string yang menjelaskan alasan
  kegagalannya, atau link ke buildlog (dari builder resmi — CI buildlog
  bisa hilang) yang menunjukkan kegagalan tersebut.

- **`restricted`** — Jika diset, `xbps-src` akan menolak membangun paket
  kecuali `etc/conf` memiliki `XBPS_ALLOW_RESTRICTED=yes`. Builder utama
  Void Linux tidak mengaktifkan setting ini, jadi repository utama tidak
  akan berisi paket restricted. Berguna untuk paket yang lisensinya
  melarang redistribusi.

- **`subpackages`** — Daftar subpackage (dipisah spasi, cocok dengan
  fungsi `foo_package()`) untuk mengganti urutan tebakan otomatis. Hanya
  dipakai jika urutan subpackage tertentu dibutuhkan.

- **`metapackage`** — Jika diset `yes`, paket harus berupa meta-package
  kosong, yaitu paket yang hanya bergantung pada paket lain.

- **`broken`** — Jika diset, build paket tidak diizinkan karena statusnya
  sedang rusak. Harus diisi string alasan, atau link ke buildlog yang
  menunjukkan kegagalannya.

- **`shlib_provides`** — Daftar SONAME tambahan (dipisah spasi) yang
  disediakan paket. Ini menambahkan ke file yang di-generate, bukan
  menggantinya.

- **`shlib_requires`** — Daftar SONAME tambahan (dipisah spasi) yang
  dibutuhkan paket. Sama seperti di atas, menambahkan bukan mengganti.

- **`nopie`** — Cukup diisi apa saja untuk mengaktifkan; menonaktifkan
  fitur hardening (PIE, relro, dll.) saat build. Tidak dibutuhkan untuk
  sebagian besar paket.

- **`nopie_files`** — Daftar binary ELF (path lengkap, dipisah spasi)
  yang tidak akan diperiksa untuk PIE.

- **`reverts`** — XBPS mendukung fitur unik yang memungkinkan downgrade
  otomatis dari paket yang rusak. Di field `reverts`, tentukan daftar
  `pkgver` yang rusak dan harus di-*revert* oleh paket hasil build ini.
  Field ini **harus** didefinisikan sebelum field `version` dan `revision`
  agar berfungsi sebagaimana mestinya. Versi di `reverts` harus lebih
  besar dari versi di `version`. Contoh:

  ```
  reverts="2.0_1 2.0_2"
  version=1.9
  revision=2
  ```

- **`alternatives`** — Daftar alternatif (dipisah spasi) yang didukung
  paket. Tiap entri terdiri dari tiga komponen dipisah titik dua: group,
  symlink, dan target. Contoh:
  `alternatives="vi:/usr/bin/vi:/usr/bin/nvi ex:/usr/bin/ex:/usr/bin/nvi-ex"`.

- **`font_dirs`** — Daftar direktori (path absolut, dipisah spasi) tempat
  paket font memasang font-nya. Dipakai trigger `x11-fonts` untuk
  membangun ulang font cache saat instalasi/penghapusan paket. Contoh:
  `font_dirs="/usr/share/fonts/TTF /usr/share/fonts/X11/misc"`.

- **`dkms_modules`** — Daftar modul DKMS (Dynamic Kernel Module Support)
  yang akan dipasang/dihapus oleh trigger `dkms` saat instalasi/penghapusan
  paket. Formatnya pasangan string dipisah spasi: nama modul (biasanya
  `pkgname`) dan versi modul (biasanya `version`). Contoh:
  `dkms_modules="$pkgname $version zfs 4.14"`.

- **`register_shell`** — Daftar shell (path absolut, dipisah spasi) yang
  didaftarkan ke database shell sistem. Dipakai trigger `register-shell`.
  Contoh: `register_shell="/bin/tcsh /bin/csh"`.

- **`tags`** — Daftar tag/kategori (dipisah spasi) yang didaftarkan ke
  metadata paket dan bisa dicari lewat `xbps-query`. Contoh untuk
  qutebrowser: `tags="browser chromium-based qt5 python3"`.

- **`perl_configure_dirs`** — Daftar direktori (relatif terhadap
  `wrksrc`, dipisah spasi) yang berisi file `Makefile.PL` yang perlu
  diproses. Dipakai di `build_style` `perl-module` dan tidak berguna di
  luar itu. Contoh: `perl_configure_dirs="blob/bob foo/blah"`.

- **`preserve`** — Jika diset, file milik paket di sistem tidak akan
  dihapus saat paket diperbarui, dipasang ulang, atau dihapus. Berguna
  terutama untuk paket kernel agar file kernel tidak terhapus (yang bisa
  merusak proses boot dan module loading). Di luar kasus ini, sebaiknya
  tidak dipakai.

- **`fetch_cmd`** — Executable yang dipakai untuk mengunduh URL di
  `distfiles` selama fase `do_fetch`.

- **`changelog`** — URL yang menunjuk ke changelog upstream. File teks
  mentah (raw text) lebih disukai.

- **`archs`** — Daftar arsitektur (dipisah spasi) tempat paket bisa
  dibangun; daftar arsitektur yang tersedia ada di
  `common/cross-profiles`. Umumnya, `archs` hanya diset jika software
  upstream memang secara eksplisit menargetkan arsitektur tertentu, atau
  ada alasan kuat mengapa software tidak boleh tersedia di sebagian
  arsitektur yang didukung. Menambahkan `~` di depan pola berarti melarang
  build di arsitektur tersebut. Pola pertama yang cocok akan dipakai untuk
  mengizinkan/melarang build. Jika tidak ada pola yang cocok, paket
  dibangun jika pola terakhir mengandung `~`. Contoh:

  ```
  # Build paket hanya untuk arsitektur musl
  archs="*-musl"
  # Build paket untuk x86_64-musl dan semua arsitektur non-musl
  archs="x86_64-musl ~*-musl"
  # Nilai default (semua arsitektur)
  archs="*"
  ```

  Nilai khusus `noarch` dulu tersedia, tapi sudah dihapus.

- **`nocheckperms`** — Jika diset, `xbps-src` tidak akan gagal karena
  error izin file yang umum (world writable files, dll.).

- **`nofixperms`** — Jika diset, `xbps-src` tidak akan memperbaiki error
  izin file yang umum (man page yang executable, dll.).

- **`no_generic_pkgconfig_link`** — Jika diset, `xbps-src` tidak akan
  membuat symlink dari `$XBPS_CROSS_TRIPLET-pkg-config` ke
  `$XBPS_WRAPPERDIR/pkg-config` sebelum membangun template.
