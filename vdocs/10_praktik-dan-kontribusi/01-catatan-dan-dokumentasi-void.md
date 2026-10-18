# Catatan Penting dan Dokumentasi Khusus Void

> **Ringkasan:** Kumpulan pedoman praktis yang perlu kamu ingat setiap kali membuat atau memperbarui paket, plus cara menulis dokumentasi khusus Void Linux untuk paketmu.

---

## 1. Dokumentasi Khusus Void Linux

Jika kamu ingin mendokumentasikan **detail konfigurasi dan penggunaan paket yang spesifik untuk Void Linux** dan **tidak dibahas oleh dokumentasi upstream**, taruh catatannya di:

```
srcpkgs/<pkgname>/files/README.voidlinux
```

lalu pasang dengan fungsi [`vdoc`](../02_dasar-template/03-fungsi-global.md#vdoc):

```bash
post_install() {
	vdoc "${FILESDIR}/README.voidlinux"
}
```

Hasilnya, file tersebut terpasang di `usr/share/doc/<pkgname>`.

---

## 2. Catatan Penting (Notes)

| # | Aturan | Alasan / Penjelasan |
|---|---|---|
| 1 | Pastikan semua perangkat lunak dikonfigurasi memakai prefix **`/usr`**. | Konsistensi lokasi file di Void Linux. |
| 2 | Binary **selalu** dipasang di **`/usr/bin`**. | Lokasi standar executable. |
| 3 | Man page **selalu** dipasang di **`/usr/share/man`**. | Lokasi standar man page. |
| 4 | Jika perangkat lunak menyediakan **shared library** dan header, kemungkinan besar kamu perlu membuat **paket development** (`-devel`) yang berisi header, static library, dan file pengembangan lain (yang tidak dibutuhkan saat runtime). | Lihat [Kelas Paket: Development](../07_subpackage-dan-kelas-paket/03-paket-development-data-doc.md). |
| 5 | Saat **memperbarui** paket, hati-hati terhadap **SONAME bump**. Periksa file yang terpasang dengan `./xbps-src show-files <pkgname>` sebelum mengirim pembaruan. | SONAME yang naik bisa merusak paket lain yang bergantung padanya. |
| 6 | Pastikan binary **tidak di-strip** oleh perangkat lunak itu sendiri; biarkan `xbps-src` yang melakukannya. | Jika tidak, paket `debug` tidak akan punya simbol debug. |

---

## 3. Checklist Cepat Sebelum Mengirim Paket

| Pemeriksaan | Dibahas di |
|---|---|
| Variabel wajib lengkap (`pkgname`, `version`, `revision`, `short_desc`, `maintainer`, `license`, `homepage`) | [Variabel Wajib](../02_dasar-template/01-variabel-wajib.md) |
| `checksum` sesuai dengan `distfiles` (urutan sama) | [Variabel Opsional: Sumber Kode](../02_dasar-template/04-variabel-opsional-sumber-kode.md) |
| File lisensi disertakan untuk MIT/BSD/ISC/AGPL/X11/custom | [Variabel Wajib](../02_dasar-template/01-variabel-wajib.md) |
| Dependensi benar (`hostmakedepends`, `makedepends`, `depends`) | [Jenis-jenis Dependensi](../03_dependensi/01-jenis-dependensi.md) |
| Prefix `/usr`, binary di `/usr/bin`, man page di `/usr/share/man` | Bagian ini |
| Library dipecah menjadi `<n>` dan `<n>-devel` | [Aturan Penamaan](../01_pengenalan/03-penamaan-paket.md) |
| Subpackage punya symlink di `srcpkgs` | [Subpackage](../07_subpackage-dan-kelas-paket/01-subpackage.md) |
| Binary tidak di-strip oleh upstream | Bagian ini |
| Paket berhasil dibangun: `./xbps-src pkg <pkgname>` | [Apa Itu XBPS Source Packages?](../01_pengenalan/01-apa-itu-xbps-src.md) |

---

## Intinya

- Dokumentasi khusus Void ditulis di `files/README.voidlinux` dan dipasang dengan `vdoc`.
- Ingat enam aturan praktis: prefix `/usr`, binary di `/usr/bin`, man page di `/usr/share/man`, paket `-devel`, awas SONAME bump, dan jangan strip manual.

---

<!-- nav -->
[← Trigger Desktop, Bahasa, dan Font](../09_xbps-triggers/04-trigger-desktop-bahasa-font.md) | [Daftar Isi](../DaftarISI.md) | [Kontribusi via Git dan Bantuan →](../10_praktik-dan-kontribusi/02-kontribusi-via-git.md)
