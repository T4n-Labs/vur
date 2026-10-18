# Membuat Akun dan Grup Sistem saat Runtime

> **Ringkasan:** Banyak daemon (layanan latar belakang) sebaiknya berjalan sebagai **pengguna sistem khusus** yang tidak punya hak istimewa. XBPS menyediakan variabel dan trigger untuk membuat **user dan grup sistem** otomatis saat paket dikonfigurasi.

---

## 1. Variabel yang Tersedia

### `system_groups`

Menentukan nama **grup sistem** baru yang akan dibuat, dipisahkan spasi. Opsional: **gid** bisa ditentukan dengan titik dua.

```bash
system_groups="_mygroup:78"
system_groups="_foo _blah:8000"
```

### `system_accounts`

Menentukan nama **user/grup sistem** baru yang akan dibuat, dipisahkan spasi. Opsional: **uid** dan **gid** bisa ditentukan dengan titik dua.

```bash
system_accounts="_foo _blah:22"
system_accounts="_foo:48"
```

### Variabel Tambahan per Akun

Untuk setiap akun, kamu dapat mengubah perilakunya dengan variabel berikut (ganti `<account>` dengan nama akun):

| Variabel | Fungsi | Default |
|---|---|---|
| `<account>_homedir` | Direktori home pengguna. | `/var/empty` |
| `<account>_shell` | Shell pengguna baru. | `/sbin/nologin` |
| `<account>_descr` | Deskripsi pengguna baru. | `<account> unprivileged user` |
| `<account>_groups` | Grup tambahan untuk pengguna baru. | - |
| `<account>_pgroup` | Grup primer. | `<account>` |

---

## 2. Bagaimana Akun Dibuat?

- Pengguna sistem dibuat memakai **uid/gid yang dialokasikan secara dinamis** di sistem, dan dibuat sebagai **akun sistem**, kecuali jika **uid** ditentukan.
- Grup baru dibuat untuk akun sistem tersebut dan dipakai **khusus** untuk keperluan itu.
- Saat paket dihapus, akun dinonaktifkan oleh trigger [`system-accounts`](../09_xbps-triggers/03-trigger-sistem.md#system-accounts).

---

## 3. Aturan Penamaan: Awalan Garis Bawah

> Akun dan grup sistem **harus diawali garis bawah** (`_`) untuk mencegah bentrok dengan nama akun pengguna biasa.

```bash
system_accounts="_foo"        # benar
system_accounts="foo"         # salah untuk paket baru
```

> **Catatan:** kebijakan garis bawah **tidak berlaku untuk paket lama**, karena mengganti nama pengguna pasti menimbulkan kerusakan. Hanya **paket baru** yang harus mengikutinya.

---

## 4. Contoh Lengkap

```bash
system_accounts="_foo"
_foo_homedir="/var/lib/foo"
_foo_descr="Foo daemon user"
_foo_groups="audio"
make_dirs="/var/lib/foo 0750 _foo _foo"
```

Hasilnya:

- User dan grup `_foo` dibuat saat paket dikonfigurasi.
- Home directory `/var/lib/foo`.
- Deskripsi "Foo daemon user".
- Anggota grup tambahan `audio`.
- Direktori `/var/lib/foo` dibuat dengan izin `0750` dan dimiliki `_foo`.

---

## Intinya

- `system_groups` membuat grup; `system_accounts` membuat user + grup sistem.
- Nama akun/grup sistem **harus diawali `_`** (paket baru).
- Atur home, shell, deskripsi, dan grup dengan `<account>_homedir`, `<account>_shell`, `<account>_descr`, `<account>_groups`, `<account>_pgroup`.

---

<!-- nav -->
[← File INSTALL.msg dan REMOVE.msg](../06_skrip-dan-layanan/02-install-remove-msg.md) | [Daftar Isi](../DaftarISI.md) | [Menulis Layanan runit →](../06_skrip-dan-layanan/04-layanan-runit.md)
