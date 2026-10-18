# Jenis-jenis Dependensi

> **Ringkasan:** `xbps-src` membedakan dependensi menjadi beberapa jenis: `hostmakedepends`, `makedepends`, `checkdepends`, dan `depends`. Pembedaan ini diperlukan karena `xbps-src` mendukung **cross-compile** dan agar lingkungan build tidak diisi paket yang tidak perlu.

---

## 1. Kenapa Ada Banyak Jenis?

Bayangkan kamu membangun rumah di lokasi lain (target) memakai alat dari bengkelmu (host):

- **Alat tukang** (palu, gergaji) dipakai di bengkel → itu `hostmakedepends`.
- **Bahan bangunan** (bata, semen) harus sesuai dengan rumah yang dibangun → itu `makedepends`.
- **Alat uji** (waterpass) hanya dipakai saat pemeriksaan → itu `checkdepends`.
- **Perabot** yang harus ada saat rumah dihuni → itu `depends`.

---

## 2. Ringkasan Empat Jenis Dependensi

| Variabel | Dipakai kapan | Dipasang ke | Arsitektur |
|---|---|---|---|
| `hostmakedepends` | Saat **build** (program yang *dijalankan*) | master directory | **host** |
| `makedepends` | Saat **build** (library & header untuk di-*link*) | master directory | **target** |
| `checkdepends` | Saat menjalankan **tes** | master directory (seperti `hostmakedepends`) | host |
| `depends` | Saat paket **dijalankan** pengguna | **tidak dipasang**, hanya diperiksa | - |

---

## 3. `hostmakedepends`

Daftar dependensi **host** yang dibutuhkan untuk membangun paket. Dipasang ke master directory. **Tidak perlu menuliskan versi**, karena versi terbaru di `srcpkgs` selalu dipakai.

```bash
hostmakedepends="foo blah"
```

Selama proses build, ada program yang harus **dijalankan di host**, misalnya `yacc` atau kompilator C. Paket yang berisi program-program itu masuk ke `hostmakedepends`, dan dipasang di host saat membangun paket target.

- Sebagian paket sudah menjadi dependensi `base-chroot` sehingga **tidak perlu ditulis**.
- Kadang program yang dibutuhkan untuk build berada di paket **`-devel`**.

> Paket yang dibutuhkan untuk menjalankan skrip `build_style` juga harus didefinisikan lewat `hostmakedepends`.

---

## 4. `makedepends`

Daftar dependensi **target** yang dibutuhkan untuk membangun paket (dipasang ke master directory). Seperti `hostmakedepends`, **tidak perlu versi**.

```bash
makedepends="foo blah"
```

Paket target bisa membutuhkan library untuk di-*link* atau file header. Paket-paket ini masuk ke `makedepends` dan arsitekturnya **sesuai target**, apa pun arsitektur mesin pembangun. Biasanya isinya terutama paket **`-devel`**.

---

## 5. `checkdepends`

Daftar dependensi yang dibutuhkan untuk menjalankan **pemeriksaan (tes)** paket, yaitu skrip atau aturan make dari fungsi `do_check()` di template.

```bash
checkdepends="gtest"
```

`checkdepends` dipakai jika `XBPS_CHECK_PKGS` diatur atau opsi `-Q` diberikan ke `xbps-src`. Dependensi ini dipasang seolah-olah bagian dari `hostmakedepends`.

Contoh paket yang sering masuk `checkdepends`:

| Paket | Alasan |
|---|---|
| `dejagnu` | Dipakai oleh beberapa proyek GNU. |
| `cmocka-devel` | Di-*link* ke binary tes. |
| `dbus` | Memungkinkan `dbus-run-session <perintah-tes>` untuk menyediakan sesi D-Bus bagi aplikasi yang butuh. |
| `git` | Beberapa *test suite* menjalankan perintah `git`. |

---

## 6. `depends`

Daftar dependensi yang dibutuhkan untuk **menjalankan** paket. Dependensi ini **tidak dipasang** ke master directory; hanya diperiksa apakah ada paket biner di repositori lokal yang memenuhi versi yang diminta.

### Pembanding Versi

Boleh memakai pembanding: `<`, `>`, `<=`, `>=`, atau `foo-1.0_1` untuk mencocokkan versi **persis**. Jika tidak ada pembanding (hanya nama paket), otomatis dianggap `>=0`.

```bash
depends="foo blah>=1.0"
```

Aturan lengkap tentang apa yang perlu dan tidak perlu ditulis di `depends` ada di [Dependensi Runtime](02-dependensi-runtime-shlibs-virtual.md).

---

## 7. `conflicts`

Daftar paket yang **bertentangan** dengan paket ini (opsional). Memakai pembanding versi yang sama seperti `depends`. Tanpa pembanding, otomatis `>=0`.

```bash
conflicts="foo blah>=0.42.3"
```

---

## 8. `bootstrap`

Jika diaktifkan, paket sumber dianggap bagian dari proses **bootstrap** dan diperlukan agar bisa membangun paket di chroot. Hanya **sedikit paket** yang perlu mengatur properti ini.

---

## 9. Aturan Praktis Dependensi Build

> Jika sebuah paket dibangun **dengan cara yang persis sama**, ada atau tidaknya paket tertentu di `makedepends` atau `hostmakedepends`, maka paket itu **tidak perlu** ditambahkan sebagai dependensi waktu build.

Dengan kata lain: jangan menambah dependensi "sekadar jaga-jaga".

---

## Contoh Lengkap

```bash
hostmakedepends="pkg-config bison"
makedepends="zlib-devel libpng-devel"
checkdepends="dejagnu"
depends="foo>=1.0"
conflicts="foo-legacy"
```

---

## Intinya

- `hostmakedepends` = alat yang **dijalankan** saat build (arsitektur host).
- `makedepends` = library/header untuk **di-link** (arsitektur target), biasanya `-devel`.
- `checkdepends` = kebutuhan **tes**.
- `depends` = kebutuhan saat paket **dijalankan**; tidak dipasang ke master directory.
- Jangan menambah dependensi yang tidak mengubah hasil build.

---

<!-- nav -->
[← Variabel Opsional: Pembatasan dan Pemeriksaan](../02_dasar-template/07-variabel-opsional-pembatasan-dan-pemeriksaan.md) | [Daftar Isi](../DaftarISI.md) | [Dependensi Runtime, `shlibs`, dan Paket Virtual →](../03_dependensi/02-dependensi-runtime-shlibs-virtual.md)
