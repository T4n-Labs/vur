# Aturan Penamaan Paket

> **Ringkasan:** Void Linux punya aturan baku untuk menamai paket berdasarkan jenisnya: library, modul bahasa pemrograman, *binding*, atau program biasa.

---

## 1. Library (Pustaka)

**Library** adalah paket yang menyediakan *shared object* (`*.so`) di `/usr/lib`.

### Aturan Nama

Pakai **nama upstream** apa adanya, dengan satu pengecualian:

- Jika paket tersebut adalah **subpackage dari aplikasi *front end*** dan menyediakan *shared object* yang dipakai paket induk serta library pihak ketiga lainnya, maka namanya diberi awalan **`lib`**.
  - Contoh: `wireshark` → subpackage `libwireshark`.
  - Pengecualian dari aturan ini: jika sebuah *executable* hanya dipakai untuk membangun paket tersebut, executable itu dipindahkan ke paket `-devel`.

### Wajib Dipecah Dua

Library harus dipecah menjadi dua subpackage: **`<n>`** dan **`<n>-devel`**.

| Paket | Isi |
|---|---|
| `<n>` | Hanya bagian yang dibutuhkan untuk **menjalankan** program yang terhubung (*linked*) ke library ini. |
| `<n>-devel` | Semua file yang dibutuhkan untuk **mengompilasi** paket lain terhadap library ini (header, dll). |

Jika library itu sendiri adalah subpackage, paket pengembangannya diberi nama **`lib<n>-devel`**.

---

## 2. Modul Bahasa (*Language Modules*)

**Modul bahasa** adalah ekstensi untuk bahasa skrip atau bahasa terkompilasi. Paket jenis ini **tidak menyediakan executable sendiri**, tapi bisa dipakai paket lain yang ditulis dengan bahasa yang sama.

### Format Nama

```
<bahasa>-<n>
```

Aturan tambahan:

- Jika sebuah paket menyediakan **modul sekaligus executable**, pecah menjadi:
  - paket executable bernama `<n>`
  - paket modul bernama `<bahasa>-<n>`
- Jika nama paket **sudah diawali nama bahasanya**, awalan bahasa boleh dibuang.
- **Singkatan** nama bahasa **tidak boleh** menggantikan awalan bahasa.

**Contoh:** `perl-URI`, `python3-pyside2`

---

## 3. Binding Bahasa (*Language Bindings*)

**Binding** adalah paket yang memungkinkan program atau library punya **ekstensi/plugin** yang ditulis dalam bahasa tertentu.

### Format Nama

```
<n>-<bahasa>
```

**Contoh:** `gimp-python3`, `irssi-perl`

> **Cara mengingat:** pada *modul*, nama bahasa ada di **depan** (`perl-URI`). Pada *binding*, nama bahasa ada di **belakang** (`irssi-perl`).

---

## 4. Program

**Program** meletakkan executable di `/usr/bin` (atau, pada kasus yang sangat khusus, di direktori `.../bin` lainnya).

### Aturan Nama

- Gunakan **nama paket upstream**.
- Void Linux **tidak otomatis mengubah nama menjadi huruf kecil**, berbeda dengan banyak distro lain.
- Aturan praktis: jika file `tar.gz` paket tersebut mengandung **huruf kapital**, nama paket juga memakai huruf kapital. Jika tidak, nama paket memakai huruf kecil.

Program boleh dipecah menjadi paket program dan paket library. Paket programnya dinamai seperti aturan di atas, sedangkan paket library-nya diberi awalan `lib` (lihat bagian [Library](#1-library-pustaka)).

---

## Ringkasan Cepat

| Jenis paket | Format nama | Contoh |
|---|---|---|
| Library | `<n>` dan `<n>-devel` (atau `lib<n>` jika subpackage) | `libwireshark` |
| Modul bahasa | `<bahasa>-<n>` | `perl-URI`, `python3-pyside2` |
| Binding bahasa | `<n>-<bahasa>` | `gimp-python3`, `irssi-perl` |
| Program | nama upstream | `wireshark` |

---

## Intinya

- Library selalu dipecah menjadi paket runtime dan paket `-devel`.
- Modul: bahasa di depan. Binding: bahasa di belakang.
- Nama program mengikuti upstream, termasuk huruf besar-kecilnya.

---

<!-- nav -->
[← Fase Build Paket](../01_pengenalan/02-fase-build.md) | [Daftar Isi](../DaftarISI.md) | [Variabel Wajib →](../02_dasar-template/01-variabel-wajib.md)
