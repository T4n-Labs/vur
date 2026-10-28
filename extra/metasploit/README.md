
# Metasploit Framework - Void Linux Package

Package template untuk **Metasploit Framework** di Void Linux (T4n OS).

## 📋 Informasi Paket

- **Nama**: metasploit
- **Versi**: mengikuti tag rilis di https://github.com/rapid7/metasploit-framework
- **Arsitektur**: x86_64, aarch64 (glibc saja, tanpa cross-build)
- **Build Style**: build dari source (tarball tag GitHub) + `bundle install`
- **Homepage**: https://www.metasploit.com

## 🤖 Automasi Update dengan `fetch.sh`

```bash
cd srcpkgs/metasploit
./fetch.sh          # ambil tag stabil terbaru
./fetch.sh 6.5.8    # atau paksa versi tertentu
```

**Apa yang dilakukan `fetch.sh`:**
1. Mencari tag `X.Y.Z` terbaru lewat `git ls-remote` (atau memakai versi dari argumen).
2. Mengunduh tarball tag dari GitHub dan menghitung SHA256.
3. Memperbarui `version` dan `checksum` di `template` (`revision` di-reset ke 1 bila versi berubah).

`distfiles` memakai `${version}`, jadi tidak perlu diubah.

## 🔨 Cara Build

```bash
cd /path/to/void-packages
./xbps-src pkg metasploit
```

> ⚠️ Fase `do_build` menjalankan `bundle install` dan **membutuhkan akses network**
> (download gem dari rubygems.org). Proses build lebih lama karena gem native
> (nokogiri, pg, eventmachine, dll) dikompilasi.

Hasil build:
```text
hostdir/binpkgs/metasploit-<version>_<revision>.<arch>.xbps
```

## 📦 Struktur Package

- **Tree Metasploit**: `/usr/lib/metasploit-framework` (termasuk `vendor/bundle`
  berisi gem yang sudah dikompilasi)
- **Symlink**: `/usr/bin/msfconsole`, `msfvenom`, `msfdb`, `msfrpc`, `msfrpcd`,
  `msfd`, `msfmcpd`
- `msfupdate` tidak dipasang; update dilakukan lewat `xbps-install`.

### Catatan Desain
1. Memakai **Ruby sistem** (`depends=ruby`), bukan Ruby bawaan Rapid7. Cek
   `required_ruby_version` di `metasploit-framework.gemspec` (6.5.8: `>= 3.2`)
   dan pastikan cocok dengan versi `ruby` di repo kamu.
2. Gem dikunci ke `Gemfile.lock` upstream (`frozen`), tanpa group
   `development`, `test`, `coverage`.
3. `nokogiri` dan `sqlite3` memakai library sistem (`--use-system-libraries`),
   sehingga tidak ada binary bundled non-PIE.
4. Config user dan cache (bootsnap) ditulis ke `~/.msf4`, bukan ke tree paket.

## ⚙️ Konfigurasi Pasca-Instalasi

```bash
msfdb init      # jalankan sebagai user biasa, bukan root
msfconsole
msf6 > db_status
```

## 🔧 Troubleshooting

- **`bundle install` gagal download gem**
  Pastikan network aktif di build chroot (jangan pakai `-N`).

- **Gagal compile gem native**
  Cek `makedepends` di template (`libpq-devel`, `libpcap-devel`, `sqlite-devel`,
  `libxml2-devel`, `libxslt-devel`, `libffi-devel`, `openssl-devel`, `libyaml-devel`).

- **Checksum mismatch**
  Jalankan `./fetch.sh <versi>` lalu build ulang.

## ⚠️ Disclaimer
Package ini disediakan untuk tujuan **edukasi dan penetration testing yang sah**. Penggunaan untuk aktivitas ilegal adalah tanggung jawab pengguna.

---
**Maintainer**: gh0st4n <darskevoid@gmail.com>  
**License**: BSD-3-Clause  
**Last Updated**: 2026
