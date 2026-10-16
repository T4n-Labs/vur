# 16. XBPS Triggers

[« Rename & Remove Package](15-rename-remove-package.md) · [Daftar Isi](README.md) · Selanjutnya: [Catatan & Kontribusi »](17-catatan-dan-kontribusi.md)

XBPS triggers adalah kumpulan potongan kode, disediakan oleh paket
`xbps-triggers`, yang ditambahkan ke script INSTALL/REMOVE sebuah paket —
baik secara manual (dengan mengeset variabel `triggers` di template), maupun
otomatis ketika kondisi tertentu terpenuhi.

Berikut daftar semua trigger yang tersedia, status terkininya, apa yang
dilakukan masing-masing, dan kondisi apa yang membuatnya otomatis
disertakan di sebuah paket.

> Ini bukan gambaran lengkap. Disarankan membaca variabel yang dirujuk dan
> trigger-nya sendiri secara langsung.

## Ringkasan Trigger

| Trigger | Diaktifkan otomatis oleh | Fungsi singkat |
|---|---|---|
| `appstream-cache` | file XML di direktori metadata appstream | Membangun ulang cache metadata appstream |
| `binfmts` | file di `usr/share/binfmts` / variabel `binfmts` | Mendaftar/menghapus binary format arbitrer |
| `dkms` | variabel `dkms_modules` | Kompilasi & hapus modul kernel dinamis |
| `gconf-schemas` | variabel `triggers` + `gconf_schemas`/`gconf_entries` | Daftar/hapus schema GConf |
| `gdk-pixbuf-loaders` | direktori `usr/lib/gdk-pixbuf-2.0/2.10.0/loaders` | Update cache loader GDK Pixbuf |
| `gio-modules` | direktori `/usr/lib/gio/modules` | Update cache modul GIO |
| `gsettings-schemas` | direktori `/usr/share/glib-2.0/schemas` | Compile schema GSettings |
| `gtk-icon-cache` | direktori `/usr/share/icons` | Update icon cache GTK+ |
| `gtk-immodules` | direktori `usr/lib/gtk-2.0/2.10.0/immodules` | Update cache IM module GTK+2 |
| `gtk-pixbuf-loaders` | (deprecated, alias `gdk-pixbuf-loaders`) | Compat lama, akan dihapus |
| `gtk3-immodules` | direktori `usr/lib/gtk-3.0/3.0.0/immodules` | Update cache IM module GTK+3 |
| `hwdb.d-dir` | direktori `/usr/lib/udev/hwdb.d` | Update database hardware |
| `info-files` | keberadaan file info | Daftar/hapus file GNU info |
| `initramfs-regenerate` | manual (via `triggers`) | Regenerasi image initramfs |
| `kernel-hooks` | paket kernel | Jalankan script `etc/kernel.d/$TARGET` |
| `mimedb` | otomatis di semua paket | Update database shared-mime-info |
| `mkdirs` | variabel `make_dirs` | Buat/hapus direktori sesuai `make_dirs` |
| `pango-modules` | variabel `triggers` (manual) | (dalam proses dihapus) update file modul pango |
| `pycompile` | variabel `pycompile_dirs`/`pycompile_module` | Compile bytecode Python |
| `register-shell` | variabel `register_shell` | Daftar/hapus shell di `etc/shells` |
| `system-accounts` | variabel `system_accounts` | Buat/nonaktifkan akun sistem |
| `texmf-dist` | perubahan pada `/usr/share/texmf-dist` | Regenerasi database TeXLive |
| `update-desktopdb` | direktori `/usr/share/applications` | Update database MIME desktop |
| `x11-fonts` | variabel `font_dirs` | Rebuild font cache X11 |
| `xml-catalog` | variabel `sgml_entries`/`xml_entries` | Daftar/hapus entri katalog SGML/XML |

## Detail Tiap Trigger

### appstream-cache

Bertanggung jawab membangun ulang cache metadata appstream.

Saat instalasi, menjalankan:
`appstreamcli refresh-cache --verbose --force --datapath $APPSTREAM_PATHS --cachepath var/cache/app-info/gv`.
Secara default, `APPSTREAM_PATHS` mencakup semua path yang dicari
`appstreamcli` untuk file metadata, yaitu:

- `usr/share/appdata`
- `usr/share/app-info`
- `var/lib/app-info`
- `var/cache/app-info`

Saat penghapusan paket `AppStream`, direktori `var/cache/app-info/gv` akan
dihapus.

Otomatis ditambahkan ke paket yang punya file XML di salah satu direktori
yang dicari `appstreamcli`.

### binfmts

Bertanggung jawab mendaftarkan dan menghapus format binary executable
arbitrer (binfmts).

Saat instalasi/penghapusan, memakai `update-binfmts` dari paket
`binfmt-support` untuk mendaftar/menghapus entri dari database binfmts.

Otomatis ditambahkan ke paket yang punya file di `usr/share/binfmts`. File
ini harus berformat `update-binfmts` dan akan di-import dengan
`update-binfmts --import`.

Meski bukan cara yang disarankan, trigger ini juga bisa ditambahkan lewat
variabel `binfmts`, berisi baris yang mendefinisikan binfmt untuk
didaftarkan:

```
/path/to/interpreter [update-binfmts binary format specification arguments ...]
...
```

Lihat [`update-binfmts(8)`](https://man.voidlinux.org/man8/update-binfmts.8)
untuk detail lebih lanjut.

### dkms

Bertanggung jawab mengompilasi dan menghapus modul kernel dinamis (dynamic
kernel modules) sebuah paket.

Saat instalasi, trigger mengompilasi dan memasang modul dinamis untuk semua
paket `linux` yang paket `linux-headers` yang sesuai sudah terpasang. Saat
penghapusan, modul yang bersangkutan akan dihapus.

Untuk menyertakan trigger ini, gunakan variabel `dkms_modules`; trigger
tidak akan melakukan apa-apa kecuali variabel ini didefinisikan.

### gconf-schemas

Bertanggung jawab mendaftarkan dan menghapus file `.schemas` dan `.entries`
ke direktori database schemas.

Saat instalasi, memakai `gconftool-2` untuk memasang file `.schemas` dan
`.entries` ke `usr/share/gconf/schemas`. Saat penghapusan, `gconftool-2`
dipakai untuk menghapus entry dan schema milik paket yang dihapus dari
database.

Untuk menyertakannya, tambahkan `gconf-schemas` ke `triggers`, dan
tambahkan file `.schemas` yang sesuai di variabel `gconf_schemas`, serta
`.entries` di `gconf_entries`.

Otomatis ditambahkan ke paket yang punya direktori `/usr/share/gconf/schemas`.
Semua file berekstensi schemas di dalam direktori tersebut akan dipassing
ke trigger.

### gdk-pixbuf-loaders

Bertanggung jawab menjaga cache GDK Pixbuf loaders.

Saat instalasi, menjalankan `gdk-pixbuf-query-loaders --update-cache`, dan
juga menghapus file lama `etc/gtk-2.0/gdk-pixbuf.loaders` jika ada. Saat
penghapusan paket `gdk-pixbuf`, file cache akan dihapus — biasanya berada
di `usr/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache`.

Bisa ditambahkan dengan mendefinisikan `gdk-pixbuf-loaders` di variabel
`triggers`. Juga otomatis ditambahkan ke paket yang punya path
`usr/lib/gdk-pixbuf-2.0/2.10.0/loaders` sebagai direktori.

### gio-modules

Bertanggung jawab memperbarui cache modul GIO milik Glib dengan
`gio-querymodules` dari paket `glib`.

Saat instalasi dan penghapusan, hanya menjalankan `gio-querymodules` untuk
memperbarui file cache di `usr/lib/gio/modules`.

Otomatis ditambahkan ke paket yang punya direktori `/usr/lib/gio/modules`.

### gsettings-schemas

Bertanggung jawab mengompilasi file schema XML GSettings milik Glib saat
instalasi, dan menghapus file hasil kompilasinya saat penghapusan.

Saat instalasi, memakai `glib-compile-schemas` dari `glib` untuk
mengompilasi schema menjadi file berakhiran `.compiled` di
`/usr/share/glib-2.0/schemas`.

Saat penghapusan paket `glib`, semua file di `/usr/share/glib-2.0/schemas`
yang berakhiran `.compiled` akan dihapus.

Otomatis ditambahkan ke paket yang punya direktori
`/usr/share/glib-2.0/schemas`.

### gtk-icon-cache

Bertanggung jawab memperbarui icon cache GTK+.

Saat instalasi, memakai `gtk-update-icon-cache` untuk memperbarui icon
cache. Saat penghapusan paket `gtk+`, file `icon-theme.cache` di
direktori yang ditentukan variabel `gtk_iconcache_dirs` akan dihapus.

Otomatis ditambahkan ke paket yang punya direktori `/usr/share/icons`;
semua direktori di dalamnya dipassing path absolutnya ke trigger.

### gtk-immodules

Bertanggung jawab memperbarui file modul IM (Input Method) untuk GTK+.

Saat instalasi, memakai `gtk-query-immodules-2.0 --update-cache` untuk
memperbarui file cache. Juga menghapus file konfigurasi lama
`etc/gtk-2.0/gtk.immodules` jika ada.

Saat penghapusan paket `gtk+`, file cache di
`usr/lib/gtk-2.0/2.10.0/immodules.cache` akan dihapus.

Otomatis ditambahkan ke paket yang punya direktori
`usr/lib/gtk-2.0/2.10.0/immodules`.

### gtk-pixbuf-loaders

Nama lama untuk trigger `gdk-pixbuf-loaders` yang sekarang sedang dalam
proses dihapus. Saat ini hanya re-exec ke `gdk-pixbuf-loaders` sebagai
langkah kompatibilitas.

Untuk detail cara kerjanya, lihat bagian
[gdk-pixbuf-loaders](#gdk-pixbuf-loaders) di atas.

### gtk3-immodules

Bertanggung jawab memperbarui file modul IM untuk GTK+3.

Saat instalasi, menjalankan `gtk-query-immodules-3.0 --update-cache` untuk
memperbarui cache. Juga menghapus file konfigurasi lama
`etc/gtk-3.0/gtk.immodules` jika ada.

Saat penghapusan paket `gtk+3`, file cache di
`usr/lib/gtk-3.0/3.0.0/immodules.cache` akan dihapus.

Otomatis ditambahkan ke paket yang punya direktori
`usr/lib/gtk-3.0/3.0.0/immodules`.

### hwdb.d-dir

Bertanggung jawab memperbarui database hardware.

Saat instalasi dan penghapusan, menjalankan
`usr/bin/udevadm hwdb --root=. --update`.

Otomatis ditambahkan ke paket yang punya direktori
`/usr/lib/udev/hwdb.d`.

### info-files

Bertanggung jawab mendaftarkan dan membatalkan pendaftaran file GNU info
sebuah paket.

Memeriksa keberadaan file info yang diberikan, dan apakah sedang berjalan
di arsitektur lain.

Saat instalasi, memakai `install-info` untuk mendaftarkan file info ke
`usr/share/info`. Saat penghapusan, memakai `install-info --delete` untuk
menghapus file info dari registry di `usr/share/info`.

Jika berjalan di arsitektur lain, akan mencoba memakai utilitas
`install-info` milik host.

### initramfs-regenerate

Memicu regenerasi semua image initramfs kernel setelah instalasi atau
penghapusan paket. Trigger ini **harus diminta secara manual**.

Hook ini paling berguna untuk paket DKMS, karena menyediakan cara untuk
menyertakan modul kernel yang baru dikompilasi ke dalam image initramfs
untuk semua kernel yang saat ini tersedia. Saat dipakai di paket DKMS,
disarankan menyertakan trigger `dkms` secara manual **sebelum** trigger
`initramfs-regenerate`, contoh:

```
triggers="dkms initramfs-regenerate"
```

Meski `xbps-src` otomatis menyertakan trigger `dkms` setiap kali
`dkms_modules` terpasang, penambahan otomatis ini akan terjadi **setelah**
`initramfs-regenerate`, yang menyebabkan image initramfs dibuat ulang
sebelum modul selesai dikompilasi.

Secara default, trigger memakai `dracut --regenerate-all` untuk membuat
ulang image initramfs. Jika `/etc/default/initramfs-regenerate` ada dan
mendefinisikan `INITRAMFS_GENERATOR=mkinitcpio`, trigger akan memakai
`mkinitcpio` dan mengulang untuk semua versi kernel yang tampaknya
memiliki modul terpasang. Alternatifnya, mengeset
`INITRAMFS_GENERATOR=none` akan menonaktifkan regenerasi image sepenuhnya.

### kernel-hooks

Bertanggung jawab menjalankan script saat instalasi/penghapusan paket
kernel.

Target yang tersedia: `pre-install`, `pre-remove`, `post-install`,
`post-remove`.

Saat dijalankan, akan mencoba menjalankan semua executable yang ditemukan
di `etc/kernel.d/$TARGET`. Variabel `TARGET` adalah salah satu dari 4
target yang tersedia untuk trigger ini. Direktori tersebut juga akan
dibuat jika belum ada.

Saat update, trigger ini tidak akan mencoba menjalankan executable apa pun
saat berjalan dengan target `pre-remove`.

### mimedb

Bertanggung jawab memperbarui database shared-mime-info.

Di semua kondisi, hanya menjalankan
`update-mime-database -n usr/share/mime`.

Otomatis ditambahkan ke paket yang punya direktori `/usr/share/mime`.

### mkdirs

Bertanggung jawab membuat dan menghapus direktori sesuai variabel
`make_dirs`.

Saat instalasi, mengambil variabel `make_dirs` dan memecahnya menjadi
kelompok 4 nilai:

- `dir` — path lengkap direktori
- `mode` — izin Unix untuk direktori
- `uid` — nama user pemilik
- `gid` — nama group pemilik

Trigger akan terus memecah nilai `make_dirs` menjadi kelompok 4 sampai
nilainya habis.

Saat instalasi, direktori dibuat dengan `dir`, lalu mode diset dengan
`mode` dan izin dengan `uid:gid`.

Saat penghapusan, direktori dihapus dengan `rmdir`.

Untuk menyertakan trigger ini, gunakan variabel `make_dirs`; trigger tidak
akan melakukan apa-apa kecuali variabel ini didefinisikan.

### pango-modules

Trigger ini sedang dalam proses dihapus, karena upstream sudah menghapus
kode yang bertanggung jawab untuknya.

Dulu dipakai untuk memperbarui file modul pango dengan
`pango-modulesquery` saat instalasi paket apa pun.

Saat ini hanya menghapus file `etc/pango/pango.modules` saat penghapusan
paket pango.

Bisa ditambahkan dengan mendefinisikan `pango-modules` di variabel
`triggers`, dan tidak punya cara untuk ditambahkan otomatis ke sebuah
paket.

### pycompile

Bertanggung jawab mengompilasi kode python menjadi bytecode native, dan
menghapus bytecode yang dihasilkan.

Saat instalasi, mengompilasi semua kode python di bawah path yang
diberikan lewat `pycompile_dirs`, dan semua modul yang dijelaskan di
`pycompile_module`, menjadi bytecode native, lalu memperbarui cache
`ldconfig(8)`.

Saat penghapusan, menghapus semua bytecode native dan memperbarui cache
`ldconfig(8)`.

Untuk menyertakan trigger ini, gunakan variabel `pycompile_dirs` dan
`pycompile_module`; trigger tidak akan melakukan apa-apa kecuali salah
satu variabel ini didefinisikan.

Variabel `python_version` bisa diset untuk mengatur perilaku trigger.

### register-shell

Bertanggung jawab mendaftarkan dan menghapus entri shell ke `etc/shells`.

Saat instalasi, menambahkan shell baru ke file `etc/shells`, dan juga
mengubah izinnya menjadi `644`.

Saat penghapusan, memakai `sed` untuk menghapus shell tersebut dari file.

Untuk menyertakan trigger ini, gunakan variabel `register_shell`; trigger
tidak akan melakukan apa-apa kecuali variabel ini didefinisikan.

### system-accounts

Bertanggung jawab membuat dan menonaktifkan akun serta group sistem.

Saat penghapusan, akun dinonaktifkan dengan mengeset Shell ke
`/bin/false`, Home ke `/var/empty`, dan menambahkan
`' - for uninstalled package $pkgname'` ke Description. Contoh:
`transmission unprivileged user - for uninstalled package transmission`.

Trigger ini hanya bisa dipakai lewat variabel `system_accounts`.

### texmf-dist

Bertanggung jawab meregenerasi database texmf milik TeXLive.

Saat instalasi maupun penghapusan, meregenerasi database texhash dan
format memakai `texhash` dan `fmtutil-sys`, untuk menambah atau menghapus
hash/format baru.

Berjalan di setiap paket yang mengubah `/usr/share/texmf-dist`. Ini
mungkin terkesan berlebihan, tapi jauh lebih bersih dibanding memeriksa
tiap direktori format dan tiap direktori yang di-hash satu per satu.
Selain itu, hampir pasti paket apa pun yang menyentuh
`/usr/share/texmf-dist` memang membutuhkan trigger ini.

### update-desktopdb

Bertanggung jawab memperbarui database MIME sistem.

Saat instalasi, menjalankan
`update-desktop-database usr/share/applications`, yang menghasilkan file
cache di `usr/share/applications/mimeinfo.cache`.

Saat penghapusan paket `desktop-file-utils`, file cache yang dibuat saat
instalasi akan dihapus.

Otomatis ditambahkan ke paket yang punya direktori
`/usr/share/applications`.

### x11-fonts

Bertanggung jawab membangun ulang file `fonts.dir` dan `fonts.scale` untuk
paket yang memasang font X11, serta memperbarui cache fontconfig untuk
font tersebut.

Saat instalasi dan penghapusan, menjalankan `mkfontdir`, `mkfontscale`,
dan `fc-cache` untuk semua direktori font yang diberikan lewat variabel
`font_dirs`.

Untuk menyertakan trigger ini, gunakan variabel `font_dirs`; trigger tidak
akan melakukan apa-apa kecuali variabel ini didefinisikan.

### xml-catalog

Bertanggung jawab mendaftarkan dan menghapus entri katalog SGML/XML.

Saat instalasi, memakai `xmlcatmgr` untuk mendaftarkan semua katalog yang
dipassing lewat variabel `sgml_entries` dan `xml_entries`, masing-masing
ke `usr/share/sgml/catalog` dan `usr/share/xml/catalog`.

Saat penghapusan, memakai `xmlcatmgr` untuk menghapus semua katalog yang
dipassing lewat variabel yang sama.

Untuk menyertakan trigger ini, gunakan variabel `sgml_entries` dan/atau
`xml_entries`; trigger tidak akan melakukan apa-apa kecuali salah satunya
didefinisikan.
