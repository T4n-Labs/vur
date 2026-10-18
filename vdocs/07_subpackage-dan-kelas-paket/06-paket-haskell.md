# Kelas Paket: Haskell

> **Ringkasan:** Paket Haskell bisa dibangun dengan build style `cabal` atau `haskell-stack`. Pilih yang paling nyaman atau lebih didukung upstream.

---

## 1. Memilih Build Style

Haskell packages dapat dibangun dengan:

- `cabal`, atau
- `haskell-stack`

Pakai yang lebih mudah atau lebih baik didukung upstream. Kadang hanya salah satu yang memungkinkan.

Untuk paket yang punya bagian Haskell tetapi memakai build style lain (misalnya `gnu-makefile`), pastikan memakai build helper **`haskell`**.

---

## 2. Variabel untuk Build dengan `cabal`

| Variabel | Fungsi |
|---|---|
| `cabal_index_state` | Status indeks cabal hackage yang dipakai untuk mengambil dependensi. Paket sumber proyek Haskell sebaiknya menyertakan *freeze file* yang mengatur status indeks (sebagian juga mengaturnya di file proyek cabal). Jika tidak, ini harus diisi dengan **timestamp ISO** di template. Contoh: `2025-07-05T14:01:16Z`. |
| `configure_args` | Argumen untuk `cabal configure`. Langkah configure membuat file `cabal.project.local`. |
| `make_build_args` | Argumen untuk `cabal build`. |
| `make_build_target` | Target untuk `cabal build`. |
| `make_check_args` | Argumen untuk `cabal test`. |
| `make_check_target` | Target tes yang diteruskan ke cabal, menggantikan `"test"`. |
| `make_install_target` | Target untuk `cabal install`. |

---

## 3. Variabel untuk Build dengan `stack`

| Variabel | Fungsi |
|---|---|
| `stackage` | Versi Stackage yang dipakai membangun paket, contoh `lts-3.5`. Alternatifnya: siapkan konfigurasi `stack.yaml` dan taruh di `files/stack.yaml`; atau jika file `stack.yaml` sudah ada di file sumber, file itu yang dipakai. |
| `make_build_args` | Diteruskan apa adanya ke `stack build ...`, sehingga parameter `--flag ...` bisa ditambahkan di sini. |

---

## 4. Menambal (Patch) Dependensi Haskell

Untuk menambal dependensi paket Haskell, dependensi tersebut harus **diunduh secara eksplisit dari hackage** dengan menambahkannya ke `distfiles`, bukan dibiarkan diunduh oleh cabal atau stack.

Setelah diekstrak dan ditambal:

1. Tambahkan path versi yang sudah ditambal ke `packages` di `cabal.project` atau `stack.yaml`.
2. Stack akan menemukannya otomatis jika tidak ada file `stack.yaml`, dengan memindai direktori.
3. Alat build kemudian memakai **versi yang ditambal**, bukan mengunduh dari hackage.

---

## 5. Ringkasan

```
Paket Haskell murni         → build_style=cabal  atau  build_style=haskell-stack
Paket campuran (mis. make)  → build_style lain + build_helper="haskell"
```

---

## Intinya

- Pilih `cabal` atau `haskell-stack` sesuai dukungan upstream.
- `cabal_index_state` perlu diisi timestamp ISO jika proyek tidak membawa freeze file.
- Untuk menambal dependensi: unduh via `distfiles`, lalu arahkan `cabal.project`/`stack.yaml` ke versi yang ditambal.

---

<!-- nav -->
[← Kelas Paket: Go](../07_subpackage-dan-kelas-paket/05-paket-go.md) | [Daftar Isi](../DaftarISI.md) | [Kelas Paket: Font →](../07_subpackage-dan-kelas-paket/07-paket-font.md)
