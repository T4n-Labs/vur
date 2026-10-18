# Variabel Opsional: Konfigurasi Build

> **Ringkasan:** Variabel yang mengatur **cara paket dikonfigurasi, dikompilasi, dites, dan dipasang**. Sebagian besar berlaku untuk *build style* `configure`, `gnu-configure`, dan `gnu-makefile`.

---

## 1. Memilih Cara Build

### `build_style`

Menentukan **metode build** paket. Nilainya adalah nama skrip di `void-packages/common/build-style`. Daftar lengkapnya ada di [Build Style](../04_proses-build/01-build-style.md).

```bash
build_style=gnu-configure
```

### `build_helper`

Daftar file (dipisahkan spasi) di `common/build-helper` yang akan di-*source* agar variabelnya tersedia di template.

```bash
build_helper="rust"
```

Detail ada di [Build Helper](../04_proses-build/02-build-helper.md).

---

## 2. Tahap Configure

| Variabel | Fungsi | Default |
|---|---|---|
| `configure_script` | Nama skrip `configure` yang dijalankan pada fase `configure` (untuk build style `configure`/`gnu-configure`). | `./configure` |
| `configure_args` | Argumen yang diteruskan ke skrip `configure`. | `prefix` harus `/usr` |

Untuk `gnu-configure`, beberapa opsi **sudah diatur otomatis**:

```
--prefix=/usr --sysconfdir=/etc --infodir=/usr/share/info --mandir=/usr/share/man --localstatedir=/var
```

---

## 3. Tahap Build

| Variabel | Fungsi | Default |
|---|---|---|
| `make_cmd` | Executable yang dijalankan pada fase `build` (untuk `configure`, `gnu-configure`, `gnu-makefile`). | `make` |
| `make_build_args` | Argumen untuk `${make_cmd}` pada fase build. | tidak diatur |
| `make_build_target` | Target build. Jika tidak diatur, target default dipakai. | kosong |

Catatan `make_build_target`: untuk build style `python3-pep517`, variabel ini berarti **path direktori paket yang akan dibangun sebagai Python wheel**; jika tidak diatur, nilainya `.` (direktori saat ini).

---

## 4. Tahap Check (Tes)

| Variabel | Fungsi | Default |
|---|---|---|
| `make_check_args` | Argumen untuk `${make_cmd}` pada fase check. | tidak diatur |
| `make_check_target` | Target yang diteruskan ke `${make_cmd}` pada fase check. | `check` |
| `make_check_pre` | Ekspresi yang diletakkan **sebelum** `${make_cmd}`. Bisa untuk *wrapper command* atau mengatur variabel lingkungan bagi perintah check. | kosong |
| `make_check` | Mengatur **kapan** fase `check` dijalankan (lihat di bawah). | `yes` |
| `disable_parallel_check` | Tes tidak dibangun/dijalankan paralel; `XBPS_MAKEJOBS` diset ke `1`. | tidak aktif |

### Nilai `make_check`

Opsi ini **harus disertai komentar** yang menjelaskan mengapa tes gagal.

| Nilai | Artinya |
|---|---|
| `yes` | (default) jalankan jika `XBPS_CHECK_PKGS` diatur. |
| `extended` | jalankan jika `XBPS_CHECK_PKGS` bernilai `full`. |
| `ci-skip` | jalankan secara lokal jika `XBPS_CHECK_PKGS` diatur, tapi **tidak** sebagai bagian pemeriksaan pull request. |
| `no` | tidak pernah dijalankan. |

Contoh:

```bash
# Tes membutuhkan akses jaringan sehingga gagal di lingkungan build
make_check=no
```

---

## 5. Tahap Install

| Variabel | Fungsi | Default |
|---|---|---|
| `make_install_args` | Argumen untuk `${make_cmd}` pada fase `install`. | tidak diatur |
| `make_install_target` | Target instalasi untuk `${make_cmd}` pada fase install. | `install` |

Catatan `make_install_target`: untuk `python3-pep517`, variabel ini adalah **path wheel** hasil fase build yang akan dipasang. Jika tidak diatur, build style akan mencari wheel yang cocok dengan nama dan versi paket di direktori saat ini.

---

## 6. Patch

### `patch_args`

Argumen untuk perintah `patch(1)` saat menerapkan patch ke kode sumber pada `do_patch()`. Patch disimpan di `srcpkgs/<pkgname>/patches` dan **harus berformat `-p1`**.

Default: `-Np1`.

Detail ada di [Menangani Patch](../04_proses-build/04-patch.md).

---

## 7. Build Paralel

| Variabel | Fungsi |
|---|---|
| `disable_parallel_build` | Paket **tidak** dibangun paralel; `XBPS_MAKEJOBS` diset ke `1`. |
| `disable_parallel_check` | Sama, tapi untuk fase check. |

Jika sebuah paket bermasalah dengan `XBPS_MAKEJOBS` tetapi punya mekanisme paralel sendiri, atur `disable_parallel_build` (atau `disable_parallel_check`) lalu pakai **`XBPS_ORIG_MAKEJOBS`** di template. Variabel itu menyimpan nilai asli `XBPS_MAKEJOBS`.

```bash
disable_parallel_build=yes

do_build() {
	./custom-build.sh -j${XBPS_ORIG_MAKEJOBS}
}
```

> Contoh di atas hanya ilustrasi untuk menunjukkan cara memakai `XBPS_ORIG_MAKEJOBS`.

---

## 8. Variabel Konfigurasi Lainnya

| Variabel | Fungsi |
|---|---|
| `keep_libtool_archives` | Jika aktif, arsip **GNU Libtool** (`*.la`) tidak dihapus. Secara default file tersebut selalu dihapus otomatis. |
| `perl_configure_dirs` | Daftar direktori (relatif terhadap `wrksrc`, dipisahkan spasi) berisi `Makefile.PL` yang perlu diproses. **Hanya dipakai** oleh build style `perl-module`. Contoh: `perl_configure_dirs="blob/bob foo/blah"`. |
| `no_generic_pkgconfig_link` | Jika diatur, `xbps-src` **tidak** membuat symlink dari `$XBPS_CROSS_TRIPLET-pkg-config` ke `$XBPS_WRAPPERDIR/pkg-config` sebelum membangun template. |

---

## Intinya

- `configure_args` mengatur proses konfigurasi; `make_*_args` dan `make_*_target` mengatur build, check, dan install.
- `make_check` mengendalikan kapan tes berjalan, dan wajib dikomentari alasannya.
- Pakai `disable_parallel_build` jika paket tidak cocok dengan build paralel.

---

<!-- nav -->
[← Variabel Opsional: Sumber Kode](../02_dasar-template/04-variabel-opsional-sumber-kode.md) | [Daftar Isi](../DaftarISI.md) | [Variabel Opsional: Metadata dan File Paket →](../02_dasar-template/06-variabel-opsional-metadata.md)
