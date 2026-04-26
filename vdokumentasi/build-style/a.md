# Build-Style

**build-style** adalah variabel di dalam file template paket yang menentukan metode atau skrip build otomatis yang akan digunakan untuk mengompilasi dan menginstal perangkat lunak. Ini berfungsi menyederhanakan pembuatan paket dengan menggunakan template standar untuk berbagai jenis sistem build umum, seperti `gnu-configure`, `cmake`, `python3`, atau `go`. 

Poin Penting tentang build-style:

- Otomatisasi: Dengan menetapkan **build-style** (misalnya, build-style=cmake), **xbps-src** secara otomatis menangani tahapan configure, build, dan install tanpa perlu menulis perintah manual di file template.
- Standarisasi: Memastikan paket dibangun dengan cara yang konsisten sesuai standar Void Linux.
- Kustomisasi: Jika paket memerlukan langkah khusus yang tidak tercakup oleh **build-style** standar, pembuat paket bisa mengosongkannya dan mendefinisikan fungsi **do_build()** sendiri.