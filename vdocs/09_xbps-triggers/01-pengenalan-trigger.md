# Pengenalan XBPS Triggers

> **Ringkasan:** *Trigger* adalah potongan skrip siap pakai dari paket `xbps-triggers` yang otomatis ditambahkan ke skrip `INSTALL`/`REMOVE` sebuah paket, untuk menangani tugas rutin sistem seperti memperbarui cache ikon, mendaftarkan shell, atau meng-compile modul kernel.

---

## 1. Apa Itu Trigger?

XBPS triggers adalah kumpulan potongan kode, disediakan oleh paket **`xbps-triggers`**, yang ditambahkan ke skrip **INSTALL/REMOVE** sebuah paket dengan dua cara:

1. **Manual**, dengan mengatur variabel **`triggers`** di template.
2. **Otomatis**, ketika kondisi tertentu terpenuhi (misalnya paket memasang file ke direktori tertentu).

```bash
# Menambah trigger secara manual
triggers="gdk-pixbuf-loaders gtk-icon-cache"
```

> **Analogi:** trigger seperti "petugas kebersihan" yang otomatis datang setiap kali ada barang baru masuk atau keluar dari gedung, untuk memperbarui daftar inventaris (cache, database, dll).

---

## 2. Catatan dari Manual

Bagian trigger di manual berisi daftar semua trigger yang tersedia, **status**-nya saat ini, **apa yang dilakukannya**, dan **kondisi** agar otomatis disertakan pada sebuah paket.

> Ini **bukan** gambaran lengkap tentang paketnya. Manual menyarankan untuk **membaca variabel yang dirujuk dan membaca trigger-nya langsung**.

---

## 3. Pola Umum di Setiap Trigger

Setiap trigger umumnya punya empat hal yang bisa dipahami:

| Pertanyaan | Penjelasan |
|---|---|
| **Tugasnya apa?** | Cache/database apa yang diurus. |
| **Saat instalasi?** | Perintah yang dijalankan ketika paket dipasang. |
| **Saat penghapusan?** | Perintah yang dijalankan ketika paket dihapus. |
| **Bagaimana ditambahkan?** | Otomatis (berdasarkan direktori) atau lewat variabel tertentu. |

---

## 4. Tabel Semua Trigger

| Trigger | Tugas singkat | Penambahan | Detail |
|---|---|---|---|
| `appstream-cache` | Membangun ulang cache metadata AppStream | Otomatis (ada XML di direktori yang dicari appstreamcli) | [Desktop, Bahasa, Font](04-trigger-desktop-bahasa-font.md) |
| `binfmts` | Mendaftarkan/menghapus format biner executable | Otomatis (`usr/share/binfmts`) atau variabel `binfmts` | [Sistem](03-trigger-sistem.md) |
| `dkms` | Meng-compile/menghapus modul kernel dinamis | Variabel `dkms_modules` | [Sistem](03-trigger-sistem.md) |
| `gconf-schemas` | Mendaftarkan/menghapus file schemas dan entries gconf | Otomatis (`/usr/share/gconf/schemas`) atau `triggers` + variabel | [GTK dan GLib](02-trigger-gtk-glib.md) |
| `gdk-pixbuf-loaders` | Memelihara cache loader GDK Pixbuf | Otomatis atau `triggers` | [GTK dan GLib](02-trigger-gtk-glib.md) |
| `gio-modules` | Memperbarui cache modul GIO milik Glib | Otomatis (`/usr/lib/gio/modules`) | [GTK dan GLib](02-trigger-gtk-glib.md) |
| `gsettings-schemas` | Meng-compile skema XML GSettings | Otomatis (`/usr/share/glib-2.0/schemas`) | [GTK dan GLib](02-trigger-gtk-glib.md) |
| `gtk-icon-cache` | Memperbarui cache ikon gtk+ | Otomatis (`/usr/share/icons`) | [GTK dan GLib](02-trigger-gtk-glib.md) |
| `gtk-immodules` | Memperbarui file modul IM untuk gtk+ | Otomatis (`/usr/lib/gtk-2.0/2.10.0/immodules`) | [GTK dan GLib](02-trigger-gtk-glib.md) |
| `gtk-pixbuf-loaders` | Nama lama `gdk-pixbuf-loaders` (sedang dihapus) | - | [GTK dan GLib](02-trigger-gtk-glib.md) |
| `gtk3-immodules` | Memperbarui file modul IM untuk gtk+3 | Otomatis (`/usr/lib/gtk-3.0/3.0.0/immodules`) | [GTK dan GLib](02-trigger-gtk-glib.md) |
| `hwdb.d-dir` | Memperbarui database perangkat keras | Otomatis (`/usr/lib/udev/hwdb.d`) | [Sistem](03-trigger-sistem.md) |
| `info-files` | Mendaftarkan/menghapus file info GNU | Lihat detail | [Sistem](03-trigger-sistem.md) |
| `initramfs-regenerate` | Membuat ulang initramfs semua kernel | **Harus diminta manual** | [Sistem](03-trigger-sistem.md) |
| `kernel-hooks` | Menjalankan skrip saat pasang/hapus paket kernel | Otomatis jika `kernel_hooks_version` diatur | [Sistem](03-trigger-sistem.md) |
| `mimedb` | Memperbarui database shared-mime-info | Otomatis (`/usr/share/mime`) | [Desktop, Bahasa, Font](04-trigger-desktop-bahasa-font.md) |
| `mkdirs` | Membuat/menghapus direktori sesuai `make_dirs` | Variabel `make_dirs` | [Sistem](03-trigger-sistem.md) |
| `pango-modules` | (sedang dihapus) menghapus `pango.modules` | Manual lewat `triggers` | [GTK dan GLib](02-trigger-gtk-glib.md) |
| `pycompile` | Meng-compile kode Python ke bytecode | Variabel `pycompile_dirs`/`pycompile_module` | [Desktop, Bahasa, Font](04-trigger-desktop-bahasa-font.md) |
| `register-shell` | Mendaftarkan/menghapus shell di `etc/shells` | Variabel `register_shell` | [Sistem](03-trigger-sistem.md) |
| `system-accounts` | Membuat/menonaktifkan akun dan grup sistem | Variabel `system_accounts` | [Sistem](03-trigger-sistem.md) |
| `texmf-dist` | Meregenerasi database texmf TeXLive | Otomatis (paket yang mengubah `/usr/share/texmf-dist`) | [Desktop, Bahasa, Font](04-trigger-desktop-bahasa-font.md) |
| `update-desktopdb` | Memperbarui database desktop | Otomatis (`/usr/share/applications`) | [Desktop, Bahasa, Font](04-trigger-desktop-bahasa-font.md) |
| `x11-fonts` | Membangun ulang `fonts.dir`/`fonts.scale` dan cache font | Variabel `font_dirs` | [Desktop, Bahasa, Font](04-trigger-desktop-bahasa-font.md) |
| `xml-catalog` | Mendaftarkan/menghapus katalog SGML/XML | Variabel `sgml_entries`/`xml_entries` | [Desktop, Bahasa, Font](04-trigger-desktop-bahasa-font.md) |

---

## 5. Mengelompokkan Trigger

Dokumentasi trigger dibagi ke dalam tiga halaman berdasarkan kegunaannya:

1. [Trigger GTK dan GLib](02-trigger-gtk-glib.md): cache dan database terkait GTK, GDK, GIO, GSettings, GConf, Pango.
2. [Trigger Sistem](03-trigger-sistem.md): binfmt, kernel, DKMS, initramfs, shell, akun, direktori.
3. [Trigger Desktop, Bahasa, dan Font](04-trigger-desktop-bahasa-font.md): AppStream, MIME, desktop database, Python, TeX, font, katalog XML.

---

## Intinya

- Trigger menangani tugas pascapemasangan/penghapusan yang berulang dan standar.
- Ditambahkan **otomatis** (berdasarkan keberadaan direktori) atau **manual** (variabel `triggers` atau variabel khusus trigger).
- Banyak trigger **tidak berbuat apa-apa** sampai variabel pemicunya didefinisikan.

---

<!-- nav -->
[← Menghapus Paket](../08_pemeliharaan-paket/02-menghapus-paket.md) | [Daftar Isi](../DaftarISI.md) | [Trigger GTK dan GLib →](../09_xbps-triggers/02-trigger-gtk-glib.md)
