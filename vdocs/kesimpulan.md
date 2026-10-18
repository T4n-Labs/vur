# Kesimpulan

> **Ringkasan:** Rangkuman seluruh dokumentasi: alur kerja membuat paket dari awal sampai akhir, peta topik, glosarium, dan langkah belajar selanjutnya.

---

## 1. Gambaran Seluruh Materi

Membuat paket di Void Linux pada dasarnya adalah **menulis sebuah `template`** (skrip bash berisi variabel dan fungsi), lalu membiarkan **`xbps-src`** mengerjakan sisanya: mengunduh, mengekstrak, menambal, mengonfigurasi, mengompilasi, mengetes, memasang ke direktori sementara, dan mengemas menjadi paket `.xbps`.

```
 Template ──► xbps-src ──► [setup → fetch → extract → patch → configure
                            → build → check → install → pkg → clean] ──► paket .xbps
```

---

## 2. Alur Kerja Membuat Paket (Ringkas)

| # | Langkah | Detail di |
|---|---|---|
| 1 | Siapkan `void-packages` dan lingkungan build | [Pengenalan](01_pengenalan/01-apa-itu-xbps-src.md) |
| 2 | Tentukan nama paket sesuai aturan penamaan | [Penamaan Paket](01_pengenalan/03-penamaan-paket.md) |
| 3 | Buat `srcpkgs/<pkgname>/template` dan isi **variabel wajib** | [Variabel Wajib](02_dasar-template/01-variabel-wajib.md) |
| 4 | Isi `distfiles` dan `checksum` | [Sumber Kode](02_dasar-template/04-variabel-opsional-sumber-kode.md) |
| 5 | Pilih `build_style` yang cocok | [Build Style](04_proses-build/01-build-style.md) |
| 6 | Tentukan dependensi (`hostmakedepends`, `makedepends`, `depends`) | [Dependensi](03_dependensi/01-jenis-dependensi.md) |
| 7 | Tambahkan patch bila perlu | [Patch](04_proses-build/04-patch.md) |
| 8 | Sesuaikan lewat fungsi `pre_/do_/post_` dan fungsi bantu `v...` | [Fungsi Template](04_proses-build/03-fungsi-template.md), [Fungsi Global](02_dasar-template/03-fungsi-global.md) |
| 9 | Pecah menjadi subpackage (`-devel`, `-doc`, `-data`) bila perlu | [Subpackage](07_subpackage-dan-kelas-paket/01-subpackage.md) |
| 10 | Bangun: `./xbps-src pkg <pkgname>` | [Pengenalan](01_pengenalan/01-apa-itu-xbps-src.md) |
| 11 | Periksa hasil dan checklist | [Catatan Penting](10_praktik-dan-kontribusi/01-catatan-dan-dokumentasi-void.md) |
| 12 | Kirim lewat pull request | [Kontribusi via Git](10_praktik-dan-kontribusi/02-kontribusi-via-git.md) |

---

## 3. Template Kerangka Siap Pakai

```bash
# Template file for 'foo'
pkgname=foo
version=1.0
revision=1
build_style=gnu-configure
hostmakedepends=""
makedepends=""
depends=""
short_desc="Package description, no more than 72 characters"
maintainer="Nama Kamu <kamu@contoh.com>"
distributor="Nama Kamu <kamu@contoh.com>"
license="GPL-3.0-or-later"
homepage="http://www.foo.org"
distfiles="http://www.foo.org/foo-${version}.tar.gz"
checksum="<sha256 dari file sumber>"

post_install() {
	# vlicense COPYING     # wajib untuk lisensi MIT/BSD/ISC/AGPL/X11/custom
	:
}

# Subpackage pengembangan (hapus jika tidak diperlukan)
foo-devel_package() {
	short_desc+=" - development files"
	depends="${sourcepkg}>=${version}_${revision}"
	pkg_install() {
		vmove usr/include
		vmove "usr/lib/*.a"
		vmove "usr/lib/*.so"
		vmove usr/lib/pkgconfig
	}
}
```

> Jangan lupa: untuk subpackage, buat symlink `srcpkgs/foo-devel -> foo`.

---

## 4. Peta Topik

| Saya ingin... | Baca |
|---|---|
| Memahami konsep dasar dan istilah | [Bagian 1: Pengenalan](01_pengenalan/01-apa-itu-xbps-src.md) |
| Mengisi variabel template | [Bagian 2: Dasar Template](02_dasar-template/01-variabel-wajib.md) |
| Mengatur dependensi | [Bagian 3: Dependensi](03_dependensi/01-jenis-dependensi.md) |
| Mengatur cara build, hook, patch, opsi | [Bagian 4: Proses Build](04_proses-build/01-build-style.md) |
| Mengecek versi upstream baru | [Bagian 5: Repositori dan Update](05_repositori-dan-update/02-cek-rilis-upstream.md) |
| Membuat skrip pasang/hapus, akun sistem, layanan runit | [Bagian 6: Skrip dan Layanan](06_skrip-dan-layanan/01-install-remove.md) |
| Memecah paket atau paketkan Python/Go/Haskell/font | [Bagian 7: Subpackage dan Kelas Paket](07_subpackage-dan-kelas-paket/01-subpackage.md) |
| Mengganti nama atau menghapus paket | [Bagian 8: Pemeliharaan Paket](08_pemeliharaan-paket/01-mengganti-nama-paket.md) |
| Memahami trigger otomatis | [Bagian 9: XBPS Triggers](09_xbps-triggers/01-pengenalan-trigger.md) |
| Mengirim kontribusi | [Bagian 10: Praktik dan Kontribusi](10_praktik-dan-kontribusi/02-kontribusi-via-git.md) |

---

## 5. Glosarium Singkat

| Istilah | Arti |
|---|---|
| **template** | File resep paket (skrip bash) di `srcpkgs/<pkgname>/template`. |
| **xbps-src** | Pembuat paket yang memproses template. |
| **distfiles** | File sumber yang diunduh dari upstream. |
| **checksum** | Hash SHA256 untuk memverifikasi distfiles. |
| **build_style** | Skrip siap pakai yang menentukan cara build dan install. |
| **build_helper** | Skrip penyiap lingkungan, terutama cross-compile. |
| **destdir / DESTDIR** | Direktori sementara tempat hasil `install` dikumpulkan. |
| **PKGDESTDIR** | Destdir milik subpackage. |
| **subpackage** | Paket tambahan dari template yang sama (`foo-devel`, dll). |
| **hostmakedepends** | Alat yang dijalankan saat build (arsitektur host). |
| **makedepends** | Library/header untuk di-link saat build (arsitektur target). |
| **depends** | Dependensi saat paket dijalankan. |
| **SONAME** | Nama resmi shared library, contoh `libfoo.so.1`. |
| **shlibs** | Berkas `common/shlibs` pemetaan SONAME ke paket. |
| **trigger** | Skrip otomatis untuk tugas rutin pasca-pasang/hapus. |
| **cross-compile** | Membangun untuk arsitektur berbeda dari mesin pembangun. |
| **upstream** | Pengembang asli perangkat lunak. |
| **runit** | Sistem init dan supervisor layanan di Void Linux. |

---

## 6. Prinsip Emas

1. **Ikuti konvensi.** Penamaan, indentasi, panjang baris, dan lokasi file sudah diatur.
2. **Jangan menambah yang tidak perlu.** Dependensi dan variabel hanya jika benar-benar mengubah hasil.
3. **Jelaskan alasan.** Untuk `broken`, `nocross`, `make_check`, dan sejenisnya, selalu sertakan alasan.
4. **Biarkan `xbps-src` bekerja.** Jangan strip binary manual, dan manfaatkan deteksi dependensi otomatis.
5. **Uji sebelum kirim.** Bangun paket dan periksa file hasilnya.
6. **Bertanya itu boleh.** Kanal IRC `#xbps` di `irc.libera.chat` siap membantu.

---

## 7. Langkah Selanjutnya

- Pilih satu paket kecil di `srcpkgs/` dan **baca template-nya** sebagai contoh nyata.
- Coba **bangun ulang** paket sederhana dengan `./xbps-src pkg <pkgname>`.
- Eksperimen dengan **subpackage** dan **opsi build** pada paket latihan di branch terpisah.
- Baca **manual aslinya** untuk detail terbaru: <https://github.com/void-linux/void-packages/blob/master/Manual.md>

> Dokumentasi ini disusun ulang dalam bahasa Indonesia dari `Manual.md` repositori `void-linux/void-packages`. Untuk rujukan paling mutakhir, selalu cek manual resminya.

---

<!-- nav -->
[← Kontribusi via Git dan Bantuan](10_praktik-dan-kontribusi/02-kontribusi-via-git.md) | [Daftar Isi](DaftarISI.md)
