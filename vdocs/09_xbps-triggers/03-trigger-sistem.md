# Trigger Sistem

> **Ringkasan:** Trigger yang mengurus hal-hal tingkat sistem: format biner (binfmt), modul kernel (DKMS), initramfs, hook kernel, database perangkat keras, file info, direktori, shell, dan akun sistem.

---

## `binfmts`

**Tugas:** mendaftarkan dan menghapus format biner executable sembarang (*arbitrary executable binary formats*), yang dikenal sebagai *binfmts*.

| Tahap | Aksi |
|---|---|
| Instalasi dan penghapusan | Memakai `update-binfmts` dari paket `binfmt-support` untuk mendaftarkan atau menghapus entri dari database format biner executable. |

**Cara menambahkan:**

- **Otomatis** untuk paket yang berisi file di `usr/share/binfmts`. File-file ini harus berformat `update-binfmts` dan akan diimpor dengan `update-binfmts --import`.
- **Manual** (kurang disukai) lewat variabel `binfmts`, yang berisi baris-baris definisi binfmt untuk didaftarkan:

```
/path/to/interpreter [update-binfmts binary format specification arguments ...]
...
```

Lihat [`update-binfmts(8)`](https://man.voidlinux.org/man8/update-binfmts.8) untuk detailnya.

---

## `dkms`

**Tugas:** meng-compile dan menghapus modul kernel dinamis (*dynamic kernel modules*) milik paket.

| Tahap | Aksi |
|---|---|
| Instalasi | Meng-compile dan memasang modul dinamis untuk semua paket `linux` yang paket `linux-headers`-nya sudah terpasang. |
| Penghapusan | Modul yang bersangkutan dihapus. |

**Cara menambahkan:** gunakan variabel **`dkms_modules`**. Trigger tidak berbuat apa-apa kalau variabel ini tidak didefinisikan.

```bash
dkms_modules="$pkgname $version"
```

---

## `hwdb.d-dir`

**Tugas:** memperbarui database perangkat keras.

| Tahap | Aksi |
|---|---|
| Instalasi dan penghapusan | Menjalankan `usr/bin/udevadm hwdb --root=. --update`. |

**Cara menambahkan:** otomatis untuk paket yang punya `/usr/lib/udev/hwdb.d` sebagai direktori.

---

## `info-files`

**Tugas:** mendaftarkan dan membatalkan pendaftaran file *info* GNU milik paket.

Trigger ini memeriksa keberadaan file info yang diberikan kepadanya, dan memeriksa apakah ia berjalan di bawah arsitektur lain.

| Tahap | Aksi |
|---|---|
| Instalasi | Memakai `install-info` untuk mendaftarkan file info ke `usr/share/info`. |
| Penghapusan | Memakai `install-info --delete` untuk menghapus file info dari registri di `usr/share/info`. |
| Arsitektur lain | Mencoba memakai utilitas `install-info` milik **host**. |

---

## `initramfs-regenerate`

**Tugas:** memicu pembuatan ulang **semua image initramfs kernel** setelah pemasangan atau penghapusan paket. Trigger ini **harus diminta secara manual**.

**Paling berguna untuk paket DKMS**, karena menyediakan cara memasukkan modul kernel yang baru dikompilasi ke image initramfs semua kernel yang tersedia.

### Urutan Penting untuk Paket DKMS

Disarankan menyertakan trigger `dkms` **sebelum** `initramfs-regenerate`:

```bash
triggers="dkms initramfs-regenerate"
```

Mengapa? `xbps-src` otomatis menyertakan trigger `dkms` setiap kali `dkms_modules` didefinisikan, **tetapi** penambahan otomatis itu datang **setelah** `initramfs-regenerate`. Akibatnya initramfs akan dibuat ulang **sebelum** modul dikompilasi.

### Generator initramfs

| Kondisi | Generator |
|---|---|
| Default | `dracut --regenerate-all` |
| `/etc/default/initramfs-regenerate` ada dan `INITRAMFS_GENERATOR=mkinitcpio` | `mkinitcpio`, dijalankan berulang untuk semua versi kernel yang tampaknya punya modul terpasang |
| `INITRAMFS_GENERATOR=none` | Pembuatan ulang image **dinonaktifkan sepenuhnya** |

---

## `kernel-hooks`

**Tugas:** menjalankan skrip saat pemasangan/penghapusan paket kernel.

**Target yang tersedia:** `pre-install`, `pre-remove`, `post-install`, dan `post-remove`.

Saat dijalankan, trigger mencoba menjalankan **semua executable** di `etc/kernel.d/$TARGET`. Variabel `TARGET` adalah salah satu dari empat target di atas. Direktori juga dibuat jika belum ada.

Saat **pembaruan**, trigger **tidak** menjalankan executable apa pun pada target `pre-remove`.

**Cara menambahkan:** otomatis jika variabel helper `kernel_hooks_version` didefinisikan. Namun mendefinisikannya **tidak wajib**.

---

## `mkdirs` <a id="mkdirs"></a>

**Tugas:** membuat dan menghapus direktori yang ditentukan oleh variabel [`make_dirs`](../02_dasar-template/06-variabel-opsional-metadata.md).

Saat instalasi, trigger memecah `make_dirs` menjadi **kelompok berisi 4 nilai**, terus berulang sampai nilainya habis:

| Nilai | Arti |
|---|---|
| `dir` | Path lengkap direktori |
| `mode` | Izin Unix direktori |
| `uid` | Nama pengguna pemilik |
| `gid` | Nama grup pemilik |

| Tahap | Aksi |
|---|---|
| Instalasi | Membuat direktori `dir`, mengatur `mode`, lalu mengatur kepemilikan `uid:gid`. |
| Penghapusan | Menghapus direktori memakai `rmdir`. |

**Cara menambahkan:** gunakan variabel `make_dirs`. Trigger tidak berbuat apa-apa kecuali variabel ini didefinisikan.

```bash
make_dirs="/var/lib/foo 0750 foo foo"
```

---

## `register-shell`

**Tugas:** mendaftarkan dan menghapus entri shell di `etc/shells`.

| Tahap | Aksi |
|---|---|
| Instalasi | Menambahkan shell baru ke file `etc/shells` dan mengubah izin file menjadi `644`. |
| Penghapusan | Memakai `sed` untuk menghapus shell dari file. |

**Cara menambahkan:** gunakan variabel `register_shell`. Trigger tidak berbuat apa-apa kecuali variabel ini didefinisikan.

```bash
register_shell="/bin/tcsh /bin/csh"
```

---

## `system-accounts` <a id="system-accounts"></a>

**Tugas:** membuat dan menonaktifkan akun serta grup sistem.

Saat **penghapusan**, akun dinonaktifkan dengan:

- Shell diatur ke `/bin/false`,
- Home diatur ke `/var/empty`,
- Deskripsi ditambah `' - for uninstalled package $pkgname'`.

Contoh hasil: `transmission unprivileged user - for uninstalled package transmission`.

**Cara menambahkan:** trigger ini **hanya** bisa dipakai lewat variabel `system_accounts`. Lihat [Membuat Akun dan Grup Sistem](../06_skrip-dan-layanan/03-akun-sistem.md).

---

## Ringkasan Cepat Bagian Ini

| Trigger | Dipicu oleh |
|---|---|
| `binfmts` | Otomatis (`usr/share/binfmts`) atau variabel `binfmts` |
| `dkms` | `dkms_modules` |
| `hwdb.d-dir` | Otomatis (`/usr/lib/udev/hwdb.d`) |
| `info-files` | File info paket |
| `initramfs-regenerate` | Manual lewat `triggers` |
| `kernel-hooks` | Otomatis jika `kernel_hooks_version` diatur |
| `mkdirs` | `make_dirs` |
| `register-shell` | `register_shell` |
| `system-accounts` | `system_accounts` |

---

## Intinya

- Banyak trigger sistem **tidak berbuat apa-apa** sampai variabel pemicunya (`dkms_modules`, `make_dirs`, `register_shell`, `system_accounts`) didefinisikan.
- Untuk paket DKMS yang butuh initramfs terbarui: tulis `triggers="dkms initramfs-regenerate"` (urutan penting).
- `kernel-hooks` menjalankan skrip dari `etc/kernel.d/<target>`.

---

<!-- nav -->
[← Trigger GTK dan GLib](../09_xbps-triggers/02-trigger-gtk-glib.md) | [Daftar Isi](../DaftarISI.md) | [Trigger Desktop, Bahasa, dan Font →](../09_xbps-triggers/04-trigger-desktop-bahasa-font.md)
