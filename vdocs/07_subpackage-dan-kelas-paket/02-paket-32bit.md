# Paket 32-bit

> **Ringkasan:** Paket 32-bit (`lib32`) dibangun **otomatis** ketika builder-nya arsitektur x86 (32-bit). Beberapa variabel bisa dipakai untuk mengubah perilakunya.

---

## 1. Variabel yang Tersedia

| Variabel | Fungsi |
|---|---|
| `lib32depends` | Jika diatur, dependensi yang ditulis di sini **dipakai menggantikan** dependensi hasil deteksi otomatis `xbps-src` dan `depends`. Dependensi **harus** ditulis dengan pembanding versi. |
| `lib32disabled` | Jika diatur, paket 32-bit **tidak akan dibangun**. |
| `lib32files` | File tambahan yang dimasukkan ke paket **32-bit**. Berupa path absolut dipisahkan spasi. |
| `lib32symlinks` | Membuat symlink dari nama file target yang tersimpan di direktori `lib32`. Berisi *basename* file target. |
| `lib32mode` | Jika **tidak diatur**: hanya shared/static library dan file pkg-config yang disalin ke paket 32-bit. Jika diatur ke **`full`**: **semua file** disalin tanpa modifikasi. |

---

## 2. Contoh

```bash
# Dependensi khusus untuk paket 32-bit (wajib pakai versi)
lib32depends="foo>=0 blah<2.0"

# Tambah file ke paket 32-bit
lib32files="/usr/bin/blah /usr/include/blah.h"

# Buat symlink
lib32symlinks="foo"

# Salin semua file ke paket 32-bit
lib32mode=full

# Jangan bangun paket 32-bit sama sekali
lib32disabled=yes
```

---

## 3. Ringkasan Kapan Dipakai

| Kebutuhan | Variabel |
|---|---|
| Dependensi paket 32-bit berbeda dari paket utama | `lib32depends` |
| Paket tidak cocok/tidak perlu versi 32-bit | `lib32disabled` |
| Perlu menambah file ke paket 32-bit | `lib32files` |
| Perlu symlink di direktori `lib32` | `lib32symlinks` |
| Butuh semua file, bukan hanya library | `lib32mode=full` |

---

## Intinya

- Paket 32-bit dibangun otomatis ketika builder x86 32-bit.
- `lib32depends` menimpa dependensi otomatis; `lib32disabled` mematikan pembuatan paket 32-bit.
- `lib32mode=full` menyalin semua file, bukan hanya library dan file pkg-config.

---

<!-- nav -->
[← Subpackage](../07_subpackage-dan-kelas-paket/01-subpackage.md) | [Daftar Isi](../DaftarISI.md) | [Kelas Paket: Development, Data, dan Dokumentasi →](../07_subpackage-dan-kelas-paket/03-paket-development-data-doc.md)
