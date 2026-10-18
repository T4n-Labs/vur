# Kontribusi via Git dan Bantuan

> **Ringkasan:** Cara mengirim paket atau perbaikanmu ke repositori `void-packages` lewat GitHub, cara menjaga fork-mu tetap mutakhir, dan ke mana bertanya jika buntu.

---

## 1. Alur Kontribusi

```
Fork repo ─► Clone fork ─► Buat perubahan ─► Commit (sesuai pedoman) ─► Push ke fork ─► Buka Pull Request
```

---

## 2. Langkah demi Langkah

### a. Fork dan clone

Mulailah dengan **fork** repositori git `void-packages` milik void-linux di GitHub. Panduan fork ada di [dokumentasi GitHub](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo).

Kemudian clone fork-mu:

```bash
git clone git@github.com:<user>/void-packages.git
```

Ganti `<user>` dengan nama pengguna GitHub-mu.

### b. Ikuti pedoman commit

Lihat berkas `CONTRIBUTING.md` di repositori `void-packages` untuk informasi tentang **cara memformat commit** dan tips berkontribusi lainnya:
<https://github.com/void-linux/void-packages/blob/master/CONTRIBUTING.md>

### c. Kirim Pull Request

Setelah membuat perubahan di repositori **fork**-mu, kirim **pull request** GitHub.

---

## 3. Menjaga Fork Tetap Mutakhir

Atur remote **`upstream`** agar bisa menarik perubahan terbaru dari repositori utama:

```bash
git remote add upstream https://github.com/void-linux/void-packages.git
git pull --rebase upstream master
```

| Perintah | Fungsi |
|---|---|
| `git remote add upstream <url>` | Mendaftarkan repositori asli sebagai remote bernama `upstream` (cukup dilakukan sekali). |
| `git pull --rebase upstream master` | Menarik perubahan terbaru dari `master` repositori asli, lalu menata ulang commit-mu di atasnya. |

> **Tips pemula:** Seperti dibahas di [Repositori](../05_repositori-dan-update/01-repositori.md), kerjakan perubahan di **branch terpisah**, bukan langsung di `master`, supaya hasil build-mu tidak bercampur dengan repositori lokal utama.

---

## 4. Butuh Bantuan?

Jika setelah membaca manual ini kamu masih membutuhkan bantuan, bergabunglah dengan kanal **`#xbps`** lewat IRC di **`irc.libera.chat`**.

---

## Intinya

- Fork `void-packages`, clone fork-mu, ikuti `CONTRIBUTING.md`, lalu kirim pull request.
- Tambahkan remote `upstream` dan gunakan `git pull --rebase upstream master` untuk tetap mutakhir.
- Bantuan: IRC `#xbps` di `irc.libera.chat`.

---

<!-- nav -->
[← Catatan Penting dan Dokumentasi Khusus Void](../10_praktik-dan-kontribusi/01-catatan-dan-dokumentasi-void.md) | [Daftar Isi](../DaftarISI.md) | [Kesimpulan →](../kesimpulan.md)
