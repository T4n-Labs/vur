# 3. Fungsi & Variabel Global

[« Konvensi Penamaan](02-konvensi-penamaan.md) · [Daftar Isi](README.md) · Selanjutnya: [Variabel Wajib & Opsional »](04-variabel-wajib-dan-opsional.md)

## Fungsi Global

Fungsi-fungsi berikut didefinisikan oleh `xbps-src` dan dapat dipakai di
template mana pun:

- **`vinstall()`** — `vinstall <file> <mode> <targetdir> [<name>]`
  Memasang `file` dengan `mode` tertentu ke `targetdir` di dalam
  `$DESTDIR` paket. Argumen ke-4 (opsional) bisa dipakai untuk mengganti
  nama file.

- **`vcopy()`** — `vcopy <pattern> <targetdir>`
  Menyalin secara rekursif semua file sesuai `pattern` ke `targetdir` di
  dalam `$DESTDIR` paket.

- **`vmove()`** — `vmove <pattern>`
  Memindahkan `pattern` ke direktori tertentu di dalam `$DESTDIR` paket.

- **`vmkdir()`** — `vmkdir <directory> [<mode>]`
  Membuat direktori di dalam `$DESTDIR` paket. Argumen ke-2 (opsional)
  mengatur mode/izin direktori.

- **`vbin()`** — `vbin <file> [<name>]`
  Memasang `file` ke `usr/bin` di dalam `$DESTDIR` paket dengan izin
  `0755`. Argumen ke-2 (opsional) bisa dipakai untuk mengganti nama file.

- **`vman()`** — `vman <file> [<name>]`
  Memasang `file` sebagai man page. `vman()` mem-parsing nama file dan
  menentukan section serta lokalisasinya. Juga otomatis mengonversi man
  page yang di-*gzip* (`.gz`) atau *bzip* (`.bz2`) menjadi plain text.
  Contoh pemetaan:
  - `foo.1` → `${DESTDIR}/usr/share/man/man1/foo.1`
  - `foo.fr.1` → `${DESTDIR}/usr/share/man/fr/man1/foo.1`
  - `foo.1p` → `${DESTDIR}/usr/share/man/man1/foo.1p`
  - `foo.1.gz` → `${DESTDIR}/usr/share/man/man1/foo.1`
  - `foo.1.bz2` → `${DESTDIR}/usr/share/man/man1/foo.1`

- **`vdoc()`** — `vdoc <file> [<name>]`
  Memasang `file` ke `usr/share/doc/<pkgname>` di dalam `$DESTDIR` paket.
  Argumen ke-2 (opsional) bisa dipakai untuk mengganti nama file.

- **`vconf()`** — `vconf <file> [<name>]`
  Memasang `file` ke `etc` di dalam `$DESTDIR` paket. Argumen ke-2
  (opsional) bisa dipakai untuk mengganti nama file.

- **`vsconf()`** — `vsconf <file> [<name>]`
  Memasang `file` ke `usr/share/examples/<pkgname>` di dalam `$DESTDIR`
  paket. Argumen ke-2 (opsional) bisa dipakai untuk mengganti nama file.

- **`vlicense()`** — `vlicense <file> [<name>]`
  Memasang `file` ke `usr/share/licenses/<pkgname>` di dalam `$DESTDIR`
  paket. Argumen ke-2 (opsional) bisa dipakai untuk mengganti nama file.
  Lihat variabel `license` di file [04](04-variabel-wajib-dan-opsional.md)
  untuk kapan fungsi ini perlu dipakai.

- **`vsv()`** — `vsv <service> [<facility>]`
  Memasang `service` dari `${FILESDIR}` ke `/etc/sv`. Service harus berupa
  direktori yang setidaknya berisi script `run`. Symlink `supervise` akan
  otomatis dibuat oleh `vsv`, dan script `run` otomatis dijadikan
  executable oleh fungsi ini. Sub-service `log` akan otomatis dibuat jika
  belum ada di `${FILESDIR}/$service`, berisi
  `exec vlogger -t $service -p $facility`. Jika argumen ke-2 tidak
  disebutkan, facility `daemon` yang dipakai.

- **`vsed()`** — `vsed -i <file> -e <regex>`
  Wrapper di sekitar `sed` yang memeriksa checksum SHA256 sebuah file
  sebelum dan sesudah menjalankan perintah `sed`, untuk mendeteksi kasus di
  mana pemanggilan `sed` sebenarnya tidak mengubah apa pun. Bisa menerima
  banyak file dan regex sekaligus dengan memanggil `-i file` dan `-e regex`
  berulang kali (minimal satu file dan satu regex). `vsed` akan memanggil
  `sed` untuk setiap regex terhadap setiap file, sesuai urutan yang
  diberikan.

- **`vcompletion()`** — `<file> <shell> [<command>]`
  Memasang shell completion dari `file` untuk `command`, di lokasi dan
  nama file yang sesuai untuk `shell` tersebut. Jika `command` tidak
  disebutkan, defaultnya adalah `pkgname`. Argumen `shell` bisa berupa
  `bash`, `fish`, atau `zsh`.

- **`vextract()`** — `[-C <target directory>] [--no-strip-components|--strip-components=<n>] <file>`
  Mengekstrak `file` ke `target directory` dengan `n` komponen direktori
  dihilangkan. Jika `target directory` tidak disebutkan, default ke
  working directory. Jika `--strip-components`/`--no-strip-components`
  tidak disebutkan, default ke `--strip-components=1`.

- **`vsrcextract()`** — `[-C <target directory>] [--no-strip-components|--strip-components=<n>] <file>`
  Mengekstrak `$XBPS_SRCDISTDIR/$pkgname-$version/<file>` ke
  `target directory` dengan `n` komponen dihilangkan. Berguna jika dipakai
  bersama `skip_extraction` dan untuk distfile submodule.

- **`vsrccopy()`** — `<file>... <target>`
  Menyalin `file` dari `$XBPS_SRCDISTDIR/$pkgname-$version/` ke direktori
  `target` (dibuat otomatis jika belum ada). Berguna jika dipakai bersama
  `skip_extraction`.

> Wildcard shell harus di-*quote* dengan benar. Contoh: `vmove "usr/lib/*.a"`.

## Variabel Global

Variabel-variabel berikut didefinisikan oleh `xbps-src` dan dapat dipakai di
template mana pun:

- **`makejobs`** — Diisi `-jX` jika `XBPS_MAKEJOBS` didefinisikan, untuk
  paralelisasi dengan `GNU make`.
- **`sourcepkg`** — Diisi nama paket utama; bisa dipakai untuk mencocokkan
  paket utama, bukan nama paket biner tambahan.
- **`CHROOT_READY`** — Diset jika chroot target (masterdir) sudah siap untuk
  build via chroot.
- **`CROSS_BUILD`** — Diset jika `xbps-src` sedang melakukan cross compile.
- **`XBPS_CHECK_PKGS`** — Diset jika `xbps-src` akan menjalankan test untuk
  sebuah paket. Testsuite yang lama sebaiknya hanya dijalankan di
  `do_check()` jika nilainya `full`.
- **`DESTDIR`** — Path lengkap ke fake destdir yang dipakai source paket,
  diset ke `<masterdir>/destdir/${sourcepkg}-${version}`.
- **`FILESDIR`** — Path lengkap ke direktori `files` milik paket, mis.
  `srcpkgs/foo/files`. Direktori ini bisa dipakai untuk menyimpan file
  tambahan yang akan dipasang sebagai bagian dari source paket.
- **`PKGDESTDIR`** — Path lengkap ke fake destdir yang dipakai fungsi
  `pkg_install()` pada subpackage, diset ke
  `<masterdir>/destdir/${pkgname}-${version}`.
- **`XBPS_BUILDDIR`** — Direktori untuk menyimpan source code paket yang
  sedang diproses, diset ke `<masterdir>/builddir`. `wrksrc` paket selalu
  disimpan di dalam direktori ini, mis. `${XBPS_BUILDDIR}/${wrksrc}`.
- **`XBPS_MACHINE`** — Arsitektur mesin sesuai output `xbps-uhelper arch`.
- **`XBPS_ENDIAN`** — Endianness mesin (`le` atau `be`).
- **`XBPS_LIBC`** — C library mesin (`glibc` atau `musl`).
- **`XBPS_WORDSIZE`** — Ukuran word mesin dalam bit (32 atau 64).
- **`XBPS_NO_ATOMIC8`** — Mesin tidak punya native 64-bit atomics (butuh
  emulasi libatomic).
- **`XBPS_SRCDISTDIR`** — Path lengkap tempat distfile source disimpan,
  mis. `$XBPS_HOSTDIR/sources`.
- **`XBPS_SRCPKGDIR`** — Path lengkap ke direktori `srcpkgs`.
- **`XBPS_TARGET_MACHINE`** — Arsitektur mesin target saat cross compile.
- **`XBPS_TARGET_ENDIAN`** — Endianness mesin target.
- **`XBPS_TARGET_LIBC`** — C library mesin target.
- **`XBPS_TARGET_WORDSIZE`** — Ukuran word mesin target dalam bit.
- **`XBPS_TARGET_NO_ATOMIC8`** — Mesin target tidak punya native 64-bit
  atomics.
- **`XBPS_FETCH_CMD`** — Utilitas untuk mengunduh file dari server
  ftp/http/https.
- **`XBPS_WRAPPERDIR`** — Path lengkap tempat wrapper utilitas `xbps-src`
  disimpan.
- **`XBPS_CROSS_BASE`** — Path lengkap tempat dependency cross-compile
  dipasang, bervariasi sesuai target triplet arsitektur. Mis. `aarch64` →
  `/usr/aarch64-linux-gnu`.
- **`XBPS_RUST_TARGET`** — Target triplet arsitektur yang dipakai `rustc`
  dan `cargo`.
- **`XBPS_BUILD_ENVIRONMENT`** — Mengaktifkan operasi khusus continuous
  integration. Diset ke `void-packages-ci` jika berjalan di CI.
