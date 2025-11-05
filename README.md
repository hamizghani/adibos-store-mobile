# adibos_store_mobile

Project demo sederhana untuk menampilkan tiga tombol produk dengan ikon, warna, dan Snackbar.

## Fitur yang ditambahkan

- Tiga tombol dengan ikon dan teks:
	- All Products (warna biru)
	- My Products (warna hijau)
	- Create Product (warna merah)
- Menampilkan Snackbar ketika masing-masing tombol ditekan.

## Penjelasan (jawaban pertanyaan pengguna)

### 1) Apa itu widget tree pada Flutter dan bagaimana hubungan parent-child (induk-anak) bekerja antar widget?

Widget tree adalah struktur hirarkis dari widget-widget yang membentuk antarmuka aplikasi Flutter. Setiap widget bisa menjadi parent (induk) yang memiliki satu atau lebih child (anak). Parent menentukan tata letak, batas, dan/atau perilaku untuk child-nya. Saat framework ingin menggambar layar, ia berjalan melalui widget tree, meminta setiap widget untuk membangun (build) bagian UI-nya. Jika state berubah, hanya subtree yang terpengaruh akan direbuild (tergantung pada tipe widget dan bagaimana state dikelola).

Hubungan parent-child bersifat eksplisit: parent menyisipkan instance child di dalam properti seperti `child:` atau `children: []`. Contoh: `Scaffold` adalah parent yang memiliki child `body`, dan `Column` sebagai parent yang memiliki daftar children (mis. beberapa `ElevatedButton`).

### 2) Sebutkan semua widget yang kamu gunakan dalam proyek ini dan jelaskan fungsinya

- `MaterialApp`: Root aplikasi, menyetel tema dan routing dasar.
- `Scaffold`: Struktur halaman (AppBar, body, floatingActionButton, dll.).
- `AppBar`: Bar atas aplikasi yang menampilkan judul.
- `Padding`: Memberi jarak di sekeliling child.
- `Column`: Menata widget secara vertikal.
- `ElevatedButton.icon`: Tombol bertingkat yang menampilkan ikon dan teks.
- `Icon`: Menampilkan ikon material.
- `Text`: Menampilkan teks.
- `SizedBox`: Memberi spasi vertikal kecil antar tombol.
- `SnackBar` (digunakan via `ScaffoldMessenger`): Menampilkan pesan sementara di bagian bawah layar.

Fungsi ringkas: kita menggunakan kombinasi widget di atas untuk membangun tata letak vertikal berisi tiga tombol yang memiliki ikon, warna khusus, dan menampilkan pesan singkat ketika ditekan.

### 3) Apa fungsi dari widget MaterialApp? Mengapa widget ini sering digunakan sebagai widget root?

`MaterialApp` menyediakan kerangka kerja aplikasi bergaya Material Design: tema (warna, tipografi), navigasi/route, lokalitas, dan konfigurasi tingkat aplikasi lain. Karena ia menginisialisasi banyak layanan dan penyedia tema yang umum dipakai (mis. `Theme.of(context)`, `Navigator`), `MaterialApp` sering digunakan sebagai widget root untuk aplikasi yang mengikuti prinsip Material Design agar widget lain dapat mengakses konfigurasi tersebut.

### 4) Jelaskan perbedaan antara StatelessWidget dan StatefulWidget. Kapan kamu memilih salah satunya?

- `StatelessWidget`: Widget yang tidak menyimpan state internal yang berubah seiring waktu. Build hanya bergantung pada input (parameter). Pilih `StatelessWidget` saat UI bersifat statis atau state dikelola dari luar (mis. parent atau state management seperti Provider).
- `StatefulWidget`: Widget yang memiliki objek `State` yang dapat berubah dan memicu rebuild. Gunakan saat widget perlu menyimpan state lokal (mis. nilai input, kontrol animasi, flag visibilitas).

Pilihan: gunakan `StatelessWidget` bila memungkinkan untuk menjaga kesederhanaan dan performa. Gunakan `StatefulWidget` bila diperlukan perubahan state internal.

### 5) Apa itu BuildContext dan mengapa penting di Flutter? Bagaimana penggunaannya di metode build?

`BuildContext` adalah objek yang mewakili lokasi widget di dalam widget tree. Ia dipakai untuk menemukan informasi dari tree seperti tema (`Theme.of(context)`), ukuran (`MediaQuery.of(context)`), atau untuk memanggil layanan seperti `ScaffoldMessenger.of(context)`. Di metode `build`, `BuildContext` diberikan sebagai parameter sehingga widget dapat mengakses parent/ancestors dan mengambil data atau melakukan operasi yang bergantung pada posisi widget dalam tree.

Contoh penggunaan di project ini: `ScaffoldMessenger.of(context).showSnackBar(...)` membutuhkan `context` untuk menemukan `Scaffold` terdekat agar Snackbar dapat ditampilkan.

### 6) Jelaskan konsep "hot reload" di Flutter dan bagaimana bedanya dengan "hot restart".

- Hot reload: Memuat ulang kode Dart ke aplikasi yang sedang berjalan, mempertahankan state aplikasi (mis. nilai variabel di `State`), dan memperbarui UI secara cepat. Cocok untuk iterasi UI/bugfix cepat.
- Hot restart: Meng-restart mesin Dart aplikasi, me-reset state aplikasi ke kondisi awal (inisialisasi ulang semua objek), lalu memulai kembali aplikasi. Berguna bila perubahan mempengaruhi inisialisasi global atau state yang tidak dapat di-refresh dengan hot reload.

Perbedaan utama: hot reload mempertahankan state, lebih cepat; hot restart mereset state dan memulai ulang aplikasi.

## Cara menjalankan (singkat)

1. Pastikan Flutter SDK terpasang dan path sudah diset.
2. Jalankan pada emulator atau perangkat:

```bash
flutter pub get
flutter run
```

Itu saja — sekarang ada tiga tombol di halaman utama yang menampilkan Snackbar berbeda saat ditekan.
