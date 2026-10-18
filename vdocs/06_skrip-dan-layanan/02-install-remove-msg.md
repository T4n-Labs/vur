# File INSTALL.msg dan REMOVE.msg

> **Ringkasan:** File teks sederhana untuk menampilkan **pesan penting** kepada pengguna setelah pemasangan atau sebelum penghapusan paket.

---

## 1. Fungsi

| File | Kapan pesan ditampilkan |
|---|---|
| `INSTALL.msg` | Saat **post-install** (setelah paket dipasang). |
| `REMOVE.msg` | Saat **pre-remove** (sebelum paket dihapus). |

```
srcpkgs/foo/
├── template
├── INSTALL.msg
└── REMOVE.msg
```

---

## 2. Aturan Penulisan

- Idealnya satu baris **tidak lebih dari 80 karakter**.
- Hanya dipakai untuk **pesan kritis**, misalnya memperingatkan pengguna tentang **perubahan yang merusak** (*breaking changes*).

> **Tips pemula:** jangan gunakan untuk pengumuman biasa atau promosi. Pengguna akan terbiasa mengabaikan pesan jika terlalu sering muncul.

---

## 3. Untuk Subpackage

Subpackage juga bisa punya pesan sendiri. Buat dengan nama:

```
srcpkgs/<pkgname>/<subpkg>.INSTALL.msg
srcpkgs/<pkgname>/<subpkg>.REMOVE.msg
```

---

## 4. Contoh Isi `INSTALL.msg`

```
foo 2.0 changes the default config location.
Move /etc/foo.conf to /etc/foo/foo.conf before restarting.
```

---

## Intinya

- `INSTALL.msg` = pesan setelah pasang; `REMOVE.msg` = pesan sebelum hapus.
- Maksimal sekitar 80 karakter per baris.
- Hanya untuk pesan kritis seperti *breaking changes*.

---

<!-- nav -->
[← File INSTALL dan REMOVE](../06_skrip-dan-layanan/01-install-remove.md) | [Daftar Isi](../DaftarISI.md) | [Membuat Akun dan Grup Sistem saat Runtime →](../06_skrip-dan-layanan/03-akun-sistem.md)
