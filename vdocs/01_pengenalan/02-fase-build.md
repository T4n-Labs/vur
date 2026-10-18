# Fase Build Paket

> **Ringkasan:** Membangun paket bukan satu langkah tunggal, melainkan rangkaian **fase** yang berurutan. Memahami fase ini membuatmu tahu *kapan* dan *di mana* sebuah variabel atau fungsi bekerja.

---

## 1. Alur Fase

```
setup → fetch → extract → patch → configure → build → check → install → pkg → clean
```

Bayangkan seperti proses membuat kue: siapkan dapur → belanja bahan → buka kemasan → perbaiki bahan yang cacat → campur adonan → panggang → cicip (tes) → tata di kotak → kemas → bersihkan dapur.

---

## 2. Penjelasan Tiap Fase

| Fase | Apa yang terjadi |
|---|---|
| **`setup`** | Menyiapkan lingkungan untuk membangun paket. |
| **`fetch`** | Mengunduh kode sumber sesuai variabel `distfiles`, atau lewat fungsi `do_fetch()`. |
| **`extract`** | Mengekstrak file `distfiles` ke direktori `$wrksrc` (tempat paket dikompilasi), atau menjalankan fungsi `do_extract()`. |
| **`patch`** | Menerapkan semua patch yang ada di folder `patches` milik paket. Bisa juga dipakai untuk operasi lain sebelum konfigurasi. |
| **`configure`** | Menjalankan konfigurasi paket sumber, misalnya skrip `configure` ala GNU. |
| **`build`** | Mengompilasi atau menyiapkan file sumber memakai `make` atau metode lain yang kompatibel. |
| **`check`** | Fase **opsional**. Memeriksa hasil `build` dengan menjalankan *test suite* bawaan paket. |
| **`install`** | Memasang file paket ke direktori tujuan `<masterdir>/destdir/<pkgname>-<version>` lewat `make install` atau metode lain. |
| **`pkg`** | Membuat **paket biner** dari isi `destdir` dan mendaftarkannya ke repositori lokal. |
| **`clean`** | Membersihkan sisa-sisa build (jika didefinisikan). |

---

## 3. Lebih Dalam tentang Fase `check`

Fase `check` menjalankan tes bawaan paket. Beberapa aturan dari manual:

- Jika fungsi `do_check` bawaan dari *build style* ternyata **tidak melakukan apa-apa**, maka template harus:
  - mengatur `make_check_target` dan/atau `make_check_args` dengan benar, **atau**
  - mendefinisikan fungsi `do_check` sendiri.
- Jika tes **terlalu lama** atau **tidak bisa dijalankan di semua lingkungan**:
  - atur `make_check` ke nilai yang sesuai, **atau**
  - ubah `do_check` supaya hanya menjalankan sebagian tes, kecuali jika `XBPS_CHECK_PKGS` bernilai `full`.

> Detail variabel `make_check` ada di [Variabel Opsional: Konfigurasi Build](../02_dasar-template/05-variabel-opsional-build.md).

---

## 4. Menjalankan Satu Fase Saja

`xbps-src` mendukung menjalankan **hanya satu fase tertentu**. Kalau fase itu sukses, ia akan **dilewati** pada proses berikutnya, **kecuali** direktori kerjanya (`${wrksrc}`) dihapus dengan `xbps-src clean`.

> **Tips pemula:** Fitur ini berguna saat debugging. Misalnya, kamu bisa berhenti di fase `configure` untuk memeriksa hasilnya tanpa harus mengulang unduhan dan ekstraksi dari awal.

---

## 5. Hubungan Fase dengan Fungsi di Template

Setiap fase punya fungsi yang bisa kamu isi sendiri (misalnya `do_build()`, `pre_configure()`, `post_install()`). Daftar lengkap dan urutannya dibahas di [Fungsi di Template](../04_proses-build/03-fungsi-template.md).

---

## Intinya

- Ada 10 fase: `setup`, `fetch`, `extract`, `patch`, `configure`, `build`, `check`, `install`, `pkg`, `clean`.
- `check` bersifat opsional dan bisa diatur lewat `make_check`.
- Fase yang sudah sukses akan dilewati sampai kamu menjalankan `xbps-src clean`.

---

<!-- nav -->
[← Apa Itu XBPS Source Packages?](../01_pengenalan/01-apa-itu-xbps-src.md) | [Daftar Isi](../DaftarISI.md) | [Aturan Penamaan Paket →](../01_pengenalan/03-penamaan-paket.md)
