# 5. Memahami Variabel `depends`

[« Variabel Wajib & Opsional](04-variabel-wajib-dan-opsional.md) · [Daftar Isi](README.md) · Selanjutnya: [Repositories & Update Check »](06-repositories-dan-update-check.md)

Sejauh ini sudah dibahas empat jenis variabel `depends`: `hostmakedepends`,
`makedepends`, `checkdepends`, dan `depends`. Jenis-jenis variabel yang
berbeda ini dibutuhkan karena `xbps-src` mendukung cross compilation, dan
untuk menghindari pemasangan paket yang tidak perlu di environment build.

## hostmakedepends

Selama proses build, ada program yang harus **dijalankan di host**, seperti
`yacc` atau compiler C. Paket yang berisi program-program ini harus
didaftarkan di `hostmakedepends`, dan akan dipasang di host saat membangun
paket target. Sebagian paket ini sudah menjadi dependency dari paket
`base-chroot` dan tidak perlu didaftarkan lagi. Beberapa program yang
dibutuhkan untuk membangun sebuah project mungkin berada di paket `-devel`.

## makedepends

Paket target juga bisa bergantung pada paket lain untuk library yang di-link
atau header file. Paket-paket ini harus didaftarkan di `makedepends`, dan
akan mengikuti arsitektur **target**, terlepas dari arsitektur mesin build.
Biasanya `makedepends` berisi paket-paket `-devel`.

## checkdepends

Jika `XBPS_CHECK_PKGS` diset, atau opsi `-Q` dipassing ke `xbps-src`, paket
target mungkin membutuhkan dependency atau library tertentu yang di-link ke
binary test-nya untuk menjalankan testsuite. Dependency ini harus
didaftarkan di `checkdepends`, dan akan dipasang seolah-olah bagian dari
`hostmakedepends`. Beberapa dependency yang umum dipakai di `checkdepends`:

- `dejagnu` — dipakai beberapa proyek GNU
- `cmocka-devel` — di-link ke binary test
- `dbus` — memungkinkan menjalankan `dbus-run-session <test-command>` untuk
  menyediakan sesi D-Bus bagi aplikasi yang membutuhkannya
- `git` — beberapa testsuite menjalankan perintah `git`

## Runtime dependencies (`depends`)

Terakhir, sebuah paket mungkin membutuhkan dependency tertentu saat
**runtime**, tanpanya paket tidak bisa dipakai. Dependency ini, jika tidak
terdeteksi otomatis oleh XBPS, harus didaftarkan di `depends`.

Library yang di-link oleh objek ELF terdeteksi otomatis oleh `xbps-src`,
sehingga **tidak perlu** didaftarkan lagi di `depends`. Variabel `depends`
sebaiknya berisi:

- Executable yang dipanggil sebagai proses terpisah.
- Objek ELF yang memakai `dlopen(3)`.
- Kode non-objek, mis. header C, modul perl/python/ruby/dll.
- File data.
- Override versi minimal yang ditentukan di file `common/shlibs`.

Runtime dependency untuk objek ELF dideteksi dengan memeriksa SONAME yang
dibutuhkannya, lalu SONAME tersebut dipetakan ke nama paket biner beserta
versi minimal yang dibutuhkan. File `common/shlibs` mengatur pemetaan
`<SONAME> <pkgname>>=<version>`.

Contoh: paket `foo-1.0_1` menyediakan SONAME `libfoo.so.1`; software yang
membutuhkan library ini akan di-link ke `libfoo.so.1`, dan paket biner hasil
build-nya akan memiliki runtime dependency ke paket `foo>=1.0_1` sesuai yang
ditentukan di `common/shlibs`:

```
# common/shlibs
...
libfoo.so.1 foo-1.0_1
...
```

- Field pertama: SONAME.
- Field kedua: nama paket dan versi minimal yang dibutuhkan.
- Field ketiga (opsional, biasanya `ignore`): dipakai untuk melewati
  pemeriksaan saat SONAME bump.

Dependency yang dideklarasikan lewat `depends` tidak dipasang ke master
directory — hanya diperiksa apakah sudah ada sebagai paket biner, dan akan
dibangun otomatis oleh `xbps-src` jika versi yang diminta belum ada di
repository lokal.

## Virtual dependencies

Sebagai kasus khusus, dependency **virtual** bisa ditentukan sebagai runtime
dependency di variabel template `depends`. Beberapa paket berbeda bisa
menyediakan fungsionalitas yang sama dengan mendeklarasikan nama dan versi
virtual di variabel template `provides` (mis. `provides="vpkg-0.1_1"`).
Paket yang bergantung pada fungsionalitas umum tanpa peduli siapa
penyedianya bisa mendeklarasikan dependency ke nama paket virtual dengan
awalan `virtual?` (mis. `depends="virtual?vpkg-0.1_1"`). Saat sebuah paket
dibangun oleh `xbps-src`, penyedia untuk paket virtual apa pun akan
dipastikan ada, dan akan dibangun jika perlu. Pemetaan dari paket virtual ke
penyedia default-nya didefinisikan di `etc/defaults.virtual`. Pemetaan
individual bisa di-override lewat preferensi lokal di `etc/virtual`.
Komentar di `etc/defaults.virtual` memberikan info lebih lanjut soal
pemetaan ini.

## Aturan umum

Sebagai aturan umum: jika sebuah paket dibangun dengan cara yang sama persis
baik ada atau tidaknya paket tertentu di `makedepends`/`hostmakedepends`,
paket tersebut sebaiknya **tidak** ditambahkan sebagai build-time dependency.
