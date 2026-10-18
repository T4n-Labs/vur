# Kelas Paket: Python

> **Ringkasan:** Aturan khusus untuk memaketkan modul Python: pilihan *build style*, pemetaan dependensi, dan variabel pengatur *byte-compile*.

---

## 1. Pilih Build Style yang Tepat

| Build style | Kapan dipakai |
|---|---|
| `python3-module` | **Pilihan utama** bila memungkinkan. Mengatur variabel lingkungan yang dibutuhkan agar bisa di-cross-compile. Mendukung build untuk beberapa versi Python dari satu template. |
| `python3-pep517` | Untuk paket yang punya definisi build-system sesuai [PEP 517](https://www.python.org/dev/peps/pep-0517/) **tanpa** skrip `setup.py` tradisional. Build style ini **tidak menyediakan backend build tertentu**, jadi paket harus menambahkan penyedia backend yang sesuai ke `hostmakedepends`. |

---

## 2. Pemetaan Dependensi

Untuk paket Python yang bergantung pada `python3-setuptools`, secara umum:

| Di `setup.py` | Di template |
|---|---|
| `setup_requires` | `hostmakedepends` |
| `install_requires` | `depends` |

Tambahan:

- Sertakan `python3` di `depends` **jika tidak ada dependensi Python lain**.
- Jika paket punya **ekstensi terkompilasi**, tambahkan paket `python3-devel` ke `makedepends`. Begitu juga paket Python lain yang menyediakan library native yang di-*link* oleh ekstensi (walaupun paket itu juga sudah ada di `hostmakedepends` untuk memenuhi `setuptools`).

> **NB:** `setuptools` Python akan mencoba memakai `pip` atau `EasyInstall` untuk mengunduh dependensi yang hilang saat build. Jika kamu melihat peringatan deprecation `EasyInstall` atau ada *python egg* di `${wrksrc}/.eggs` setelah build, maka paket-paket tersebut harus ditambahkan ke `hostmakedepends`.

---

## 3. Variabel yang Memengaruhi Build dan Post-install

| Variabel | Fungsi |
|---|---|
| `pycompile_module` | Secara default, file dan direktori yang dipasang ke `usr/lib/pythonX.Y/site-packages` (kecuali `*-info` dan `*.so`) di-*byte-compile* saat pemasangan. Variabel ini berisi **subset** yang perlu di-*byte-compile* bila default salah. Beberapa modul dipisahkan spasi. Jika modul memasang **file** (bukan direktori) ke `site-packages`, pakai nama file. Contoh: `pycompile_module="foo blah"` atau `pycompile_module="fnord.py"`. |
| `pycompile_dirs` | Direktori Python yang di-*byte-compile* **secara rekursif** oleh versi Python target. Berbeda dari `pycompile_module` karena **path apa pun** bisa ditentukan. Contoh: `pycompile_dirs="usr/share/foo"`. |
| `python_version` | Versi mayor Python yang didukung. Pada kebanyakan kasus versi disimpulkan dari *shebang*, path instalasi, atau build style. Hanya perlu untuk aplikasi multi-bahasa tertentu (misalnya aplikasi C dengan perintah ditulis Python) atau file Python tunggal di `/usr/bin`. Jika `ignore`, shebang berisi python **tidak ditulis ulang**; gunakan hanya jika paket tidak boleh memakai Python sistem. |
| `python_extras` | *Extras* modul Python yang dipertimbangkan saat memverifikasi dependensi modul. Contoh: `python_extras="all"`. |
| `nopyprovides` | Jika diatur, **tidak** membuat entri `provides` untuk modul Python dalam paket. |
| `noverifypydeps` | Jika diatur, **tidak** memverifikasi dependensi modul Python. |

---

## 4. Variabel Bantu untuk Template

| Variabel | Nilai |
|---|---|
| `py2_ver` | `2.X` |
| `py2_lib` | `usr/lib/python2.X` |
| `py2_sitelib` | `usr/lib/python2.X/site-packages` |
| `py2_inc` | `usr/include/python2.X` |
| `py3_ver` | `3.X` |
| `py3_lib` | `usr/lib/python3.X` |
| `py3_sitelib` | `usr/lib/python3.X/site-packages` |
| `py3_inc` | `usr/include/python3.Xm` |

> **NOTE:** subpackage tambahan diharapkan dibuat untuk memaketkan beberapa versi Python.

---

## 5. Contoh Template Modul Python Sederhana

```bash
# Template file for 'python3-foo'
pkgname=python3-foo
version=1.0
revision=1
build_style=python3-module
hostmakedepends="python3-setuptools"
depends="python3-bar"
short_desc="Foo module for Python 3"
maintainer="Nama Kamu <kamu@contoh.com>"
distributor="Nama Kamu <kamu@contoh.com>"
license="MIT"
homepage="https://example.org/foo"
distfiles="${PYPI_SITE}/f/foo/foo-${version}.tar.gz"
checksum="..."

post_install() {
	vlicense LICENSE
}
```

> Ini contoh ilustrasi. Penamaan paket modul bahasa mengikuti aturan `<bahasa>-<n>` (lihat [Aturan Penamaan](../01_pengenalan/03-penamaan-paket.md)).

---

## Intinya

- Utamakan `python3-module`; pakai `python3-pep517` untuk paket tanpa `setup.py`.
- `setup_requires` → `hostmakedepends`; `install_requires` → `depends`.
- Ekstensi terkompilasi butuh `python3-devel` di `makedepends`.
- `pycompile_module` dan `pycompile_dirs` mengatur byte-compile saat pemasangan.

---

<!-- nav -->
[← Kelas Paket: Development, Data, dan Dokumentasi](../07_subpackage-dan-kelas-paket/03-paket-development-data-doc.md) | [Daftar Isi](../DaftarISI.md) | [Kelas Paket: Go →](../07_subpackage-dan-kelas-paket/05-paket-go.md)
