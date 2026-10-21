# 🇮🇩 INDONESIA / [🇬🇧 ENGLISH](./CONTRIBUTING.md)

## PANDUAN KONTRIBUSI VUR

Terima kasih sudah tertarik berkontribusi ke **VUR (Void User Repository)**.
Panduan ini menjelaskan alur branch dan aturan penulisan template supaya kontribusimu cepat di-review dan terbaca benar oleh sistem indeks.


## 1. STRUKTUR BRANCH

| Branch | Fungsi | Siapa yang push |
|--------|--------|-----------------|
| `main` | Branch utama (stabil). Di sinilah CI menjalankan `vtools/generate.sh` untuk **men-scan semua template** dan menghasilkan data indeks: `index.json`, `packages.json`, `search.json`, `categories.json`. | Maintainer saja |
| `dev` | Branch kontribusi. Tempat kontributor memasukkan **template VUR** baru atau perbaikan template yang sudah ada. | Kontributor, lewat Pull Request |

> ⚠️ **Semua Pull Request harus menargetkan `dev`, bukan `main`.**

## 2. ALUR KONTRIBUSI

```
Fork ─► Clone ─► Branch dari dev ─► Tambah/ubah template ─► Uji build ─► Commit ─► Push ─► Pull Request ke dev
```

```bash
# 1. Fork repo di GitHub, lalu clone fork-mu
git clone https://github.com/<user>/vur.git
cd vur

# 2. Daftarkan repo asli sebagai upstream
git remote add upstream https://github.com/T4n-Labs/vur.git
git fetch upstream

# 3. Buat branch kerja dari dev (satu branch per paket)
git checkout -b add/<nama-paket> upstream/dev

# 4. Kerjakan template, uji, commit, lalu push ke fork-mu
git push origin add/<nama-paket>
```

Setelah itu buka **Pull Request** dari branch-mu ke `T4n-Labs/vur` → `dev`.

## 3. LOKASI TEMPLATE

Setiap paket punya foldernya sendiri di dalam salah satu kategori:

```
<kategori>/<nama-paket>/
├── template          # wajib
├── files/            # opsional (berkas tambahan)
├── patches/          # opsional (patch)
└── INSTALL, INSTALL.msg, REMOVE   # opsional (hook)
```

| Kategori | Isi |
|----------|-----|
| `core` | Komponen sistem dasar: init & layanan (mis. `dinit`), kernel, base-system, installer. |
| `extra` | Aplikasi dan perangkat lunak tambahan. |
| `multilib` | Paket 32-bit / multilib (mis. `wine-pure`). |

Nama folder **harus sama** dengan `pkgname` di dalam `template`.

## 4. ATURAN TEMPLATE

VUR memakai format template `xbps-src`. Dasar-dasarnya ada di [dokumentasi](vdocs/DaftarISI.md).

Selain field standar xbps-src (`build_style`, `license`, `distfiles`, `checksum`, dst.), field berikut **dibaca oleh `vtools/generate.sh`** dan wajib ada:

| Field | Keterangan |
|-------|------------|
| `pkgname` | Sama dengan nama folder. |
| `version` | Angka versi literal, tanpa variabel. |
| `short_desc` | Deskripsi singkat satu baris. |
| `homepage` | URL proyek upstream. |
| `maintainer` | Format `"Nama <email>"`. |
| `distributor` | Format `"Nama <email>"`. Pihak yang mendistribusikan template ke VUR. |
| `archs` | **Opsional.** Kosong = semua arsitektur. `x86_64*` otomatis menjadi `x86_64` + `x86_64-musl`. |

Karena indeks dibuat dengan parser sederhana (`grep "^field="`), patuhi hal berikut:

- Tulis field di **awal baris** (tanpa indentasi), satu assignment per baris.
- Jangan beri **komentar di baris yang sama** dengan field (`version=1.0 # ...` akan merusak hasil).
- Jangan pakai tanda kutip ganda `"` di dalam nilai `short_desc`.
- Jangan menulis `version` sebagai ekspresi/variabel.

## 5. UJI SEBELUM MENGIRIM

```bash
# Pastikan template terdeteksi oleh scanner VUR
./vtools/scan.sh | grep <nama-paket>

# Uji build memakai void-packages
git clone https://github.com/void-linux/void-packages.git
cd void-packages
./xbps-src binary-bootstrap
cp -r /path/ke/vur/<kategori>/<nama-paket> srcpkgs/
./xbps-src pkg <nama-paket>

# Opsional: lint template (paket xtools)
xlint srcpkgs/<nama-paket>/template
```

## 6. PESAN COMMIT

Gunakan format *conventional commits*:

```
feat(<kategori>): add <nama-paket> <versi>
fix(<kategori>): update <nama-paket> to <versi>
docs: <ringkasan>
chore: <ringkasan>
```

## 7. CHECKLIST PULL REQUEST

- [ ] PR menargetkan branch `dev`
- [ ] Satu PR = satu paket
- [ ] Template berada di kategori yang benar
- [ ] Build lokal sukses (`./xbps-src pkg <nama-paket>`)
- [ ] `checksum` benar dan sumber berasal dari upstream resmi
- [ ] Tidak ada kode tersembunyi/obfuscated di template atau script (semua template diaudit)
- [ ] **Tidak mengubah** `index.json`, `packages.json`, `search.json`, `categories.json`
- [ ] Tidak mengubah `.github/workflows/` atau `vtools/` tanpa diskusi dengan maintainer

> File `*.json` dibuat otomatis oleh **VUR Bot** dan hanya boleh berubah di `main`.

## 8. CATATAN UNTUK MAINTAINER

1. Review dan merge PR kontributor ke `dev`.
2. Saat siap rilis, merge `dev` → `main`.
3. Push ke `main` memicu workflow: `vtools/generate.sh` dijalankan dan VUR Bot membuat commit `update vur index`.
4. Sinkronkan kembali supaya `dev` tidak tertinggal oleh commit bot:

   ```bash
   git checkout dev
   git merge main
   git push origin dev
   ```

## BANTUAN

Buka *issue* di repositori ini, atau baca [dokumentasi VUR](vdocs/DaftarISI.md) terlebih dahulu.

<div align="center">

[@T4n-Labs](https://t4nlabs.web.id) · [@Gh0sT4n](https://gh0st4n.my.id)

</div>
