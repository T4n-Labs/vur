# Trigger Desktop, Bahasa, dan Font

> **Ringkasan:** Trigger untuk metadata aplikasi desktop (AppStream, MIME, database desktop), kode Python, TeX Live, font X11, dan katalog SGML/XML.

---

## `appstream-cache`

**Tugas:** membangun ulang cache metadata AppStream.

| Tahap | Aksi |
|---|---|
| Instalasi | Menjalankan `appstreamcli refresh-cache --verbose --force --datapath $APPSTREAM_PATHS --cachepath var/cache/app-info/gv`. Secara default `APPSTREAM_PATHS` adalah semua path yang dicari `appstreamcli` untuk file metadata. |
| Penghapusan | Saat paket `AppStream` dihapus, direktori `var/cache/app-info/gv` dihapus. |

Direktori yang dicari oleh `appstreamcli`:

- `usr/share/appdata`
- `usr/share/app-info`
- `var/lib/app-info`
- `var/cache/app-info`

**Cara menambahkan:** otomatis untuk paket yang punya file XML di salah satu direktori yang dicari `appstreamcli`.

---

## `mimedb`

**Tugas:** memperbarui database `shared-mime-info`.

| Tahap | Aksi |
|---|---|
| Semua proses | Menjalankan `update-mime-database -n usr/share/mime`. |

**Cara menambahkan:** otomatis untuk paket yang punya `/usr/share/mime` sebagai direktori.

---

## `update-desktopdb`

**Tugas:** memperbarui database desktop/MIME sistem.

| Tahap | Aksi |
|---|---|
| Instalasi | Menjalankan `update-desktop-database usr/share/applications`, yang menghasilkan file cache `usr/share/applications/mimeinfo.cache`. |
| Penghapusan | Saat paket `desktop-file-utils` dihapus, file cache yang dibuat saat instalasi dihapus. |

**Cara menambahkan:** otomatis untuk paket yang punya `/usr/share/applications` sebagai direktori.

---

## `pycompile`

**Tugas:** meng-compile kode Python menjadi bytecode native dan menghapus bytecode yang dihasilkan.

| Tahap | Aksi |
|---|---|
| Instalasi | Meng-compile semua kode Python di path yang diberikan lewat `pycompile_dirs` dan semua modul di `pycompile_module` menjadi bytecode native, lalu memperbarui cache `ldconfig(8)`. |
| Penghapusan | Menghapus semua bytecode native dan memperbarui cache `ldconfig(8)`. |

**Cara menambahkan:** gunakan variabel `pycompile_dirs` dan/atau `pycompile_module`. Trigger tidak berbuat apa-apa kecuali minimal salah satu didefinisikan.

Variabel `python_version` bisa diatur untuk mengarahkan perilaku trigger. Detailnya ada di [Kelas Paket: Python](../07_subpackage-dan-kelas-paket/04-paket-python.md).

---

## `texmf-dist`

**Tugas:** meregenerasi database texmf milik TeX Live.

| Tahap | Aksi |
|---|---|
| Instalasi dan penghapusan | Meregenerasi database **texhash** dan **format** memakai `texhash` dan `fmtutil-sys`, untuk menambah atau menghapus hash dan format baru. |

**Cara menambahkan:** otomatis berjalan di **setiap paket** yang mengubah `/usr/share/texmf-dist`.

> Pendekatan ini kemungkinan berlebihan, tetapi jauh lebih bersih daripada memeriksa setiap direktori format dan setiap direktori yang di-hash. Lagi pula, hampir pasti setiap paket yang menyentuh `/usr/share/texmf-dist` memang membutuhkan salah satu dari trigger tersebut.

---

## `x11-fonts`

**Tugas:** membangun ulang file `fonts.dir` dan `fonts.scale` untuk paket yang memasang font X11, dan memperbarui cache fontconfig untuk font tersebut.

| Tahap | Aksi |
|---|---|
| Instalasi dan penghapusan | Menjalankan `mkfontdir`, `mkfontscale`, dan `fc-cache` untuk semua direktori font yang diberikan lewat `font_dirs`. |

**Cara menambahkan:** gunakan variabel `font_dirs`. Trigger tidak berbuat apa-apa kecuali variabel ini didefinisikan. Lihat [Kelas Paket: Font](../07_subpackage-dan-kelas-paket/07-paket-font.md).

---

## `xml-catalog`

**Tugas:** mendaftarkan dan menghapus entri katalog SGML/XML.

| Tahap | Aksi |
|---|---|
| Instalasi | Memakai `xmlcatmgr` untuk mendaftarkan semua katalog yang diberikan lewat `sgml_entries` dan `xml_entries`, masing-masing di `usr/share/sgml/catalog` dan `usr/share/xml/catalog`. |
| Penghapusan | Memakai `xmlcatmgr` untuk menghapus semua katalog yang diberikan lewat `sgml_entries` dan `xml_entries` dari lokasi yang sama. |

**Cara menambahkan:** gunakan variabel `sgml_entries` dan/atau `xml_entries`. Trigger tidak berbuat apa-apa kecuali salah satunya didefinisikan.

---

## Ringkasan Cepat Bagian Ini

| Trigger | Perintah utama | Dipicu oleh |
|---|---|---|
| `appstream-cache` | `appstreamcli refresh-cache` | Otomatis (XML di direktori AppStream) |
| `mimedb` | `update-mime-database` | Otomatis (`/usr/share/mime`) |
| `update-desktopdb` | `update-desktop-database` | Otomatis (`/usr/share/applications`) |
| `pycompile` | Compile bytecode Python | `pycompile_dirs`, `pycompile_module` |
| `texmf-dist` | `texhash`, `fmtutil-sys` | Otomatis (`/usr/share/texmf-dist`) |
| `x11-fonts` | `mkfontdir`, `mkfontscale`, `fc-cache` | `font_dirs` |
| `xml-catalog` | `xmlcatmgr` | `sgml_entries`, `xml_entries` |

---

## Intinya

- `appstream-cache`, `mimedb`, `update-desktopdb`, dan `texmf-dist` otomatis aktif berdasarkan direktori yang dipasang paket.
- `pycompile`, `x11-fonts`, dan `xml-catalog` baru bekerja jika variabel pemicunya didefinisikan.

---

<!-- nav -->
[← Trigger Sistem](../09_xbps-triggers/03-trigger-sistem.md) | [Daftar Isi](../DaftarISI.md) | [Catatan Penting dan Dokumentasi Khusus Void →](../10_praktik-dan-kontribusi/01-catatan-dan-dokumentasi-void.md)
