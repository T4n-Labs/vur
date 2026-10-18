# Variabel Opsional: Pembatasan dan Pemeriksaan

> **Ringkasan:** Variabel untuk **membatasi build** (arsitektur, cross-compile, paket rusak, paket terbatas) dan untuk **menyesuaikan pemeriksaan otomatis** `xbps-src` (strip, PIE, dependensi, izin file).

> **Catatan pemula:** Sebagian besar variabel di bagian ini **jarang dibutuhkan**. Baca sekilas dulu, lalu kembali ke sini saat kamu menemui pesan error atau peringatan terkait.

---

## 1. Membatasi Build

### `archs`

Daftar arsitektur (dipisahkan spasi) yang boleh dipakai untuk membangun paket. Arsitektur yang tersedia ada di `common/cross-profiles`.

Umumnya `archs` hanya diatur jika upstream **secara eksplisit** menargetkan arsitektur tertentu, atau ada alasan kuat sehingga perangkat lunak tidak boleh tersedia di sebagian arsitektur yang didukung.

- Awalan **tilde (`~`)** pada pola berarti **melarang** build di arsitektur tersebut.
- **Pola pertama yang cocok** menentukan boleh/tidaknya build.
- Jika tidak ada pola yang cocok, paket tetap dibangun **bila pola terakhir mengandung tilde**.

```bash
# Build paket hanya untuk arsitektur musl
archs="*-musl"

# Build paket untuk x86_64-musl dan arsitektur non-musl apa pun
archs="x86_64-musl ~*-musl"

# Nilai default (semua arsitektur)
archs="*"
```

> Nilai khusus `noarch` dulu pernah tersedia, tapi sudah dihapus.

### `nocross`

Jika diatur, **cross-compile tidak diizinkan** dan proses langsung berhenti.

Nilainya sebaiknya berupa **string yang menjelaskan alasan gagal**, atau **link ke buildlog** dari *builder resmi* (log CI bisa hilang, jadi gunakan log dari builder resmi).

```bash
nocross="uses a build-time generated binary that cannot run on the host"
```

### `broken`

Jika diatur, build paket **tidak diizinkan** karena paket sedang dalam keadaan rusak. Nilainya sebaiknya string alasan atau link buildlog yang menunjukkan kegagalan.

```bash
broken="fails to build with the new compiler, see <link buildlog>"
```

### `restricted`

Jika diatur, `xbps-src` **menolak** membangun paket kecuali `etc/conf` berisi `XBPS_ALLOW_RESTRICTED=yes`.

Builder utama Void Linux **tidak** memakai pengaturan ini, sehingga repositori utama tidak akan memuat paket *restricted*. Berguna untuk paket yang lisensinya **melarang redistribusi**.

---

## 2. Debug dan Strip

| Variabel | Fungsi |
|---|---|
| `nodebug` | Jika aktif, paket `-dbg` **tidak dibuat** walaupun `XBPS_DEBUG_PKGS` diatur. |
| `nostrip` | Jika diatur, binary ELF yang punya simbol debug **tidak di-strip**. Default: semua binary di-strip. |
| `nostrip_files` | Daftar binary ELF (dipisahkan spasi) yang tidak akan di-strip. Boleh berupa path lengkap atau nama file. |

---

## 3. Pemeriksaan Shared Library dan Dependensi

| Variabel | Fungsi |
|---|---|
| `noshlibprovides` | Jika diatur, binary ELF **tidak diperiksa** untuk mengumpulkan soname yang disediakan oleh shared library. |
| `noverifyrdeps` | Jika diatur, binary ELF dan shared library **tidak diperiksa** untuk mengumpulkan dependensi balik (*reverse dependencies*). Kamu harus menuliskan **semua** dependensi di `depends`. |
| `skiprdeps` | Daftar file (path absolut di `$DESTDIR`, dipisahkan spasi) yang **tidak dipindai** untuk dependensi runtime. Berguna untuk file yang tidak dimaksudkan dijalankan/dimuat di host, melainkan dikirim ke perangkat target atau emulasi. |
| `shlib_provides` | Daftar soname **tambahan** yang disediakan paket. Ditambahkan ke file hasil generate, **bukan menggantikannya**. |
| `shlib_requires` | Daftar soname **tambahan** yang dibutuhkan paket. Ditambahkan ke file hasil generate, **bukan menggantikannya**. |

---

## 4. File Kode Mesin di `/usr/share`

Secara default file kode mesin (ELF) di `/usr/share` dianggap tidak wajar. Dua variabel ini memberi pengecualian:

| Variabel | Fungsi |
|---|---|
| `ignore_elf_files` | Daftar file kode mesin di `/usr/share` (path absolut, dipisahkan spasi) yang **memang diharapkan dan diizinkan**. |
| `ignore_elf_dirs` | Daftar direktori di `/usr/share` (path absolut, dipisahkan spasi) yang **diizinkan** berisi file kode mesin. |

---

## 5. Hardening (PIE, relro, dll.)

| Variabel | Fungsi |
|---|---|
| `nopie` | Cukup diisi nilai apa pun untuk mengaktifkan. **Menonaktifkan** build dengan fitur *hardening* (PIE, relro, dll). Tidak perlu untuk kebanyakan paket. |
| `nopie_files` | Daftar binary ELF yang **tidak diperiksa** untuk PIE. Harus berupa path lengkap. |

---

## 6. Izin File

| Variabel | Fungsi |
|---|---|
| `nocheckperms` | Jika diatur, `xbps-src` **tidak gagal** pada kesalahan izin yang umum (file *world writable*, dll). |
| `nofixperms` | Jika diatur, `xbps-src` **tidak memperbaiki** kesalahan izin yang umum (misalnya man page yang *executable*). |

---

## Tabel Ringkas "Kapan Dipakai?"

| Situasi | Variabel yang relevan |
|---|---|
| Paket hanya cocok untuk arsitektur tertentu | `archs` |
| Paket tidak bisa di-cross-compile | `nocross` |
| Paket sedang rusak dan tidak boleh dibangun | `broken` |
| Lisensi melarang redistribusi | `restricted` |
| Ingin menyimpan simbol debug | `nostrip`, `nostrip_files` |
| Dependensi tidak terdeteksi benar | `shlib_requires`, `skiprdeps`, `noverifyrdeps` |
| Ada file ELF "sah" di `/usr/share` | `ignore_elf_files`, `ignore_elf_dirs` |
| Hardening bermasalah | `nopie`, `nopie_files` |

---

## Intinya

- Pakai `archs`, `nocross`, `broken`, `restricted` untuk **membatasi** build.
- Pakai `nostrip*`, `nopie*`, `noshlibprovides`, `noverifyrdeps`, `ignore_elf_*`, `nocheckperms`, `nofixperms` hanya jika pemeriksaan otomatis menghalangi paket yang sebenarnya sah.
- Untuk `nocross` dan `broken`, selalu isi **alasan** atau link buildlog.

---

<!-- nav -->
[← Variabel Opsional: Metadata dan File Paket](../02_dasar-template/06-variabel-opsional-metadata.md) | [Daftar Isi](../DaftarISI.md) | [Jenis-jenis Dependensi →](../03_dependensi/01-jenis-dependensi.md)
