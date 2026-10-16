# 15. Mengganti Nama & Menghapus Paket

[« Kelas Paket](14-kelas-paket.md) · [Daftar Isi](README.md) · Selanjutnya: [XBPS Triggers »](16-xbps-triggers.md)

## Mengganti Nama Paket

- Buat subpackage kosong dengan nama lama, yang bergantung pada paket
  baru. Ini diperlukan untuk menyediakan update bagi sistem yang sudah
  memasang paket lama. Ini harus menjadi subpackage dari paket baru.
  Ketika nomor versi paket transisi ini menurun, tambahkan entri
  `reverts` ke dalamnya.
- Tambahkan `" (transitional dummy package)"` ke `short_desc` paket
  tersebut.
- Edit referensi ke paket di template lain dan di `common/shlibs`.
- Set `replaces="old-name>=0"` pada paket baru.

## Menghapus Paket

Berikut daftar hal yang harus dilakukan untuk memastikan penghapusan
template paket (dan secara ekstensi, paket binernya) dari repository Void
Linux berjalan lancar.

### Sebelum menghapus template paket

- Pastikan tidak ada paket lain yang bergantung padanya atau salah satu
  subpackage-nya. Untuk memeriksa, cari referensi ke paket tersebut di
  template lain dengan `grep -r '\bpkg\b' srcpkgs/`.
- Pastikan tidak ada paket lain yang bergantung pada shlib yang
  disediakannya.

### Saat menghapus template paket

- Hapus semua symlink yang menunjuk ke paket tersebut. Perintah
  `find srcpkgs/ -lname <pkg>` biasanya cukup untuk menemukannya.
- Jika paket menyediakan shlibs, pastikan menghapusnya dari
  `common/shlibs`.
- Beberapa paket memakai patch dan file dari paket lain lewat symlink;
  umumnya paket-paket ini sebenarnya sama tapi dipecah untuk menghindari
  dependency siklikal. Pastikan paket yang kamu hapus bukan sumber dari
  patch/file tersebut.
- Hapus template paket.
- Tambahkan `pkgname<=version_revision` ke variabel `replaces` pada
  template `removed-packages`. Semua subpackage yang dihapus juga harus
  ditambahkan. Ini akan menghapus paket dari sistem tempat paket tersebut
  terpasang.
- Hapus paket dari index repository, atau hubungi anggota tim yang bisa
  melakukannya.
