# Dependensi Runtime, `shlibs`, dan Paket Virtual

> **Ringkasan:** Memahami **apa saja yang perlu** dan **tidak perlu** ditulis di `depends`, bagaimana `xbps-src` mendeteksi library secara otomatis lewat berkas `common/shlibs`, dan bagaimana dependensi **virtual** bekerja.

---

## 1. Apa yang Dideteksi Otomatis?

Library yang di-*link* oleh objek ELF **terdeteksi otomatis** oleh `xbps-src`. Karena itu library tersebut **tidak boleh** ditulis di `depends`.

Dependensi runtime untuk objek ELF dideteksi dengan cara:

1. Memeriksa **SONAME** apa saja yang dibutuhkan objek ELF.
2. Memetakan SONAME ke **nama paket biner** beserta versi minimalnya.

> **SONAME** adalah nama "resmi" sebuah shared library, contoh `libfoo.so.1`.

---

## 2. Apa yang Harus Ditulis di `depends`?

Tulis di `depends` hal-hal yang **tidak terdeteksi otomatis**:

| Jenis | Contoh |
|---|---|
| Executable yang dipanggil sebagai proses terpisah | program pembantu yang dijalankan lewat `exec` |
| Objek ELF yang memakai `dlopen(3)` | plugin yang dimuat saat runtime |
| Kode non-objek | header C, modul perl/python/ruby, dll |
| File data | font, ikon, database |
| Menimpa versi minimal yang ditetapkan di `common/shlibs` | agar butuh versi lebih baru |

---

## 3. Berkas `common/shlibs`

Berkas `common/shlibs` berisi pemetaan `<SONAME> <pkgname>>=<version>`.

**Contoh kasus:** paket `foo-1.0_1` menyediakan SONAME `libfoo.so.1`. Perangkat lunak yang butuh library ini akan me-*link* ke `libfoo.so.1`, sehingga paket biner hasilnya otomatis punya dependensi runtime `foo>=1.0_1`, sesuai isi `common/shlibs`:

```
# common/shlibs
...
libfoo.so.1 foo-1.0_1
...
```

Arti kolom:

| Kolom | Isi |
|---|---|
| Kolom 1 | **SONAME** |
| Kolom 2 | **Nama paket dan versi minimal** yang dibutuhkan |
| Kolom 3 (opsional) | Biasanya bernilai `ignore`; dipakai untuk **melewati pemeriksaan** saat soname naik versi (*soname bump*) |

---

## 4. Perilaku `depends` saat Build

Dependensi yang dideklarasikan lewat `depends`:

- **tidak dipasang** ke master directory,
- hanya **diperiksa** keberadaannya sebagai paket biner,
- **dibangun otomatis** oleh `xbps-src` jika versi yang ditentukan tidak ada di repositori lokal.

---

## 5. Dependensi Virtual

Kadang beberapa paket yang berbeda menyediakan **fungsi yang sama**. Untuk kasus ini ada **paket virtual**.

### Langkah-langkahnya

**a. Penyedia** mendeklarasikan nama dan versi virtual di variabel `provides`:

```bash
provides="vpkg-0.1_1"
```

**b. Pengguna** (paket yang butuh fungsi tersebut tanpa peduli penyedianya) menulis dependensi dengan awalan **`virtual?`**:

```bash
depends="virtual?vpkg-0.1_1"
```

**c. Saat build**, `xbps-src` memastikan penyedia untuk paket virtual tersebut ada, dan membangunnya jika perlu.

### Siapa Penyedia Default?

- Pemetaan dari paket virtual ke **penyedia default** didefinisikan di `etc/defaults.virtual`.
- Pemetaan individual bisa **ditimpa** lewat preferensi lokal di `etc/virtual`.
- Komentar di `etc/defaults.virtual` memberi info lebih lanjut.

```
Paket A ──depends──► virtual?vpkg-0.1_1 ──(dipetakan ke)──► Penyedia 1  (default di etc/defaults.virtual)
                                                            Penyedia 2  (alternatif)
```

---

## 6. Ringkasan: Perlu `depends` atau Tidak?

| Kebutuhan | Tulis di `depends`? |
|---|---|
| Library yang di-link oleh ELF | **Tidak** (otomatis) |
| Program yang dipanggil lewat `exec`/`system` | **Ya** |
| Plugin yang dimuat lewat `dlopen` | **Ya** |
| Modul Python/Perl/Ruby | **Ya** |
| File data yang dibutuhkan saat runtime | **Ya** |
| Perlu versi library lebih tinggi daripada `common/shlibs` | **Ya** |

---

## Intinya

- Library hasil *link* ELF = otomatis; jangan masukkan ke `depends`.
- `common/shlibs` memetakan SONAME ke paket dan versi minimal.
- `depends` diisi untuk executable, `dlopen`, kode non-objek, dan file data.
- Paket virtual: `provides` di sisi penyedia, `virtual?nama` di sisi pengguna.

---

<!-- nav -->
[← Jenis-jenis Dependensi](../03_dependensi/01-jenis-dependensi.md) | [Daftar Isi](../DaftarISI.md) | [Build Style →](../04_proses-build/01-build-style.md)
