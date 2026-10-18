# Mengecek Rilis Upstream Baru

> **Ringkasan:** `xbps-src` bisa **memeriksa otomatis** apakah upstream merilis versi baru. Jika pengaturan default kurang tepat, kamu bisa menyesuaikannya lewat file `update`.

---

## 1. Perintah Dasar

```bash
./xbps-src update-check <pkgname>
```

Perintah ini membandingkan versi di template dengan versi terbaru di situs upstream.

---

## 2. File `update`

Pada beberapa kasus, aturan bawaan (*default*) perlu ditimpa. Caranya, buat file bernama **`update`** di **direktori yang sama** dengan file `template`:

```
srcpkgs/foo/
├── template
└── update       <- aturan khusus cek versi
```

Isi file `update` adalah penetapan variabel berikut:

| Variabel | Fungsi | Default jika tidak diatur |
|---|---|---|
| `site` | URL tempat nomor versi disebutkan. | `homepage` dan direktori tempat `distfiles` berada. |
| `pkgname` | Nama paket yang dicari oleh pola default. | `pkgname` dari template. |
| `pattern` | Ekspresi reguler (kompatibel **perl**) yang cocok dengan nomor versi. Gunakan `\K` dan `(?=...)` untuk menjangkarkan nomor versi. | pola bawaan |
| `ignore` | Daftar *shell glob* (dipisahkan spasi) untuk nomor versi yang **diabaikan** saat memeriksa versi lebih baru. | - |
| `version` | Nomor versi yang dipakai untuk **dibandingkan** dengan versi upstream. | `version` template |
| `single_directory` | Menonaktifkan deteksi direktori yang berisi satu versi sumber di URL lalu mencari versi baru di direktori sebelahnya. | - |
| `vdprefix` | Ekspresi reguler perl untuk bagian yang **mendahului** angka versi pada direktori versi di URL. | `(\|v\|$pkgname)[-_.]*` |
| `vdsuffix` | Ekspresi reguler perl untuk bagian yang **mengikuti** angka versi pada direktori versi di URL. | `(\|\.x)` |
| `disabled` | Menonaktifkan pengecekan update untuk paket ini (jika pengecekan mustahil atau tidak masuk akal). Isi dengan string alasan. | - |

---

## 3. Contoh

### Mencari versi di dalam tag HTML

```bash
# srcpkgs/foo/update
pattern='<b>\K[\d.]+(?=</b>)'
```

Pola ini cocok dengan nomor versi yang diapit tag `<b>...</b>`.

### Mengabaikan versi beta

```bash
# srcpkgs/foo/update
ignore="*b*"
```

### Versi memakai garis bawah, bukan titik

```bash
# srcpkgs/foo/update
version=${version//./_}
```

Contoh: versi `1.2.3` di template dibandingkan sebagai `1_2_3`.

### Menonaktifkan pengecekan

```bash
# srcpkgs/foo/update
disabled="upstream has no public release listing"
```

---

## Intinya

- Jalankan `./xbps-src update-check <pkgname>` untuk memeriksa versi baru.
- Sesuaikan lewat file `update` jika default salah: `site`, `pattern`, `ignore`, `version`, dan seterusnya.
- Isi `disabled` dengan **alasan** jika pengecekan memang tidak mungkin.

---

<!-- nav -->
[← Repositori](../05_repositori-dan-update/01-repositori.md) | [Daftar Isi](../DaftarISI.md) | [File INSTALL dan REMOVE →](../06_skrip-dan-layanan/01-install-remove.md)
