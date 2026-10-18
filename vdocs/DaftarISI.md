# Dokumentasi XBPS Source Packages (Void Linux)

> Panduan lengkap membuat paket untuk **Void Linux** memakai `xbps-src`, disusun ulang dalam **bahasa Indonesia** dengan urutan belajar dari **dasar ke lanjutan**, agar mudah dipahami pemula.

Dokumentasi ini diadaptasi dari `Manual.md` repositori [`void-linux/void-packages`](https://github.com/void-linux/void-packages/blob/master/Manual.md). Seluruh topik di manual aslinya tercakup. Kode, nama variabel, dan perintah dibiarkan dalam bahasa aslinya, sedangkan penjelasannya berbahasa Indonesia.

## Cara Membaca

| Kamu adalah... | Mulai dari |
|---|---|
| Pemula total | Baca **berurutan** dari Bagian 1 sampai Bagian 4, lalu lanjut sesuai kebutuhan. |
| Sudah paham dasar template | Langsung ke Bagian 3 (Dependensi) dan Bagian 4 (Proses Build). |
| Mencari satu topik tertentu | Gunakan **Peta Topik** di [Kesimpulan](kesimpulan.md#4-peta-topik). |
| Ingin merujuk cepat | Lihat tabel ringkas di akhir masing-masing halaman dan bagian **Intinya**. |

Setiap halaman diawali **Ringkasan**, diakhiri **Intinya**, dan punya tautan navigasi *Sebelumnya / Berikutnya* di bagian bawah.

## Struktur Folder

```
DaftarISI.md
├── 01_pengenalan/
│   ├── 01-apa-itu-xbps-src.md
│   ├── 02-fase-build.md
│   └── 03-penamaan-paket.md
├── 02_dasar-template/
│   ├── 01-variabel-wajib.md
│   ├── 02-variabel-global.md
│   ├── 03-fungsi-global.md
│   ├── 04-variabel-opsional-sumber-kode.md
│   ├── 05-variabel-opsional-build.md
│   ├── 06-variabel-opsional-metadata.md
│   └── 07-variabel-opsional-pembatasan-dan-pemeriksaan.md
├── 03_dependensi/
│   ├── 01-jenis-dependensi.md
│   └── 02-dependensi-runtime-shlibs-virtual.md
├── 04_proses-build/
│   ├── 01-build-style.md
│   ├── 02-build-helper.md
│   ├── 03-fungsi-template.md
│   ├── 04-patch.md
│   └── 05-opsi-build.md
├── 05_repositori-dan-update/
│   ├── 01-repositori.md
│   └── 02-cek-rilis-upstream.md
├── 06_skrip-dan-layanan/
│   ├── 01-install-remove.md
│   ├── 02-install-remove-msg.md
│   ├── 03-akun-sistem.md
│   └── 04-layanan-runit.md
├── 07_subpackage-dan-kelas-paket/
│   ├── 01-subpackage.md
│   ├── 02-paket-32bit.md
│   ├── 03-paket-development-data-doc.md
│   ├── 04-paket-python.md
│   ├── 05-paket-go.md
│   ├── 06-paket-haskell.md
│   └── 07-paket-font.md
├── 08_pemeliharaan-paket/
│   ├── 01-mengganti-nama-paket.md
│   └── 02-menghapus-paket.md
├── 09_xbps-triggers/
│   ├── 01-pengenalan-trigger.md
│   ├── 02-trigger-gtk-glib.md
│   ├── 03-trigger-sistem.md
│   └── 04-trigger-desktop-bahasa-font.md
├── 10_praktik-dan-kontribusi/
│   ├── 01-catatan-dan-dokumentasi-void.md
│   └── 02-kontribusi-via-git.md
└── kesimpulan.md
```

## Peta Jalan Belajar

| Tahap | Bagian | Hasil yang diharapkan |
|---|---|---|
| **Dasar** | 1, 2 | Paham apa itu template, bisa menulis template minimal dan membangunnya. |
| **Menengah** | 3, 4, 5 | Bisa mengatur dependensi, memilih build style, menambal sumber, dan memakai opsi build. |
| **Lanjutan** | 6, 7, 8 | Bisa membuat subpackage, layanan runit, akun sistem, dan memaketkan Python/Go/Haskell/font. |
| **Mahir** | 9, 10 | Memahami trigger otomatis dan siap berkontribusi ke repositori. |

## Daftar Isi

### Bagian 1: Pengenalan

_Konsep dasar XBPS, template, `xbps-src`, fase build, dan aturan penamaan paket._

- [Apa Itu XBPS Source Packages?](01_pengenalan/01-apa-itu-xbps-src.md): Mengenal "resep" pembuatan paket di Void Linux (disebut *template*), alat yang memprosesnya (`xbps-src`), dan hasil akhirnya berupa paket `.xbps`.
- [Fase Build Paket](01_pengenalan/02-fase-build.md): Membangun paket bukan satu langkah tunggal, melainkan rangkaian **fase** yang berurutan.
- [Aturan Penamaan Paket](01_pengenalan/03-penamaan-paket.md): Void Linux punya aturan baku untuk menamai paket berdasarkan jenisnya: library, modul bahasa pemrograman, *binding*, atau program biasa.

### Bagian 2: Dasar-dasar Template

_Variabel wajib, variabel global, fungsi bantu `v...`, dan seluruh variabel opsional._

- [Variabel Wajib](02_dasar-template/01-variabel-wajib.md): Tujuh variabel yang **harus** ada di setiap template: `pkgname`, `version`, `revision`, `short_desc`, `maintainer`, `license`, dan `homepage`.
- [Variabel Global](02_dasar-template/02-variabel-global.md): Variabel yang **sudah disediakan otomatis oleh `xbps-src`** dan bisa langsung dipakai di template mana pun.
- [Fungsi Global (Fungsi Bantu `v...`)](02_dasar-template/03-fungsi-global.md): Kumpulan fungsi bantu dari `xbps-src` untuk memasang, menyalin, dan memindahkan file ke dalam paket dengan mudah.
- [Variabel Opsional: Sumber Kode](02_dasar-template/04-variabel-opsional-sumber-kode.md): Variabel untuk mengatur **dari mana** kode sumber diunduh, bagaimana diverifikasi, dan **di mana** ia diekstrak.
- [Variabel Opsional: Konfigurasi Build](02_dasar-template/05-variabel-opsional-build.md): Variabel yang mengatur **cara paket dikonfigurasi, dikompilasi, dites, dan dipasang**.
- [Variabel Opsional: Metadata dan File Paket](02_dasar-template/06-variabel-opsional-metadata.md): Variabel yang mengatur **informasi tambahan paket** (kategori, alternatif, revert), **file konfigurasi**, **direktori yang dibuat saat pemasangan**, dan hal-hal yang berkaitan dengan paket biner hasil build.
- [Variabel Opsional: Pembatasan dan Pemeriksaan](02_dasar-template/07-variabel-opsional-pembatasan-dan-pemeriksaan.md): Variabel untuk **membatasi build** (arsitektur, cross-compile, paket rusak, paket terbatas) dan untuk **menyesuaikan pemeriksaan otomatis** `xbps-src` (strip, PIE, dependensi, izin file).

### Bagian 3: Dependensi

_Jenis dependensi (host, make, check, runtime), `shlibs`, dan paket virtual._

- [Jenis-jenis Dependensi](03_dependensi/01-jenis-dependensi.md): `xbps-src` membedakan dependensi menjadi beberapa jenis: `hostmakedepends`, `makedepends`, `checkdepends`, dan `depends`.
- [Dependensi Runtime, `shlibs`, dan Paket Virtual](03_dependensi/02-dependensi-runtime-shlibs-virtual.md): Memahami **apa saja yang perlu** dan **tidak perlu** ditulis di `depends`, bagaimana `xbps-src` mendeteksi library secara otomatis lewat berkas `common/shlibs`, dan bagaimana dependensi **virtual** bekerja.

### Bagian 4: Proses Build

_Build style, build helper, fungsi hook, patch, dan opsi build._

- [Build Style](04_proses-build/01-build-style.md): `build_style` memberi tahu `xbps-src` **cara membangun dan memasang** paketmu.
- [Build Helper](04_proses-build/02-build-helper.md): `build_helper` memuat potongan skrip shell yang menyiapkan **lingkungan kerja** yang cocok untuk kelompok paket tertentu, terutama saat **cross-compile**.
- [Fungsi di Template (Hook Fase Build)](04_proses-build/03-fungsi-template.md): Kamu bisa mengubah perilaku unduh, kompilasi, dan pemasangan dengan mendefinisikan **fungsi** di template.
- [Menangani Patch](04_proses-build/04-patch.md): *Patch* adalah perubahan kecil pada kode sumber upstream, biasanya untuk memperbaiki bug atau agar bisa dikompilasi dengan perangkat lunak yang lebih baru.
- [Opsi Build (Build Options)](04_proses-build/05-opsi-build.md): Satu paket bisa dibangun dengan fitur yang berbeda-beda (misalnya dengan atau tanpa dukungan gambar PNG).

### Bagian 5: Repositori dan Update

_Menentukan repositori paket dan mengecek rilis upstream baru._

- [Repositori](05_repositori-dan-update/01-repositori.md): Ada dua cara menentukan **ke repositori mana** paket hasil build akan ditempatkan: berdasarkan **branch git** dan berdasarkan variabel **`repository`** di template.
- [Mengecek Rilis Upstream Baru](05_repositori-dan-update/02-cek-rilis-upstream.md): `xbps-src` bisa **memeriksa otomatis** apakah upstream merilis versi baru.

### Bagian 6: Skrip Pemasangan dan Layanan

_INSTALL/REMOVE, pesan pemasangan, akun sistem, dan layanan runit._

- [File INSTALL dan REMOVE](06_skrip-dan-layanan/01-install-remove.md): Skrip shell yang dijalankan **saat paket biner dipasang, diperbarui, atau dihapus** di sistem pengguna.
- [File INSTALL.msg dan REMOVE.msg](06_skrip-dan-layanan/02-install-remove-msg.md): File teks sederhana untuk menampilkan **pesan penting** kepada pengguna setelah pemasangan atau sebelum penghapusan paket.
- [Membuat Akun dan Grup Sistem saat Runtime](06_skrip-dan-layanan/03-akun-sistem.md): Banyak daemon (layanan latar belakang) sebaiknya berjalan sebagai **pengguna sistem khusus** yang tidak punya hak istimewa.
- [Menulis Layanan runit](06_skrip-dan-layanan/04-layanan-runit.md): Void Linux memakai **runit** untuk *booting* dan pengawasan (*supervision*) layanan.

### Bagian 7: Subpackage dan Kelas Paket

_Subpackage, paket 32-bit, development/data/doc, Python, Go, Haskell, dan font._

- [Subpackage](07_subpackage-dan-kelas-paket/01-subpackage.md): Satu template bisa menghasilkan **beberapa paket biner sekaligus**.
- [Paket 32-bit](07_subpackage-dan-kelas-paket/02-paket-32bit.md): Paket 32-bit (`lib32`) dibangun **otomatis** ketika builder-nya arsitektur x86 (32-bit).
- [Kelas Paket: Development, Data, dan Dokumentasi](07_subpackage-dan-kelas-paket/03-paket-development-data-doc.md): Tiga jenis subpackage yang paling sering dijumpai: **`-devel`** (file pengembangan), **`-data`** (data besar), dan **`-doc`** (dokumentasi).
- [Kelas Paket: Python](07_subpackage-dan-kelas-paket/04-paket-python.md): Aturan khusus untuk memaketkan modul Python: pilihan *build style*, pemetaan dependensi, dan variabel pengatur *byte-compile*.
- [Kelas Paket: Go](07_subpackage-dan-kelas-paket/05-paket-go.md): Paket Go sebaiknya dibangun dengan build style `go`.
- [Kelas Paket: Haskell](07_subpackage-dan-kelas-paket/06-paket-haskell.md): Paket Haskell bisa dibangun dengan build style `cabal` atau `haskell-stack`.
- [Kelas Paket: Font](07_subpackage-dan-kelas-paket/07-paket-font.md): Paket font adalah jenis paket yang paling sederhana.

### Bagian 8: Pemeliharaan Paket

_Cara mengganti nama dan menghapus paket dengan aman._

- [Mengganti Nama Paket](08_pemeliharaan-paket/01-mengganti-nama-paket.md): Mengganti nama paket tidak sesederhana mengubah nama folder.
- [Menghapus Paket](08_pemeliharaan-paket/02-menghapus-paket.md): Menghapus template paket harus dilakukan hati-hati agar tidak merusak paket lain, dan agar sistem pengguna ikut membersihkan paket tersebut.

### Bagian 9: XBPS Triggers

_Semua 25 trigger bawaan: fungsi, perintah, dan cara penambahannya._

- [Pengenalan XBPS Triggers](09_xbps-triggers/01-pengenalan-trigger.md): *Trigger* adalah potongan skrip siap pakai dari paket `xbps-triggers` yang otomatis ditambahkan ke skrip `INSTALL`/`REMOVE` sebuah paket, untuk menangani tugas rutin sistem seperti memperbarui cache ikon, mendaftarkan shell, atau meng-compile modul kernel.
- [Trigger GTK dan GLib](09_xbps-triggers/02-trigger-gtk-glib.md): Trigger yang mengurus cache dan database untuk ekosistem GTK/GNOME: GConf, GDK Pixbuf, GIO, GSettings, ikon GTK, modul input method (IM), dan Pango.
- [Trigger Sistem](09_xbps-triggers/03-trigger-sistem.md): Trigger yang mengurus hal-hal tingkat sistem: format biner (binfmt), modul kernel (DKMS), initramfs, hook kernel, database perangkat keras, file info, direktori, shell, dan akun sistem.
- [Trigger Desktop, Bahasa, dan Font](09_xbps-triggers/04-trigger-desktop-bahasa-font.md): Trigger untuk metadata aplikasi desktop (AppStream, MIME, database desktop), kode Python, TeX Live, font X11, dan katalog SGML/XML.

### Bagian 10: Praktik Baik dan Kontribusi

_Catatan penting, dokumentasi khusus Void, kontribusi via git, dan bantuan._

- [Catatan Penting dan Dokumentasi Khusus Void](10_praktik-dan-kontribusi/01-catatan-dan-dokumentasi-void.md): Kumpulan pedoman praktis yang perlu kamu ingat setiap kali membuat atau memperbarui paket, plus cara menulis dokumentasi khusus Void Linux untuk paketmu.
- [Kontribusi via Git dan Bantuan](10_praktik-dan-kontribusi/02-kontribusi-via-git.md): Cara mengirim paket atau perbaikanmu ke repositori `void-packages` lewat GitHub, cara menjaga fork-mu tetap mutakhir, dan ke mana bertanya jika buntu.

### Penutup

- [Kesimpulan](kesimpulan.md): rangkuman, alur kerja lengkap, template kerangka, peta topik, dan glosarium.
