# Kelas Paket: Go

> **Ringkasan:** Paket Go sebaiknya dibangun dengan build style `go`. Build style ini mengurus pengunduhan dependensi Go dan pengaturan cross-compile.

---

## 1. Variabel Template

| Variabel | Fungsi |
|---|---|
| `go_import_path` | **Wajib.** *Import path* paket yang ada di distfile, seperti yang dipakai dengan `go get`. Contoh: program `hub` milik GitHub memiliki import path `github.com/github/hub`. |
| `go_package` | Daftar import path paket yang harus dibangun, dipisahkan spasi. Default: `go_import_path`. |
| `go_build_tags` | Daftar *build tag* opsional (dipisahkan spasi) yang diteruskan ke Go. |
| `go_mod_mode` | Mode unduh modul yang dipakai. Bisa `off` (abaikan file go.mod), `default` (perilaku default Go), atau nilai apa pun yang diterima `go build -mod MODE`. Default: `vendor` jika ada direktori vendor, selain itu `default`. |
| `go_ldflags` | Argumen untuk langkah *linking* alat go. |

---

## 2. Variabel Lingkungan

| Variabel | Fungsi |
|---|---|
| `XBPS_MAKEJOBS` | Nilai yang diteruskan ke flag `-p` pada `go install`, untuk mengontrol paralelisme kompilator Go. |

---

## 3. Operasi di dalam Pohon Sumber Go

Kadang perlu melakukan operasi dari dalam pohon sumber Go. Biasanya ini dibutuhkan oleh program yang memakai **go-bindata** atau menyiapkan aset tertentu.

- Jika memungkinkan, lakukan di **`pre_build()`**.
- Path sumber paket di dalam `$GOPATH` tersedia sebagai **`$GOSRCPATH`**.

```bash
pre_build() {
	cd ${GOSRCPATH}
	# siapkan aset di sini
}
```

---

## 4. Contoh Template Go

```bash
# Template file for 'foo'
pkgname=foo
version=1.0
revision=1
build_style=go
go_import_path="github.com/example/foo"
short_desc="Example Go program"
maintainer="Nama Kamu <kamu@contoh.com>"
distributor="Nama Kamu <kamu@contoh.com>"
license="MIT"
homepage="https://github.com/example/foo"
distfiles="https://github.com/example/foo/archive/v${version}.tar.gz"
checksum="..."

post_install() {
	vlicense LICENSE
}
```

> Contoh di atas bersifat ilustrasi.

---

## Intinya

- Gunakan `build_style=go` dan **wajib** set `go_import_path`.
- Opsi tambahan: `go_package`, `go_build_tags`, `go_mod_mode`, `go_ldflags`.
- Operasi di dalam pohon sumber Go dilakukan di `pre_build()` memakai `$GOSRCPATH`.

---

<!-- nav -->
[← Kelas Paket: Python](../07_subpackage-dan-kelas-paket/04-paket-python.md) | [Daftar Isi](../DaftarISI.md) | [Kelas Paket: Haskell →](../07_subpackage-dan-kelas-paket/06-paket-haskell.md)
