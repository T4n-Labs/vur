# File INSTALL dan REMOVE

> **Ringkasan:** Skrip shell yang dijalankan **saat paket biner dipasang, diperbarui, atau dihapus** di sistem pengguna. Bukan saat build.

---

## 1. Kapan Skrip Ini Berjalan?

File `INSTALL` dan `REMOVE` berisi potongan skrip shell yang menjalankan aksi tertentu pada tahap tertentu ketika **paket biner** dipasang, diperbarui, atau dihapus.

Lokasi file di dalam folder paket:

```
srcpkgs/foo/
├── template
├── INSTALL
└── REMOVE
```

---

## 2. Variabel yang Selalu Tersedia

`xbps` selalu mengatur variabel berikut saat skrip dijalankan:

| Variabel | Arti |
|---|---|
| `$ACTION` | Untuk menentukan aksi: `pre` atau `post`. |
| `$PKGNAME` | Nama paket. |
| `$VERSION` | Versi paket. |
| `$UPDATE` | `yes` jika paket sedang **diperbarui**; `no` jika sedang **dipasang** atau **dihapus**. |
| `$CONF_FILE` | Path lengkap ke `xbps.conf`. |
| `$ARCH` | Arsitektur target tempat skrip berjalan. |

---

## 3. Contoh Skrip

```sh
# INSTALL
case "$ACTION" in
pre)
	# Actions to execute before the package files are unpacked.
	...
	;;
post)
	if [ "$UPDATE" = "yes" ]; then
		# actions to execute if package is being updated.
		...
	else
		# actions to execute if package is being installed.
		...
	fi
	;;
esac
```

Penjelasan alur:

| Tahap | Kapan | Contoh isi |
|---|---|---|
| `pre` | **Sebelum** file paket diekstrak | Menyiapkan sesuatu sebelum file dipasang. |
| `post` + `UPDATE=yes` | **Setelah** paket **diperbarui** | Migrasi data/konfigurasi lama. |
| `post` + `UPDATE=no` | **Setelah** paket **dipasang pertama kali** | Inisialisasi awal. |

---

## 4. INSTALL/REMOVE untuk Subpackage

Subpackage juga bisa punya `INSTALL` dan `REMOVE` sendiri. Buat dengan nama:

```
srcpkgs/<pkgname>/<subpkg>.INSTALL
srcpkgs/<pkgname>/<subpkg>.REMOVE
```

---

## 5. Catatan Penting

> **Catatan 1:** selalu gunakan **path relatif terhadap direktori kerja saat ini**. Jika tidak, skrip yang tidak bisa dijalankan lewat `chroot(2)` tidak akan bekerja dengan benar.

> **Catatan 2:** **jangan** memakai skrip INSTALL/REMOVE untuk mencetak pesan. Untuk itu gunakan [`INSTALL.msg` dan `REMOVE.msg`](02-install-remove-msg.md).

---

## Intinya

- `INSTALL`/`REMOVE` berjalan di sistem pengguna saat paket dipasang/diperbarui/dihapus.
- Gunakan `$ACTION` (`pre`/`post`) dan `$UPDATE` (`yes`/`no`) untuk membedakan situasi.
- Selalu pakai path relatif.
- Untuk pesan ke pengguna, pakai `INSTALL.msg` / `REMOVE.msg`.

---

<!-- nav -->
[← Mengecek Rilis Upstream Baru](../05_repositori-dan-update/02-cek-rilis-upstream.md) | [Daftar Isi](../DaftarISI.md) | [File INSTALL.msg dan REMOVE.msg →](../06_skrip-dan-layanan/02-install-remove-msg.md)
