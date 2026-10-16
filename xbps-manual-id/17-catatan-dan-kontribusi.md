# 17. Dokumentasi Khusus Void, Catatan, & Kontribusi

[« XBPS Triggers](16-xbps-triggers.md) · [Daftar Isi](README.md)

## Dokumentasi Khusus Void Linux

Jika kamu ingin mendokumentasikan detail konfigurasi dan penggunaan paket
yang spesifik untuk Void Linux (tidak dicakup dokumentasi upstream),
taruh catatan di `srcpkgs/<pkgname>/files/README.voidlinux`, dan pasang
dengan `vdoc "${FILESDIR}/README.voidlinux"`.

## Catatan Umum

- Pastikan semua software dikonfigurasi untuk memakai prefix `/usr`.
- Binary selalu dipasang di `/usr/bin`.
- Man page selalu dipasang di `/usr/share/man`.
- Jika software menyediakan **shared library** dan header, kemungkinan
  besar kamu perlu membuat **development package** yang berisi header,
  static library, dan file lain yang dibutuhkan untuk development (tidak
  dibutuhkan saat runtime).
- Jika kamu sedang memperbarui sebuah paket, hati-hati dengan SONAME
  bump — periksa file yang terpasang (`./xbps-src show-files pkg`)
  sebelum mendorong update baru.
- Pastikan binary tidak di-*strip* oleh software itu sendiri; biarkan
  `xbps-src` yang melakukannya — jika tidak, paket `debug` tidak akan
  punya debugging symbol.

## Berkontribusi via Git

Untuk memulai,
[fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo)
repository git `void-packages` milik void-linux di GitHub, lalu clone:

```
$ git clone git@github.com:<user>/void-packages.git
```

Lihat [CONTRIBUTING.md](./CONTRIBUTING.md) untuk info tentang cara
memformat commit dan tips lain untuk berkontribusi.

Setelah membuat perubahan di repository hasil fork-mu, ajukan pull request
di GitHub.

Untuk menjaga repository fork-mu tetap up to date, siapkan remote
`upstream` untuk menarik perubahan baru:

```
$ git remote add upstream https://github.com/void-linux/void-packages.git
$ git pull --rebase upstream master
```

## Bantuan

Jika setelah membaca manual ini kamu masih butuh bantuan, silakan
bergabung di `#xbps` via IRC di `irc.libera.chat`.

---

[« Kembali ke Daftar Isi](README.md)
