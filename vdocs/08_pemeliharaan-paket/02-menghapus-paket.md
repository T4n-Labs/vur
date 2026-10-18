# Menghapus Paket

> **Ringkasan:** Menghapus template paket harus dilakukan hati-hati agar tidak merusak paket lain, dan agar sistem pengguna ikut membersihkan paket tersebut.

---

## 1. Sebelum Menghapus Template

| Langkah | Cara |
|---|---|
| Pastikan **tidak ada paket lain** yang bergantung pada paket ini atau subpackage-nya | Cari referensi di semua template: `grep -r '\bpkg\b' srcpkgs/` |
| Pastikan **tidak ada paket** yang bergantung pada **shlibs** yang disediakan paket ini | Periksa `common/shlibs` dan paket yang memakainya |

---

## 2. Saat Menghapus Template

1. **Hapus semua symlink** yang menunjuk ke paket tersebut:
   ```bash
   find srcpkgs/ -lname <pkg>
   ```
   Perintah ini sudah cukup untuk menemukan symlink-nya.
2. **Hapus entri shlibs** dari `common/shlibs` jika paket menyediakan shlibs.
3. **Periksa patch/file yang dipakai bersama.** Sebagian paket memakai patch dan file dari paket lain lewat symlink. Biasanya paket-paket tersebut sebenarnya sama tetapi dipecah untuk menghindari dependensi melingkar (*cyclic dependency*). Pastikan paket yang kamu hapus **bukan sumber** patch/file tersebut.
4. **Hapus template** paket.
5. **Tambahkan** `pkgname<=version_revision` ke variabel **`replaces`** pada template **`removed-packages`**. Semua subpackage yang dihapus juga harus ditambahkan. Ini akan **menghapus paket** dari sistem tempat paket itu terpasang.
6. **Hapus paket dari index repositori**, atau hubungi anggota tim yang bisa melakukannya.

---

## 3. Alur Ringkas

```
Cek dependensi (grep) ─► Cek shlibs ─► Hapus symlink ─► Bersihkan common/shlibs
        ─► Cek patch/file bersama ─► Hapus template
        ─► Tambah ke `replaces` di removed-packages ─► Hapus dari index repositori
```

---

## 4. Contoh Entri di `removed-packages`

```bash
# srcpkgs/removed-packages/template
replaces="
 ...
 foo<=1.0_3
 foo-devel<=1.0_3"
```

> Ini hanya ilustrasi format penambahan entri. Lihat isi template `removed-packages` yang sebenarnya untuk mengikuti format yang berlaku.

---

## Intinya

- Pastikan tidak ada yang bergantung pada paket (termasuk shlibs) sebelum menghapus.
- Hapus symlink, entri `common/shlibs`, dan template.
- Daftarkan paket (dan subpackage-nya) ke `replaces` pada `removed-packages` agar terhapus dari sistem pengguna.
- Hapus dari index repositori atau minta bantuan anggota tim.

---

<!-- nav -->
[← Mengganti Nama Paket](../08_pemeliharaan-paket/01-mengganti-nama-paket.md) | [Daftar Isi](../DaftarISI.md) | [Pengenalan XBPS Triggers →](../09_xbps-triggers/01-pengenalan-trigger.md)
