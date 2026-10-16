# 8. Build Helper Scripts

[« Patch & Build Style](07-patch-dan-build-style.md) · [Daftar Isi](README.md) · Selanjutnya: [Functions (Lifecycle) »](09-functions-lifecycle.md)

Variabel `build_helper` menentukan potongan shell script yang akan
di-*source*, untuk membuat environment yang sesuai bekerja dengan kumpulan
paket tertentu.

Berikut daftar `build_helper` yang tersedia saat ini:

- **`cmake-wxWidgets-gtk3`** — Mengeset variabel `WX_CONFIG` yang dipakai
  oleh `FindwxWidgets.cmake`.

- **`gir`** — Menentukan dependency untuk build native dan cross guna
  menangani GObject Introspection. Variabel berikut bisa diset di template
  untuk menangani cross build yang butuh hint tambahan atau bermasalah:
  `GIR_EXTRA_LIBS_PATH` mendefinisikan path tambahan yang dicari saat
  me-link binary target yang akan di-introspect. `GIR_EXTRA_OPTIONS`
  mendefinisikan opsi tambahan untuk `g-ir-scanner-qemuwrapper` yang
  memanggil `qemu-<target_arch>-static` saat menjalankan binary target.
  Contoh: `GIR_EXTRA_OPTIONS="-strace"` untuk melihat trace saat binary
  dijalankan.

- **`meson`** — Membuat cross file
  `${XBPS_WRAPPERDIR}/meson/xbps_meson.cross`, yang mengonfigurasi meson
  untuk cross build. Sangat berguna untuk paket yang membungkus pemanggilan
  meson (mis. paket `python3-pep517` yang memakai backend meson), dan
  ditambahkan otomatis untuk paket yang memakai `build_style` `meson`.
  Juga mengeset `$MESON_PACKAGE_CACHE_DIR` ke
  `$XBPS_SRCDISTDIR/$pkgname-$version/`, sehingga library yang ditentukan
  sebagai meson wrap bisa ditambahkan ke `distfiles` dan otomatis dipakai
  meson. Lihat juga `common/scripts/gen-wrap-distfiles.py` untuk script
  yang men-generate entri distfiles untuk wrap.

- **`numpy`** — Mengonfigurasi environment untuk cross-compile paket
  python yang menyediakan extension terkompilasi yang di-link ke library C
  NumPy. Jika `build_helper` `meson` juga dikonfigurasi, cross file kedua
  `${XBPS_WRAPPERDIR}/meson/xbps_numpy.cross` akan ditulis untuk memberi
  tahu meson lokasi komponen NumPy umum.

- **`python3`** — Mengonfigurasi environment cross-build untuk memakai
  library Python, header file, dan konfigurasi interpreter di target root.
  Helper ini ditambahkan otomatis untuk paket yang memakai `build_style`
  `python3-module` atau `python3-pep517`.

- **`qemu`** — Mengeset variabel tambahan untuk `build_style` `cmake` dan
  `meson` agar bisa menjalankan binary hasil cross-compile di dalam qemu.
  Mengeset `CMAKE_CROSSCOMPILING_EMULATOR` untuk cmake dan `exe_wrapper`
  untuk meson ke `qemu-<target_arch>-static`, serta `QEMU_LD_PREFIX` ke
  `XBPS_CROSS_BASE`. Juga membuat fungsi `vtargetrun` untuk membungkus
  perintah dengan pemanggilan `qemu-<target_arch>-static` sesuai
  arsitektur target.

- **`qmake`** — Membuat file konfigurasi `qt.conf` (lih. `build_style`
  `qmake`) yang dibutuhkan untuk cross build, beserta qmake-wrapper agar
  `qmake` memakai konfigurasi ini. Bertujuan memperbaiki cross-build saat
  build style-nya campuran, mis. saat script configure di style
  `gnu-configure` memanggil `qmake`, atau `Makefile` di style
  `gnu-makefile` memanggilnya. Untuk paket Qt5.

- **`qmake6`** — Sama seperti `qmake`, tapi untuk Qt6.

  > **Catatan:** build helper qmake secara internal memakai variabel
  > `qmake_default_version` untuk memilih implementasi qmake default (Qt5
  > atau Qt6). Variabel ini bagian dari alur kerja helper dan jarang diset
  > langsung di template.

- **`rust`** — Menentukan environment variable yang dibutuhkan untuk
  cross-compile crate via cargo, dan untuk mengompilasi crate `-sys`.
  Juga menambahkan wrapper `cargo` yang mendeteksi dan mengarahkan build
  melalui `cargo-auditable`. Helper ini ditambahkan otomatis untuk paket
  yang memakai `build_style` `cargo`.

- **`haskell`** — Menentukan environment variable untuk cabal. Helper ini
  ditambahkan otomatis untuk paket yang memakai `build_style`
  `haskell-stack` atau `cabal`.
