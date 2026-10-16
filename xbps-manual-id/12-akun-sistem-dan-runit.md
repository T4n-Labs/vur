# 12. Akun Sistem & Menulis Runit Service

[« INSTALL/REMOVE Scripts](11-install-remove-scripts.md) · [Daftar Isi](README.md) · Selanjutnya: [32-bit & Subpackages »](13-32bit-dan-subpackages.md)

## Membuat Akun/Group Sistem saat Runtime

Ada trigger beserta beberapa variabel khusus untuk membuat **user dan group
sistem** saat paket biner sedang dikonfigurasi. Variabel yang bisa dipakai
untuk keperluan ini:

- **`system_groups`** — Menentukan nama-nama *system group* baru yang akan
  dibuat, dipisah spasi. Opsional, **gid** bisa ditentukan dengan
  dipisah titik dua, mis. `system_groups="_mygroup:78"` atau
  `system_groups="_foo _blah:8000"`.

- **`system_accounts`** — Menentukan nama-nama **user/group sistem** baru
  yang akan dibuat, dipisah spasi, mis. `system_accounts="_foo _blah:22"`.
  Opsional, **uid** dan **gid** bisa ditentukan dengan dipisah titik dua,
  mis. `system_accounts="_foo:48"`.

  Variabel tambahan untuk **system account** bisa ditentukan untuk
  mengubah perilakunya:

  - **`<account>_homedir`** — Direktori home untuk user tersebut. Jika
    kosong, default `/var/empty`.
  - **`<account>_shell`** — Shell untuk user baru tersebut. Jika kosong,
    default `/sbin/nologin`.
  - **`<account>_descr`** — Deskripsi untuk user baru tersebut. Jika
    kosong, default `<account> unprivileged user`.
  - **`<account>_groups`** — Group tambahan yang ditambahkan untuk user
    baru tersebut.
  - **`<account>_pgroup`** — Mengeset primary group; secara default,
    primary group diset ke `<account>`.

**System user** dibuat memakai **uid/gid** yang dialokasikan secara dinamis
di sistem, dan dibuat sebagai `system account`, kecuali **uid** sudah
ditentukan. Group baru akan dibuat khusus untuk `system account` tersebut
dan hanya dipakai untuk keperluan ini.

Akun dan group sistem harus diberi awalan underscore (`_`) untuk mencegah
bentrok dengan nama akun pengguna biasa.

> **Catatan:** kebijakan awalan underscore ini tidak berlaku untuk paket
> lama, karena mengubah username bisa menyebabkan kerusakan yang tak
> terhindarkan. Hanya paket baru yang wajib mengikuti aturan ini.

## Menulis Runit Service

Void Linux memakai [runit](http://smarden.org/runit/) untuk booting dan
supervisi service. Sebagian besar informasi tentang cara menulisnya bisa
ditemukan di [FAQ runit](http://smarden.org/runit/faq.html#create). Berikut
adalah panduan yang khusus untuk Void Linux dalam menulis service.

Jika daemon service mendukung flag CLI, pertimbangkan menambahkan dukungan
untuk mengubahnya lewat variabel `OPTS`, dengan membaca file bernama `conf`
di direktori yang sama dengan daemon-nya:

```sh
#!/bin/sh
[ -r conf ] && . ./conf
exec daemon ${OPTS:- --flag-enabled-by-default}
```

Jika service butuh membuat direktori di `/run` atau link-nya `/var/run`
untuk menyimpan informasi runtime (seperti pidfile), tulis pembuatan
direktori tersebut di file service-nya. Disarankan memakai `install`
jika kamu perlu membuatnya dengan izin spesifik, alih-alih `mkdir -p`:

```sh
#!/bin/sh
install -d -m0700 /run/foo
exec foo
```

```sh
#!/bin/sh
install -d -m0700 -o bar -g bar /run/bar
exec bar
```

Jika service butuh direktori di bagian sistem yang umumnya bukan
temporary filesystem, gunakan variabel `make_dirs` di template untuk
membuat direktori tersebut saat paket dipasang.

Jika paket memasang file service systemd atau unit lainnya, biarkan file
tersebut tetap ada sebagai referensi, selama tidak ada efek samping negatif
dari menyertakannya.

Contoh kapan **sebaiknya tidak** memasang unit systemd:

1. Jika hal itu mengubah perilaku runtime dari software yang dipaketkan.
2. Jika dilakukan lewat compile time flag yang juga mengubah build
   dependency.
