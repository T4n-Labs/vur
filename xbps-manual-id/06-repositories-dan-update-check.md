# 6. Repositories & Pengecekan Update Upstream

[« Dependencies](05-dependencies.md) · [Daftar Isi](README.md) · Selanjutnya: [Patch & Build Style »](07-patch-dan-build-style.md)

## Repositories

### Repository berdasarkan Branch

Repository global mengambil nama dari branch aktif saat ini, kecuali jika
nama branch-nya `master` — maka repository yang dihasilkan berada di
lingkup global. Skenario penggunaannya: pengguna bisa memperbarui banyak
paket di branch kedua tanpa "mengotori" repository lokal mereka.

### Repository yang Didefinisikan Paket

Cara kedua mendefinisikan repository adalah dengan mengeset variabel
`repository` di sebuah template. Dengan cara ini, maintainer bisa
menentukan repository khusus untuk paket tertentu atau sekelompok paket.
Saat ini dipakai untuk membedakan kelas-kelas paket tertentu.

Nama repository yang valid:

- **`bootstrap`** — Repository untuk paket-paket khusus `xbps-src`.
- **`debug`** — Repository untuk paket yang berisi debug symbol. Hampir
  selalu, paket ini dihasilkan otomatis.
- **`nonfree`** — Repository untuk paket closed source atau berlisensi
  nonfree.

## Mengecek Rilis Upstream Baru

Versi upstream baru bisa dicek otomatis dengan:

```
./xbps-src update-check <pkgname>
```

Dalam beberapa kasus, kamu perlu meng-override default yang sudah masuk
akal dengan mengeset variabel berikut di file `update` (di direktori yang
sama dengan file `template`):

- **`site`** — URL tempat nomor versi disebutkan. Jika kosong, default ke
  `homepage` dan direktori tempat `distfiles` berada.
- **`pkgname`** — Nama paket yang dicek oleh pola default. Jika kosong,
  default ke `pkgname` dari template.
- **`pattern`** — Regular expression (perl-compatible) yang cocok dengan
  nomor versi. Beri anchor pada nomor versi memakai `\K` dan `(?=...)`.
  Contoh: `pattern='<b>\K[\d.]+(?=</b>)'` — ini cocok dengan nomor versi
  yang diapit tag `<b>...</b>`.
- **`ignore`** — Daftar shell glob (dipisah spasi) yang cocok dengan nomor
  versi yang **tidak** diperhitungkan saat mengecek versi lebih baru.
  Contoh: `ignore="*b*"`.
- **`version`** — Nomor versi yang dipakai untuk dibandingkan dengan versi
  upstream. Contoh: `version=${version//./_}`.
- **`single_directory`** — Bisa diset untuk menonaktifkan deteksi
  direktori yang berisi satu versi source di URL, lalu mencari versi baru
  di direktori sekitarnya.
- **`vdprefix`** — Regular expression (perl-compatible) yang cocok dengan
  bagian sebelum bagian numerik dari direktori versi di URL. Default:
  `(|v|$pkgname)[-_.]*`.
- **`vdsuffix`** — Regular expression (perl-compatible) yang cocok dengan
  bagian setelah bagian numerik dari direktori versi di URL. Default:
  `(|\.x)`.
- **`disabled`** — Bisa diset untuk menonaktifkan pengecekan update paket,
  untuk kasus di mana pengecekan tidak mungkin atau tidak masuk akal
  dilakukan. Harus diisi string alasan kenapa dinonaktifkan.
