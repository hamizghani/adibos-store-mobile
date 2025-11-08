# TUGAS 1

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


# TUGAS 2

### 1) Perbedaan Navigator.push() dan Navigator.pushReplacement() — kapan digunakan?

- `Navigator.push(context, route)`: mendorong route baru ke atas stack navigator sehingga pengguna dapat kembali ke halaman sebelumnya dengan `Navigator.pop()`.
- `Navigator.pushReplacement(context, route)`: menggantikan route saat ini dengan route baru (route sebelumnya dihapus dari stack). Pengguna tidak dapat kembali ke route yang digantikan.

Kapan digunakan di aplikasi Adibos Store Shop:
- Gunakan `push` saat membuka halaman sementara seperti form tambah produk jika Anda ingin pengguna bisa menekan "back" untuk kembali ke halaman utama.
- Gunakan `pushReplacement` saat mengganti halaman root atau setelah login/logout, atau jika Anda ingin mencegah pengguna kembali ke halaman sebelumnya (mis. setelah menyelesaikan proses setup). Pada drawer di aplikasi ini saya menggunakan `pushReplacement` untuk opsi `Halaman Utama` agar memastikan navigasi konsisten tanpa menumpuk route duplicate.

### 2) Bagaimana memanfaatkan hierarchy widget seperti Scaffold, AppBar, dan Drawer untuk struktur halaman konsisten?

- `Scaffold` menyediakan layout dasar (AppBar, body, drawer, floatingActionButton) sehingga setiap halaman memiliki struktur yang seragam.
- `AppBar` menjaga konsistensi header/judul di setiap halaman.
- `Drawer` menyediakan navigasi global yang konsisten di seluruh halaman. Dengan menempatkan Drawer di `Scaffold` yang sama (atau pada setiap halaman), pengguna selalu melihat dan dapat mengakses menu yang sama.

Contoh dari aplikasi ini: baik `HomeScreen` maupun `AddProductScreen` memakai `Scaffold` + `AppBar` + `Drawer` sehingga tampilan dan navigasi tetap konsisten.

### 3) Kelebihan menggunakan layout widget seperti Padding, SingleChildScrollView, dan ListView pada form

- `Padding`: memberi jarak antar elemen sehingga UI tidak terasa sempit.
- `SingleChildScrollView`: memungkinkan konten form yang panjang dapat discroll ketika keyboard muncul atau pada layar kecil.
- `ListView`: efisien untuk daftar panjang dan menyediakan scrolling otomatis serta fitur builder.

Contoh penggunaan di aplikasi ini: pada `AddProductScreen` saya membungkus `Form` dengan `SingleChildScrollView` dan menambahkan `padding` agar form mudah dibaca dan tidak tertutup keyboard.

### 4) Menyesuaikan warna tema untuk identitas visual brand

- Gunakan `ThemeData` pada `MaterialApp` untuk mengatur `colorScheme`, `primaryColor`, `fontFamily`, dan style global lain. Pilih palet warna brand (mis. primary, secondary) dan gunakan konsisten di AppBar, tombol, dan elemen penting.
- Contoh di proyek ini: `ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue))` memberikan warna dasar biru;
