# Menulis Layanan runit

> **Ringkasan:** Void Linux memakai **runit** untuk *booting* dan pengawasan (*supervision*) layanan. Bagian ini berisi panduan khusus Void tentang cara menulis layanan.

---

## 1. Sekilas tentang runit

[runit](http://smarden.org/runit/) adalah sistem init dan supervisor layanan. Sebuah **layanan** adalah **direktori** yang minimal berisi skrip **`run`**.

Informasi umum cara menulis layanan ada di [FAQ runit](http://smarden.org/runit/faq.html#create). Di bawah ini adalah panduan yang spesifik untuk Void Linux.

Untuk memasang layanan dari paket, gunakan fungsi [`vsv`](../02_dasar-template/03-fungsi-global.md#vsv).

---

## 2. Mendukung Opsi Lewat Variabel `OPTS`

Jika daemon mendukung opsi CLI (*flag*), pertimbangkan agar opsi bisa diubah lewat variabel **`OPTS`** dengan membaca file bernama **`conf`** di direktori yang sama dengan daemon.

```sh
#!/bin/sh
[ -r conf ] && . ./conf
exec daemon ${OPTS:- --flag-enabled-by-default}
```

Dengan begitu pengguna cukup membuat file `conf` berisi `OPTS="..."` untuk mengubah argumen tanpa menyunting skrip `run`.

---

## 3. Direktori di `/run`

Jika layanan butuh direktori di bawah `/run` (atau symlink-nya `/var/run`) untuk menyimpan informasi runtime (misalnya *pidfile*), tulis pembuatannya di dalam skrip layanan.

Disarankan memakai **`install`** (bukan `mkdir -p`) bila perlu izin tertentu:

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

---

## 4. Direktori di Luar Filesystem Sementara

Jika layanan membutuhkan direktori di bagian sistem yang **umumnya bukan filesystem sementara**, gunakan variabel **`make_dirs`** di template agar direktori dibuat saat paket dipasang.

```bash
make_dirs="/var/lib/foo 0750 foo foo"
```

---

## 5. File Unit systemd

Jika paket memasang file layanan **systemd** atau unit lainnya, **biarkan saja di tempatnya** sebagai titik rujukan, **selama** menyertakannya tidak membawa efek negatif.

Contoh kapan **tidak** memasang unit systemd:

1. Ketika hal itu **mengubah perilaku runtime** perangkat lunak yang dipaketkan.
2. Ketika dilakukan lewat *flag* waktu kompilasi yang **juga mengubah dependensi build**.

---

## 6. Struktur Layanan Sederhana

```
srcpkgs/foo/files/foo/
├── run          <- skrip utama (wajib)
├── conf         <- opsional: konfigurasi OPTS (dibuat pengguna)
└── log/         <- opsional: dibuat otomatis oleh vsv jika tidak ada
    └── run
```

Dipasang dari template:

```bash
post_install() {
	vsv foo
}
```

---

## Intinya

- Layanan runit = direktori dengan skrip `run`, dipasang dengan `vsv`.
- Dukung opsi lewat `OPTS` dengan membaca file `conf`.
- Buat direktori `/run` di dalam skrip layanan memakai `install -d`.
- Direktori di luar filesystem sementara dibuat lewat `make_dirs`.

---

<!-- nav -->
[← Membuat Akun dan Grup Sistem saat Runtime](../06_skrip-dan-layanan/03-akun-sistem.md) | [Daftar Isi](../DaftarISI.md) | [Subpackage →](../07_subpackage-dan-kelas-paket/01-subpackage.md)
