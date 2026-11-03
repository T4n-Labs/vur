# Metasploit Framework - Void Linux Package (T4n OS)

Package template untuk Metasploit Framework di Void Linux.

## 📋 Informasi Paket
- **Nama**: `metasploit`
- **Versi**: Mengikuti tag rilis stabil di [rapid7/metasploit-framework](https://github.com/rapid7/metasploit-framework)
- **Arsitektur**: `x86_64`, `aarch64` (glibc saja, tanpa cross-build)
- **Build Style**: Build dari source (tarball tag GitHub) + `bundle install`
- **Homepage**: https://www.metasploit.com

## 🤖 Automasi Update dengan `fetch.sh`
```bash
cd srcpkgs/metasploit
./fetch.sh          # Ambil tag stabil terbaru secara otomatis
./fetch.sh 6.5.8    # Atau paksa versi tertentu
```
**Apa yang dilakukan `fetch.sh`:**
1. Mencari tag `X.Y.Z` terbaru lewat `git ls-remote` (atau memakai versi dari argumen).
2. Mengunduh tarball tag dari GitHub dan menghitung SHA256.
3. Memperbarui `version` dan `checksum` di `template` (`revision` di-reset ke 1 bila versi berubah).
4. `distfiles` memakai `${version}`, jadi URL tidak perlu diubah manual.

## 🔨 Cara Build
```bash
cd /path/to/void-packages
./xbps-src clean metasploit  # Wajib clean jika ada sisa build gagal sebelumnya
./xbps-src pkg metasploit
```
> ⚠️ **PERHATIAN**: Fase `do_build` menjalankan `bundle install` dan membutuhkan akses network (download gem dari rubygems.org). Proses build lebih lama karena gem native (`nokogiri`, `pg`, `eventmachine`, dll) dikompilasi.

**Hasil build:**
`hostdir/binpkgs/metasploit-<version>_<revision>.<arch>.xbps`

## 📦 Struktur Package
- **Tree Metasploit**: `/usr/lib/metasploit-framework` (termasuk `vendor/bundle` berisi gem yang sudah dikompilasi).
- **Executable Wrappers**: `/usr/bin/msfconsole`, `msfvenom`, `msfdb`, `msfrpc`, `msfrpcd`, `msfd`, `msfmcpd`.  
  *(Catatan: Ini adalah **wrapper script**, bukan symlink, untuk memastikan `BUNDLE_GEMFILE` dan `BUNDLE_PATH` resolve dengan benar dan mencegah error `LoadError` pada library internal seperti `rex/socket`)*.
- **`msfupdate`**: Sengaja tidak dipasang; update framework dilakukan lewat `xbps-install`.

## 📝 Catatan Desain & Fix XBPS Hooks
Metasploit membawa ratusan payload pre-compiled cross-architecture (ELF ARM/MIPS/PPC, PE Windows, raw shellcode blobs) sebagai **data runtime**, bukan sebagai output build host. Agar tidak bentrok dengan kebijakan ketat Void Linux, template ini menerapkan:
1. `nostrip=yes` & `nodebug=yes`: Mencegah hook `strip` mencoba memproses biner cross-arch/raw blob yang akan gagal atau merusak offset payload.
2. `noverifyrdeps=yes`: Mencegah hook `generate-runtime-deps` menjalankan `objdump`/`readelf` pada file payload yang bukan ELF host, yang sebelumnya menyebabkan error `cannot guess required shlibs`. Dependensi runtime di-manual specify di variabel `depends`.
3. `python_version=ignore`: Mencegah hook `rewrite-python-shebang` gagal pada script Python internal Metasploit.
4. Direktori `external/` dikecualikan dari `do_install()` karena hanya berisi source code build helper (seperti `byakugan`), bukan file runtime.

## ⚙️ Konfigurasi Pasca-Instalasi (PENTING)

Metasploit memerlukan database PostgreSQL. Paket ini **tidak** membuat atau menjalankan database secara otomatis (tidak ada hook `INSTALL`); kamu menginisialisasinya sendiri.

### 1. Inisialisasi Database (sebagai user biasa, JANGAN root)
```bash
msfdb init
```
Secara default `msfdb` membuat cluster PostgreSQL pribadi di `~/.msf4/db` milik user kamu, jadi **service runit `postgresql` sistem tidak diperlukan**.

Output yang diharapkan:
```text
[+] Initialising database
[+] Starting database
[+] Creating database user 'msf'
[+] Creating databases 'msf' and 'msf_test'
[+] Creating configuration file '/home/user/.msf4/database.yml'
[+] Creating initial database schema
```

### 2. Verifikasi Koneksi
```bash
msfdb status
msfconsole -x 'db_status; exit'
```
Output yang diharapkan: `[*] postgresql connected to msf`

### 3. (Opsional) Memakai PostgreSQL service sistem
Hanya jika kamu memang ingin database terpusat. Aktifkan service, inisialisasi cluster sendiri, lalu jalankan `msfdb init --connection-string=...`.
```bash
sudo ln -s /etc/sv/postgresql /var/service/
sudo sv status postgresql
```
> ⚠️ `initdb` bawaan memakai autentikasi `trust` untuk koneksi lokal. Tinjau `pg_hba.conf` sebelum dipakai di mesin multi-user.

> 💡 **Catatan tentang "Kernel Panic" Easter Egg**:  
> Jika saat menjalankan `msfconsole` muncul teks palsu seperti `Unable to handle kernel NULL pointer dereference at virtual address 0xd34db33f` atau `M3 T4 SP L0 1T...`, **abaikan saja**. Itu adalah lelucon internal (Easter Egg) klasik dari developer Metasploit dan **bukan** berarti sistem kamu crash.

## 🔧 Troubleshooting

| Masalah | Solusi |
|---------|--------|
| `bundle install` gagal download gem | Pastikan network aktif di build chroot (jangan pakai flag `-N` pada `xbps-src`). |
| Gagal compile gem native | Cek `makedepends` di template (`libpq-devel`, `libpcap-devel`, `sqlite-devel`, `libxml2-devel`, `libxslt-devel`, `libffi-devel`, `openssl-devel`, `libyaml-devel`). |
| `LoadError: cannot load such file -- rex/socket` | Pastikan kamu menggunakan versi template terbaru yang menggunakan **wrapper script** di `/usr/bin/`, bukan symlink. Jalankan `xbps-install -Syu metasploit`. |
| `msfdb init`: `psql`/`createdb` is not in the environment path | Pasang `postgresql-client` (`sudo xbps-install postgresql-client`). Paket `metasploit` revisi 4+ sudah menyertakannya di `depends`. |
| Checksum mismatch | Jalankan `./fetch.sh <versi>` lalu build ulang. |

## ⚠️ Disclaimer
Package ini disediakan untuk tujuan edukasi dan penetration testing yang sah. Penggunaan untuk aktivitas ilegal adalah tanggung jawab pengguna sepenuhnya.

---
**Maintainer**: gh0st4n <darskevoid@gmail.com>  
**License**: BSD-3-Clause  
**Last Updated**: 2026