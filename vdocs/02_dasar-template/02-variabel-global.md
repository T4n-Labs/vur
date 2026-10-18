# Variabel Global

> **Ringkasan:** Variabel yang **sudah disediakan otomatis oleh `xbps-src`** dan bisa langsung dipakai di template mana pun. Kamu tidak perlu mendefinisikannya sendiri.

---

## 1. Apa Bedanya dengan Variabel Wajib?

- **Variabel wajib / opsional**: *kamu* yang menulisnya di template (`pkgname`, `version`, dll).
- **Variabel global**: *`xbps-src`* yang menyediakannya. Kamu hanya **membaca/memakainya**.

---

## 2. Variabel tentang Paket dan Direktori

| Variabel | Arti |
|---|---|
| `sourcepkg` | Nama paket utama. Dipakai untuk mencocokkan paket utama, bukan nama paket biner tambahan (subpackage). |
| `DESTDIR` | Path lengkap ke *fake destdir* yang dipakai paket sumber: `<masterdir>/destdir/${sourcepkg}-${version}`. |
| `PKGDESTDIR` | Path lengkap ke *fake destdir* yang dipakai fungsi `pkg_install()` di subpackage: `<masterdir>/destdir/${pkgname}-${version}`. |
| `FILESDIR` | Path lengkap ke folder `files` milik paket, misalnya `srcpkgs/foo/files`. Dipakai untuk menyimpan file tambahan yang ikut dipasang. |
| `XBPS_BUILDDIR` | Direktori penyimpan kode sumber paket yang sedang diproses: `<masterdir>/builddir`. `wrksrc` selalu berada di sini, yaitu `${XBPS_BUILDDIR}/${wrksrc}`. |
| `XBPS_SRCDISTDIR` | Path lengkap tempat `distfiles` disimpan, contoh `$XBPS_HOSTDIR/sources`. |
| `XBPS_SRCPKGDIR` | Path lengkap ke folder `srcpkgs`. |
| `XBPS_WRAPPERDIR` | Path lengkap tempat *wrapper* utilitas milik `xbps-src` disimpan. |

---

## 3. Variabel tentang Proses Build

| Variabel | Arti |
|---|---|
| `makejobs` | Bernilai `-jX` jika `XBPS_MAKEJOBS` didefinisikan. Dipakai untuk build paralel dengan GNU make. |
| `CHROOT_READY` | Terisi jika chroot target (`masterdir`) sudah siap untuk build chroot. |
| `XBPS_CHECK_PKGS` | Terisi jika `xbps-src` akan menjalankan tes. Tes yang panjang sebaiknya **hanya dijalankan di `do_check()` jika nilainya `full`**. |
| `XBPS_FETCH_CMD` | Utilitas untuk mengunduh file dari server `ftp`, `http`, atau `https`. |
| `XBPS_BUILD_ENVIRONMENT` | Mengaktifkan operasi khusus *continuous integration*. Bernilai `void-packages-ci` jika berjalan di CI. |

---

## 4. Variabel tentang Mesin Pembangun (*Host*)

| Variabel | Arti |
|---|---|
| `XBPS_MACHINE` | Arsitektur mesin, sesuai keluaran `xbps-uhelper arch`. |
| `XBPS_ENDIAN` | *Endianness* mesin: `"le"` atau `"be"`. |
| `XBPS_LIBC` | Pustaka C mesin: `"glibc"` atau `"musl"`. |
| `XBPS_WORDSIZE` | Ukuran *word* mesin dalam bit: `32` atau `64`. |
| `XBPS_NO_ATOMIC8` | Terisi jika mesin **tidak punya** operasi atomik 64-bit native (butuh emulasi `libatomic`). |

---

## 5. Variabel untuk Cross-Compile

*Cross-compile* artinya membangun paket di satu arsitektur untuk dipakai di arsitektur lain (misalnya build di x86_64 untuk perangkat ARM).

| Variabel | Arti |
|---|---|
| `CROSS_BUILD` | Terisi jika `xbps-src` sedang melakukan cross compile. |
| `XBPS_TARGET_MACHINE` | Arsitektur mesin **target** saat cross compile. |
| `XBPS_TARGET_ENDIAN` | *Endianness* mesin target (`"le"`/`"be"`). |
| `XBPS_TARGET_LIBC` | Pustaka C mesin target (`"glibc"`/`"musl"`). |
| `XBPS_TARGET_WORDSIZE` | Ukuran *word* mesin target (`32`/`64`). |
| `XBPS_TARGET_NO_ATOMIC8` | Mesin target tidak punya atomik 64-bit native. |
| `XBPS_CROSS_BASE` | Path lengkap tempat dependensi cross-compile dipasang. Berbeda tergantung triplet arsitektur target, misalnya `aarch64` → `/usr/aarch64-linux-gnu`. |
| `XBPS_RUST_TARGET` | Triplet arsitektur target yang dipakai `rustc` dan `cargo`. |

---

## 6. Contoh Pemakaian

Contoh ilustrasi (bukan dari manual) cara variabel global dipakai di template:

```bash
pre_configure() {
	# Jalankan hanya saat cross compile
	if [ "$CROSS_BUILD" ]; then
		echo "Sedang cross compile untuk ${XBPS_TARGET_MACHINE}"
	fi
}

do_check() {
	# Tes yang berat hanya dijalankan jika XBPS_CHECK_PKGS=full
	if [ "$XBPS_CHECK_PKGS" = full ]; then
		make check-extended
	else
		make check
	fi
}
```

---

## Intinya

- Variabel global disediakan oleh `xbps-src`; kamu tinggal memakainya.
- `DESTDIR` = tempat hasil instalasi paket utama; `PKGDESTDIR` = tempat hasil instalasi subpackage.
- `FILESDIR` menunjuk ke folder `files` milik paket.
- Variabel berawalan `XBPS_TARGET_*` berlaku untuk mesin **target** saat cross compile.

---

<!-- nav -->
[← Variabel Wajib](../02_dasar-template/01-variabel-wajib.md) | [Daftar Isi](../DaftarISI.md) | [Fungsi Global (Fungsi Bantu `v...`) →](../02_dasar-template/03-fungsi-global.md)
