# Trigger GTK dan GLib

> **Ringkasan:** Trigger yang mengurus cache dan database untuk ekosistem GTK/GNOME: GConf, GDK Pixbuf, GIO, GSettings, ikon GTK, modul input method (IM), dan Pango.

---

## `gconf-schemas`

**Tugas:** mendaftarkan dan menghapus file `.schemas` dan `.entries` ke direktori database schemas.

| Tahap | Aksi |
|---|---|
| Instalasi | Memakai `gconftool-2` untuk memasang file `.schemas` dan `.entries` ke `usr/share/gconf/schemas`. |
| Penghapusan | Memakai `gconftool-2` untuk menghapus entries dan schemas milik paket yang dihapus dari database. |

**Cara menambahkan:**

- Manual: tambahkan `gconf-schemas` ke `triggers`, lalu isi `gconf_schemas` (untuk `.schemas`) dan `gconf_entries` (untuk `.entries`).
- Otomatis: untuk paket yang punya `/usr/share/gconf/schemas` sebagai direktori. Semua file berekstensi schemas di direktori itu diteruskan ke trigger.

---

## `gdk-pixbuf-loaders`

**Tugas:** memelihara cache loader GDK Pixbuf.

| Tahap | Aksi |
|---|---|
| Instalasi | Menjalankan `gdk-pixbuf-query-loaders --update-cache` dan menghapus file usang `etc/gtk-2.0/gdk-pixbuf.loaders` bila ada. |
| Penghapusan | Saat paket `gdk-pixbuf` dihapus, file cache dihapus bila ada. Lokasi normalnya: `usr/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache`. |

**Cara menambahkan:**

- Manual: definisikan `gdk-pixbuf-loaders` di variabel `triggers`.
- Otomatis: untuk paket yang punya path `usr/lib/gdk-pixbuf-2.0/2.10.0/loaders` sebagai direktori.

---

## `gio-modules`

**Tugas:** memperbarui cache modul GIO milik Glib memakai `gio-querymodules` dari paket `glib`.

| Tahap | Aksi |
|---|---|
| Instalasi dan penghapusan | Menjalankan `gio-querymodules` untuk memperbarui file cache di `usr/lib/gio/modules`. |

**Cara menambahkan:** otomatis untuk paket yang punya `/usr/lib/gio/modules` sebagai direktori.

---

## `gsettings-schemas`

**Tugas:** meng-compile file skema XML GSettings milik Glib saat instalasi dan menghapus hasil kompilasinya saat penghapusan.

| Tahap | Aksi |
|---|---|
| Instalasi | Memakai `glib-compile-schemas` dari `glib` untuk mengompilasi skema menjadi file berakhiran `.compiled` di `/usr/share/glib-2.0/schemas`. |
| Penghapusan | Saat paket `glib` dihapus, semua file berakhiran `.compiled` di `/usr/share/glib-2.0/schemas` dihapus. |

**Cara menambahkan:** otomatis untuk paket yang punya `/usr/share/glib-2.0/schemas` sebagai direktori.

---

## `gtk-icon-cache`

**Tugas:** memperbarui cache ikon gtk+.

| Tahap | Aksi |
|---|---|
| Instalasi | Memakai `gtk-update-icon-cache` untuk memperbarui cache ikon. |
| Penghapusan | Saat paket `gtk+` dihapus, file `icon-theme.cache` di direktori yang ditentukan variabel `gtk_iconcache_dirs` dihapus. |

**Cara menambahkan:** otomatis untuk paket yang punya `/usr/share/icons` sebagai direktori. Semua direktori di bawahnya dikirim ke trigger dengan path absolut.

---

## `gtk-immodules`

**Tugas:** memperbarui file modul IM (*Input Method*) untuk gtk+.

| Tahap | Aksi |
|---|---|
| Instalasi | Memakai `gtk-query-immodules-2.0 --update-cache` untuk memperbarui file cache. Juga menghapus file konfigurasi usang `etc/gtk-2.0/gtk.immodules` bila ada. |
| Penghapusan | Saat paket `gtk+` dihapus, file cache di `usr/lib/gtk-2.0/2.10.0/immodules.cache` dihapus. |

**Cara menambahkan:** otomatis untuk paket yang punya `/usr/lib/gtk-2.0/2.10.0/immodules` sebagai direktori.

---

## `gtk-pixbuf-loaders`

**Status:** nama lama dari trigger `gdk-pixbuf-loaders` yang **sedang dalam proses dihapus**. Saat ini hanya meneruskan (*re-exec*) ke `gdk-pixbuf-loaders` sebagai langkah kompatibilitas.

Cara kerjanya: lihat [`gdk-pixbuf-loaders`](#gdk-pixbuf-loaders).

---

## `gtk3-immodules`

**Tugas:** memperbarui file modul IM untuk gtk+3.

| Tahap | Aksi |
|---|---|
| Instalasi | Menjalankan `gtk-query-immodules-3.0 --update-cache` untuk memperbarui file cache. Juga menghapus file konfigurasi usang `etc/gtk-3.0/gtk.immodules` bila ada. |
| Penghapusan | Saat paket `gtk+3` dihapus, file cache di `usr/lib/gtk-3.0/3.0.0/immodules.cache` dihapus. |

**Cara menambahkan:** otomatis untuk paket yang punya `/usr/lib/gtk-3.0/3.0.0/immodules` sebagai direktori.

---

## `pango-modules`

**Status:** sedang dihapus, karena upstream sudah menghapus kode yang menjadi dasarnya.

| Tahap | Aksi |
|---|---|
| Dulu | Memperbarui file modul pango dengan `pango-modulesquery` saat pemasangan paket apa pun. |
| Sekarang | Hanya menghapus file `etc/pango/pango.modules` saat paket `pango` dihapus. |

**Cara menambahkan:** hanya bisa dengan mendefinisikan `pango-modules` di variabel `triggers`. **Tidak ada** cara penambahan otomatis.

---

## Ringkasan Cepat Bagian Ini

| Trigger | Perintah utama | Otomatis jika ada direktori |
|---|---|---|
| `gconf-schemas` | `gconftool-2` | `/usr/share/gconf/schemas` |
| `gdk-pixbuf-loaders` | `gdk-pixbuf-query-loaders --update-cache` | `usr/lib/gdk-pixbuf-2.0/2.10.0/loaders` |
| `gio-modules` | `gio-querymodules` | `/usr/lib/gio/modules` |
| `gsettings-schemas` | `glib-compile-schemas` | `/usr/share/glib-2.0/schemas` |
| `gtk-icon-cache` | `gtk-update-icon-cache` | `/usr/share/icons` |
| `gtk-immodules` | `gtk-query-immodules-2.0 --update-cache` | `/usr/lib/gtk-2.0/2.10.0/immodules` |
| `gtk3-immodules` | `gtk-query-immodules-3.0 --update-cache` | `/usr/lib/gtk-3.0/3.0.0/immodules` |
| `gtk-pixbuf-loaders` | (meneruskan ke `gdk-pixbuf-loaders`) | - |
| `pango-modules` | (hanya hapus `pango.modules`) | tidak ada |

---

## Intinya

- Sebagian besar trigger GTK/GLib **otomatis** aktif jika paket memasang file ke direktori tertentu, jadi biasanya tidak perlu diatur manual.
- `gtk-pixbuf-loaders` dan `pango-modules` sedang dalam proses dihapus.
- `gconf-schemas` adalah yang paling sering butuh variabel tambahan (`gconf_schemas`, `gconf_entries`).

---

<!-- nav -->
[← Pengenalan XBPS Triggers](../09_xbps-triggers/01-pengenalan-trigger.md) | [Daftar Isi](../DaftarISI.md) | [Trigger Sistem →](../09_xbps-triggers/03-trigger-sistem.md)
