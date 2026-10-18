# Fungsi Global (Fungsi Bantu `v...`)

> **Ringkasan:** Kumpulan fungsi bantu dari `xbps-src` untuk memasang, menyalin, dan memindahkan file ke dalam paket dengan mudah. Semuanya berawalan huruf **`v`**.

---

## 1. Kenapa Perlu Fungsi Ini?

Daripada menulis `mkdir`, `cp`, `chmod`, dan `ln` manual yang rawan salah path, kamu cukup memanggil fungsi bantu. Fungsi-fungsi ini otomatis bekerja relatif terhadap direktori paket (`$DESTDIR`).

---

## 2. Tabel Ringkas

| Fungsi | Sintaks | Fungsi singkat |
|---|---|---|
| `vinstall` | `vinstall <file> <mode> <targetdir> [<name>]` | Pasang file dengan mode tertentu. |
| `vcopy` | `vcopy <pattern> <targetdir>` | Salin file secara rekursif. |
| `vmove` | `vmove <pattern>` | Pindahkan file. |
| `vmkdir` | `vmkdir <directory> [<mode>]` | Buat direktori. |
| `vbin` | `vbin <file> [<name>]` | Pasang executable ke `usr/bin`. |
| `vman` | `vman <file> [<name>]` | Pasang man page. |
| `vdoc` | `vdoc <file> [<name>]` | Pasang dokumentasi. |
| `vconf` | `vconf <file> [<name>]` | Pasang file konfigurasi ke `etc`. |
| `vsconf` | `vsconf <file> [<name>]` | Pasang contoh konfigurasi. |
| `vlicense` | `vlicense <file> [<name>]` | Pasang file lisensi. |
| `vsv` | `vsv <service> [<facility>]` | Pasang layanan runit. |
| `vsed` | `vsed -i <file> -e <regex>` | `sed` yang memeriksa apakah file benar-benar berubah. |
| `vcompletion` | `vcompletion <file> <shell> [<command>]` | Pasang *shell completion*. |
| `vextract` | `vextract [-C <dir>] [--strip-components=<n>] <file>` | Ekstrak arsip. |
| `vsrcextract` | `vsrcextract [-C <dir>] [--strip-components=<n>] <file>` | Ekstrak distfile dari `$XBPS_SRCDISTDIR`. |
| `vsrccopy` | `vsrccopy <file>... <target>` | Salin distfile dari `$XBPS_SRCDISTDIR`. |

---

## 3. Penjelasan Detail

### `vinstall`

```bash
vinstall <file> <mode> <targetdir> [<name>]
```

Memasang `file` dengan `mode` (izin akses) tertentu ke `targetdir` di dalam `$DESTDIR` paket. Argumen ke-4 yang opsional dipakai untuk **mengganti nama file**.

```bash
vinstall foo.sh 755 usr/libexec foo-helper
```

### `vcopy`

```bash
vcopy <pattern> <targetdir>
```

Menyalin **secara rekursif** semua file yang cocok dengan `pattern` ke `targetdir` di `$DESTDIR`.

### `vmove`

```bash
vmove <pattern>
```

Memindahkan `pattern` ke direktori yang ditentukan di `$DESTDIR` paket. Sering dipakai di subpackage untuk memindahkan file dari paket utama.

### `vmkdir`

```bash
vmkdir <directory> [<mode>]
```

Membuat direktori di `$DESTDIR` paket. Argumen ke-2 (opsional) mengatur mode direktori.

### `vbin`

```bash
vbin <file> [<name>]
```

Memasang `file` ke `usr/bin` dengan izin **`0755`**. Argumen ke-2 (opsional) untuk mengganti nama file.

```bash
vbin foo
vbin build/foo-cli foo
```

### `vman`

```bash
vman <file> [<name>]
```

Memasang `file` sebagai **man page**. `vman()` membaca nama file untuk menentukan **seksi** dan **lokalisasi** secara otomatis. Man page berformat `.gz` dan `.bz2` juga otomatis diubah menjadi teks biasa.

Contoh pemetaan:

| File sumber | Lokasi hasil |
|---|---|
| `foo.1` | `${DESTDIR}/usr/share/man/man1/foo.1` |
| `foo.fr.1` | `${DESTDIR}/usr/share/man/fr/man1/foo.1` |
| `foo.1p` | `${DESTDIR}/usr/share/man/man1/foo.1p` |
| `foo.1.gz` | `${DESTDIR}/usr/share/man/man1/foo.1` |
| `foo.1.bz2` | `${DESTDIR}/usr/share/man/man1/foo.1` |

### `vdoc`

```bash
vdoc <file> [<name>]
```

Memasang `file` ke `usr/share/doc/<pkgname>` di `$DESTDIR`. Argumen ke-2 (opsional) mengganti nama file.

### `vconf`

```bash
vconf <file> [<name>]
```

Memasang `file` ke folder `etc` di `$DESTDIR`. Argumen ke-2 (opsional) mengganti nama file.

### `vsconf`

```bash
vsconf <file> [<name>]
```

Memasang `file` ke `usr/share/examples/<pkgname>` di `$DESTDIR`. Biasanya untuk file **contoh** konfigurasi. Argumen ke-2 (opsional) mengganti nama file.

### `vlicense` <a id="vlicense"></a>

```bash
vlicense <file> [<name>]
```

Memasang `file` ke `usr/share/licenses/<pkgname>` di `$DESTDIR`. Argumen ke-2 (opsional) mengganti nama file. Lihat variabel [`license`](01-variabel-wajib.md#7-license) untuk mengetahui kapan fungsi ini wajib dipakai.

### `vsv`

```bash
vsv <service> [<facility>]
```

Memasang `service` dari `${FILESDIR}` ke `/etc/sv`.

- `service` harus berupa **direktori** yang minimal berisi skrip `run`.
- Symlink `supervise` dibuat **otomatis** oleh `vsv`.
- Skrip `run` otomatis dibuat *executable*.
- Sub-layanan **`log`** dibuat otomatis jika belum ada di `${FILESDIR}/$service`, berisi `exec vlogger -t $service -p $facility`.
- Jika argumen ke-2 tidak diberikan, *facility* **`daemon`** yang dipakai.

Panduan membuat direktori layanan ada di [FAQ runit](http://smarden.org/runit/faq.html#create). Info `vlogger` dan nilai *facility* ada di [vlogger(8)](https://man.voidlinux.org/vlogger.8). Lihat juga [Menulis Layanan runit](../06_skrip-dan-layanan/04-layanan-runit.md).

### `vsed`

```bash
vsed -i <file> -e <regex>
```

Pembungkus (*wrapper*) untuk `sed` yang **memeriksa hash SHA256 file sebelum dan sesudah** perintah dijalankan. Tujuannya mendeteksi kasus ketika `sed` ternyata **tidak mengubah apa pun** (biasanya tanda pola regex-nya sudah tidak cocok setelah versi baru).

- Menerima sejumlah file dan regex dengan mengulang `-i file` dan `-e regex`.
- Minimal harus ada **satu file** dan **satu regex**.
- `sed` dijalankan untuk **setiap regex terhadap setiap file**, sesuai urutan penulisan.

```bash
vsed -i Makefile -e 's|/usr/local|/usr|g' -e 's|-O3|-O2|g'
```

### `vcompletion`

```bash
vcompletion <file> <shell> [<command>]
```

Memasang *shell completion* dari `file` untuk `command`, di lokasi dan dengan nama file yang tepat sesuai `shell`.

- Jika `command` tidak diisi, defaultnya adalah `pkgname`.
- `shell` bisa berupa `bash`, `fish`, atau `zsh`.

### `vextract`

```bash
vextract [-C <target directory>] [--no-strip-components|--strip-components=<n>] <file>
```

Mengekstrak `file` ke `target directory` dengan membuang `n` tingkat direktori awal.

- Jika `target directory` tidak diisi, hasil diekstrak ke direktori kerja saat ini.
- Jika opsi `--strip-components`/`--no-strip-components` tidak diberikan, defaultnya `--strip-components=1`.

### `vsrcextract`

```bash
vsrcextract [-C <target directory>] [--no-strip-components|--strip-components=<n>] <file>
```

Sama seperti `vextract`, tetapi mengekstrak `$XBPS_SRCDISTDIR/$pkgname-$version/<file>`. Berguna bersama variabel `skip_extraction` dan untuk *distfile* submodul.

### `vsrccopy`

```bash
vsrccopy <file>... <target>
```

Menyalin `file` dari `$XBPS_SRCDISTDIR/$pkgname-$version/` ke direktori `target` (dibuat jika belum ada). Berguna bersama `skip_extraction`.

---

## 4. Aturan Penting: Kutip Wildcard

> Wildcard shell **harus dikutip** dengan benar.
>
> Contoh: `vmove "usr/lib/*.a"`

Tanpa tanda kutip, shell akan memperluas wildcard **sebelum** fungsi menerimanya, sehingga hasilnya bisa salah.

---

## 5. Contoh Pemakaian di Template

```bash
do_install() {
	vbin foo
	vman foo.1
	vdoc README.md
	vlicense LICENSE
	vconf foo.conf
}
```

---

## Fungsi Terkait di Bagian Lain

- `vopt_if`, `vopt_with`, `vopt_enable`, `vopt_conflict`, `vopt_bool`, `vopt_feature` → [Opsi Build](../04_proses-build/05-opsi-build.md)
- `vtargetrun` → [Build Helper](../04_proses-build/02-build-helper.md)

---

## Intinya

- Fungsi `v...` menyederhanakan pemasangan file ke `$DESTDIR`.
- `vbin`, `vman`, `vdoc`, `vlicense`, `vconf` adalah yang paling sering dipakai.
- Selalu **kutip wildcard**.
- `vsed` melindungimu dari `sed` yang diam-diam tidak berfungsi.

---

<!-- nav -->
[← Variabel Global](../02_dasar-template/02-variabel-global.md) | [Daftar Isi](../DaftarISI.md) | [Variabel Opsional: Sumber Kode →](../02_dasar-template/04-variabel-opsional-sumber-kode.md)
