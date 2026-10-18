# Menangani Patch

> **Ringkasan:** *Patch* adalah perubahan kecil pada kode sumber upstream, biasanya untuk memperbaiki bug atau agar bisa dikompilasi dengan perangkat lunak yang lebih baru. `xbps-src` punya fitur bawaan untuk menerapkannya otomatis.

---

## 1. Kapan Perlu Patch?

Perangkat lunak kadang perlu diubah, terutama untuk:

- memperbaiki **bug** yang sudah ditemukan, atau
- memperbaiki proses **kompilasi** terhadap perangkat lunak/kompilator yang lebih baru.

---

## 2. Cara Kerja Dasar

`xbps-src` mencari semua file yang cocok dengan pola glob:

```
srcpkgs/$pkgname/patches/*.{diff,patch}
```

lalu **menerapkan semuanya secara otomatis** dengan `patch(1)` memakai opsi **`-Np1`**. Proses ini terjadi pada fase `do_patch()`.

Variabel **`PATCHESDIR`** tersedia di template dan menunjuk ke direktori `patches`.

```
srcpkgs/foo/
├── template
└── patches/
    ├── fix-build.patch
    └── musl-compat.diff
```

> Patch harus berformat `-p1`. Argumen default bisa diubah lewat variabel `patch_args` (lihat [Variabel Opsional: Konfigurasi Build](../02_dasar-template/05-variabel-opsional-build.md)).

---

## 3. Mengubah Perilaku Patch

### a. File `series`: menentukan urutan dan daftar patch

Buat file bernama **`series`** di direktori `patches`, berisi daftar patch **dipisahkan baris baru**, sesuai urutan penerapan.

Jika file `series` ada, `xbps-src` **hanya menerapkan patch yang disebutkan di dalamnya**.

```
# srcpkgs/foo/patches/series
0001-fix-build.patch
0002-musl-compat.diff
```

### b. File `.args`: argumen khusus untuk satu patch

File dengan **nama sama seperti patch tetapi berekstensi `.args`** dipakai untuk mengatur argumen yang diteruskan ke `patch(1)`.

Contoh: jika `foo.patch` membutuhkan argumen khusus yang tidak boleh dipakai untuk patch lain, buat `foo.patch.args` berisi argumen tersebut.

```
srcpkgs/foo/patches/
├── foo.patch
└── foo.patch.args    <- berisi argumen khusus untuk foo.patch
```

---

## 4. Alur Ringkas

```
fase extract
     │
     ▼
fase patch ──► cari patches/*.{diff,patch}
                 │
                 ├── ada file `series`? ──► hanya terapkan yang tercantum, urut sesuai daftar
                 │
                 └── tidak ada `series` ──► terapkan semuanya
                 │
                 └── tiap patch dicek: ada <nama>.args? ──► pakai argumennya
```

---

## Intinya

- Taruh patch (`.patch` atau `.diff`) di `srcpkgs/<pkgname>/patches/`; semuanya otomatis diterapkan.
- Gunakan `series` untuk mengatur urutan dan memilih patch tertentu.
- Gunakan `<nama-patch>.args` untuk argumen `patch(1)` khusus.

---

<!-- nav -->
[← Fungsi di Template (Hook Fase Build)](../04_proses-build/03-fungsi-template.md) | [Daftar Isi](../DaftarISI.md) | [Opsi Build (Build Options) →](../04_proses-build/05-opsi-build.md)
