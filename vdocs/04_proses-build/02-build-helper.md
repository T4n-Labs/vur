# Build Helper

> **Ringkasan:** `build_helper` memuat potongan skrip shell yang menyiapkan **lingkungan kerja** yang cocok untuk kelompok paket tertentu, terutama saat **cross-compile**.

---

## 1. Apa Bedanya dengan Build Style?

| | `build_style` | `build_helper` |
|---|---|---|
| Peran | **Mengerjakan** build (configure, build, install) | **Menyiapkan lingkungan** (variabel, wrapper, file bantu) |
| Jumlah | Satu per paket | Boleh beberapa (dipisahkan spasi) |
| Lokasi skrip | `common/build-style` | `common/build-helper` |

```bash
build_helper="rust qemu"
```

---

## 2. Daftar Build Helper

| Helper | Fungsi |
|---|---|
| `cmake-wxWidgets-gtk3` | Mengatur variabel `WX_CONFIG` yang dipakai `FindwxWidgets.cmake`. |
| `gir` | Menentukan dependensi untuk build native dan cross terkait **GObject Introspection**. |
| `go` | Mengatur variabel lingkungan untuk build native dan cross program Go. |
| `meson` | Membuat *cross file* untuk build cross dengan meson. |
| `numpy` | Mengonfigurasi lingkungan cross-compile paket Python yang punya ekstensi terkompilasi dan menautkan library C NumPy. |
| `python3` | Mengonfigurasi lingkungan cross-build memakai library, header, dan interpreter Python di root target. |
| `qemu` | Mengatur variabel agar binary hasil cross-compile bisa dijalankan di dalam qemu. |
| `qmake` | Membuat `qt.conf` dan *qmake-wrapper* untuk cross build Qt5. |
| `qmake6` | Seperti `qmake`, tetapi untuk Qt6. |
| `rust` | Mengatur variabel lingkungan untuk cross-compile crate lewat cargo dan untuk mengompilasi crate `-sys`. |
| `haskell` | Mengatur variabel lingkungan untuk cabal. |

---

## 3. Penjelasan Detail

### `gir`

Variabel yang bisa diatur di template untuk menangani build cross yang butuh petunjuk tambahan atau bermasalah:

| Variabel | Fungsi |
|---|---|
| `GIR_EXTRA_LIBS_PATH` | Path tambahan yang dicari saat me-*link* binary target yang akan diintrospeksi. |
| `GIR_EXTRA_OPTIONS` | Opsi tambahan untuk `g-ir-scanner-qemuwrapper` yang memanggil `qemu-<target_arch>-static` saat menjalankan binary target. |

Contoh: `GIR_EXTRA_OPTIONS="-strace"` untuk melihat jejak (*trace*) proses saat binary dijalankan.

### `go`

Mengatur variabel lingkungan untuk build native dan cross program Go. Ini **otomatis** dipakai oleh paket dengan build style `go`, tetapi bisa dipakai juga oleh paket yang punya komponen Go namun memakai build style lain.

### `meson`

- Membuat *cross file* `${XBPS_WRAPPERDIR}/meson/xbps_meson.cross` yang mengonfigurasi meson untuk build cross.
- Berguna untuk paket yang membungkus pemanggilan meson (misalnya paket `python3-pep517` dengan backend meson).
- **Otomatis ditambahkan** untuk paket dengan build style `meson`.
- Juga mengatur `$MESON_PACKAGE_CACHE_DIR` ke `$XBPS_SRCDISTDIR/$pkgname-$version/`, sehingga library yang ditentukan sebagai *meson wrap* bisa ditambahkan ke `distfiles` dan otomatis dipakai meson.
- Lihat juga `common/scripts/gen-wrap-distfiles.py`, skrip yang menghasilkan entri `distfiles` untuk wrap.

### `numpy`

Mengonfigurasi lingkungan cross-compile paket Python yang punya ekstensi terkompilasi dan menautkan ke library C NumPy. Jika helper `meson` juga dikonfigurasi, *cross file* kedua `${XBPS_WRAPPERDIR}/meson/xbps_numpy.cross` akan ditulis untuk memberi tahu meson lokasi komponen NumPy.

### `python3`

Mengonfigurasi lingkungan cross-build untuk memakai library Python, file header, dan konfigurasi interpreter di root target. **Otomatis ditambahkan** untuk paket dengan build style `python3-module` atau `python3-pep517`.

### `qemu`

Mengatur variabel tambahan untuk build style `cmake` dan `meson` agar binary hasil cross-compile bisa dijalankan di dalam qemu:

- `CMAKE_CROSSCOMPILING_EMULATOR` (cmake) dan `exe_wrapper` (meson) diatur ke `qemu-<target_arch>-static`.
- `QEMU_LD_PREFIX` diatur ke `XBPS_CROSS_BASE`.
- Membuat fungsi **`vtargetrun`** untuk membungkus perintah dalam pemanggilan `qemu-<target_arch>-static` bagi arsitektur target.

```bash
# Contoh ilustrasi
build_helper="qemu"

do_build() {
	vtargetrun ./generate-tables
}
```

### `qmake` dan `qmake6`

Membuat file konfigurasi `qt.conf` yang dibutuhkan build cross, serta *qmake-wrapper* agar `qmake` memakai konfigurasi tersebut. Ini bertujuan memperbaiki cross-build untuk **build style campuran**, misalnya ketika dalam build style `gnu-configure` skrip configure memanggil `qmake`, atau `Makefile` dalam style `gnu-makefile` memanggil `qmake`. `qmake` untuk Qt5, `qmake6` untuk Qt6.

> **Catatan:** helper `qmake` secara internal memakai variabel `qmake_default_version` untuk memilih implementasi qmake default (Qt5 atau Qt6). Variabel ini bagian dari alur kerja helper dan **tidak umum diatur** di template.

### `rust`

Mengatur variabel lingkungan yang dibutuhkan untuk cross-compile crate lewat cargo dan untuk mengompilasi crate `-sys`. Juga menambahkan *wrapper* `cargo` yang mendeteksi dan meneruskan build lewat `cargo-auditable`. **Otomatis ditambahkan** untuk paket dengan build style `cargo`.

### `haskell`

Mengatur variabel lingkungan untuk cabal. **Otomatis ditambahkan** untuk paket dengan build style `haskell-stack` atau `cabal`.

---

## 4. Helper yang Otomatis Ditambahkan

| Build style | Helper otomatis |
|---|---|
| `meson` | `meson` |
| `go` | `go` |
| `cargo` | `rust` |
| `python3-module`, `python3-pep517` | `python3` |
| `haskell-stack`, `cabal` | `haskell` |

---

## Intinya

- `build_helper` menyiapkan **lingkungan**, terutama untuk cross-compile.
- Beberapa helper sudah otomatis ditambahkan oleh build style tertentu.
- Tambahkan sendiri bila paketmu memakai build style berbeda namun punya komponen bahasa tertentu (misalnya Go atau Haskell).

---

<!-- nav -->
[← Build Style](../04_proses-build/01-build-style.md) | [Daftar Isi](../DaftarISI.md) | [Fungsi di Template (Hook Fase Build) →](../04_proses-build/03-fungsi-template.md)
