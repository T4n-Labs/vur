# Mengganti Nama Paket

> **Ringkasan:** Mengganti nama paket tidak sesederhana mengubah nama folder. Pengguna yang sudah memasang paket dengan nama lama harus tetap mendapat pembaruan ke paket dengan nama baru. Caranya memakai **paket transisi**.

---

## 1. Kenapa Rumit?

Jika kamu hanya mengganti nama paket, sistem pengguna yang masih memasang **nama lama** tidak akan pernah menerima pembaruan, karena nama itu sudah "hilang" dari repositori.

Solusinya: pertahankan nama lama sebagai **paket kosong (transitional dummy package)** yang bergantung pada paket baru.

---

## 2. Langkah-langkah

1. **Buat subpackage kosong dengan nama lama**, yang bergantung pada paket baru.
   - Ini diperlukan agar pembaruan sampai ke sistem yang sudah memasang paket lama.
   - Subpackage ini harus menjadi **subpackage dari paket baru**.
   - Jika nomor versi paket transisi **menurun**, tambahkan entri `reverts` padanya.
2. **Tambahkan** `" (transitional dummy package)"` di akhir `short_desc` paket transisi.
3. **Sunting referensi** ke paket tersebut di template lain dan di `common/shlibs`.
4. **Atur** `replaces="old-name>=0"` pada paket baru.

---

## 3. Contoh Ilustrasi

Misalkan `oldfoo` diganti namanya menjadi `newfoo`:

```bash
# srcpkgs/newfoo/template
pkgname=newfoo
version=2.0
revision=1
short_desc="Foo program"
replaces="oldfoo>=0"
# ...variabel lain...

# Paket transisi dengan nama lama (paket kosong, hanya bergantung pada paket baru)
oldfoo_package() {
	short_desc+=" (transitional dummy package)"
	depends="newfoo>=${version}_${revision}"
}
```

Lalu buat symlink agar template subpackage ditemukan:

```bash
cd srcpkgs
ln -s newfoo oldfoo
```

> **Peringatan:** contoh di atas hanya menggambarkan struktur umumnya. Manual tidak merinci cara persis membuat paket yang benar-benar kosong, jadi ikuti pola paket transisi yang sudah ada di repositori `void-packages` sebelum mengirim perubahan.

---

## 4. Checklist

| Langkah | Selesai? |
|---|---|
| Subpackage kosong dengan nama lama dibuat (subpackage dari paket baru) | ☐ |
| `reverts` ditambahkan jika versi paket transisi menurun | ☐ |
| `short_desc` diberi `" (transitional dummy package)"` | ☐ |
| Referensi di template lain dan `common/shlibs` diperbarui | ☐ |
| `replaces="old-name>=0"` diatur di paket baru | ☐ |

---

## Intinya

- Pertahankan nama lama sebagai paket transisi kosong yang bergantung pada paket baru.
- Beri keterangan `(transitional dummy package)` pada `short_desc`.
- Perbarui semua referensi, dan atur `replaces` pada paket baru.

---

<!-- nav -->
[← Kelas Paket: Font](../07_subpackage-dan-kelas-paket/07-paket-font.md) | [Daftar Isi](../DaftarISI.md) | [Menghapus Paket →](../08_pemeliharaan-paket/02-menghapus-paket.md)
