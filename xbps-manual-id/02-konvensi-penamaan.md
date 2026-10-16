# 2. Konvensi Penamaan Paket

[« Pengantar & Fase Build](01-pengantar-dan-fase-build.md) · [Daftar Isi](README.md) · Selanjutnya: [Fungsi & Variabel Global »](03-fungsi-dan-variabel-global.md)

## Libraries (Pustaka)

Library adalah paket yang menyediakan *shared object* (`*.so`) di
`/usr/lib`. Umumnya diberi nama sesuai nama paket upstream, dengan
pengecualian berikut:

- Jika paket tersebut adalah subpackage dari sebuah aplikasi front-end dan
  menyediakan shared object yang dipakai oleh paket utama maupun library
  pihak ketiga lainnya, maka harus diberi awalan `lib`. Pengecualian dari
  aturan ini: jika sebuah executable hanya dipakai untuk *membangun* paket
  tersebut, executable itu dipindah ke paket `-devel`.

  Contoh: `wireshark` → subpackage `libwireshark`

Library harus dipecah menjadi dua subpackage: `<n>` dan `<n>-devel`.

- **`<n>`** hanya berisi bagian yang dibutuhkan untuk menjalankan program yang
  telah di-link.
- **`<n>-devel`** berisi semua file yang dibutuhkan untuk mengompilasi
  program lain agar dapat di-link terhadap library ini. Jika library
  tersebut adalah subpackage, paket development-nya harus diberi nama
  `lib<n>-devel`.

## Language Modules (Modul Bahasa)

Modul bahasa adalah ekstensi untuk bahasa script atau bahasa terkompilasi.
Paket jenis ini tidak menyediakan executable apa pun, tapi bisa dipakai oleh
paket lain yang ditulis dalam bahasa yang sama.

Konvensi penamaan:

```
<language>-<n>
```

Jika sebuah paket menyediakan **modul sekaligus executable**, paket tersebut
harus dipecah menjadi paket yang menyediakan executable bernama `<n>`, dan
modul bernama `<language>-<n>`. Jika nama paket sudah diawali nama bahasanya
sendiri, awalan bahasa boleh dihilangkan. Nama singkatan bahasa **tidak**
menjadi pengganti valid untuk awalan bahasa.

Contoh: `perl-URI`, `python3-pyside2`

## Language Bindings (Binding Bahasa)

Language binding adalah paket yang memungkinkan program atau library
memiliki ekstensi/plugin yang ditulis dalam bahasa tertentu.

Konvensi penamaan:

```
<name>-<language>
```

Contoh: `gimp-python3`, `irssi-perl`

## Programs (Program)

Program menempatkan executable-nya di `/usr/bin` (atau dalam kasus khusus,
di direktori `.../bin` lainnya).

Untuk paket jenis ini, gunakan nama paket sesuai upstream. Perlu diingat,
berbeda dengan banyak distro lain, **Void tidak melakukan lowercase** pada
nama paket. Sebagai aturan umum: jika `tar.gz` paket mengandung huruf
kapital, maka nama paket juga harus mengandung huruf kapital tersebut; jika
tidak, nama paket ditulis huruf kecil semua.

Program bisa dipecah menjadi paket program dan paket library. Paket program
diberi nama sesuai aturan di atas, sedangkan paket library-nya diberi awalan
`lib` (lihat bagian **Libraries** di atas).
