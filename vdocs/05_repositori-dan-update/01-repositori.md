# Repositori

> **Ringkasan:** Ada dua cara menentukan **ke repositori mana** paket hasil build akan ditempatkan: berdasarkan **branch git** dan berdasarkan variabel **`repository`** di template.

---

## 1. Repositori Berdasarkan Branch

Repositori global mengambil **nama branch git** yang sedang aktif, **kecuali** nama branch-nya `master`. Jika branch-nya `master`, repositori yang terbentuk berada di **cakupan global**.

**Skenario penggunaan:** kamu bisa memperbarui banyak paket di branch kedua **tanpa mengotori** repositori lokal utamamu.

| Branch aktif | Repositori hasil build |
|---|---|
| `master` | Repositori global (utama) |
| `update-foo` | Repositori terpisah bernama sesuai branch |

> **Tips pemula:** Selalu kerjakan perubahan paket di branch terpisah. Selain rapi untuk kontribusi, hasil build-nya pun tidak bercampur dengan repositori lokal utama.

---

## 2. Repositori yang Ditentukan Paket

Cara kedua adalah mengatur variabel **`repository`** di template. Dengan ini pemelihara bisa menentukan repositori untuk paket tertentu atau sekelompok paket. Saat ini dipakai untuk **membedakan kelas-kelas paket tertentu**.

```bash
repository=nonfree
```

### Nama Repositori yang Valid

| Nama | Isi |
|---|---|
| `bootstrap` | Repositori untuk paket yang khusus untuk `xbps-src`. |
| `debug` | Repositori untuk paket berisi simbol debug. Pada hampir semua kasus, paket ini **dibuat otomatis**. |
| `nonfree` | Repositori untuk paket *closed source* atau berlisensi non-bebas. |

---

## Intinya

- Branch `master` → repositori global; branch lain → repositori bernama sesuai branch.
- Variabel `repository` di template menentukan repositori khusus: `bootstrap`, `debug`, atau `nonfree`.

---

<!-- nav -->
[← Opsi Build (Build Options)](../04_proses-build/05-opsi-build.md) | [Daftar Isi](../DaftarISI.md) | [Mengecek Rilis Upstream Baru →](../05_repositori-dan-update/02-cek-rilis-upstream.md)
