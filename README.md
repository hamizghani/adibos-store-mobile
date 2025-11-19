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

Fungsi ringkas: saya menggunakan kombinasi widget di atas untuk membangun tata letak vertikal berisi tiga tombol yang memiliki ikon, warna khusus, dan menampilkan pesan singkat ketika ditekan.

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

# TUGAS 3
### 1) Mengapa kita perlu membuat model Dart saat mengambil/mengirim data JSON? Apa konsekuensinya jika hanya memakai Map<String, dynamic>?

Model Dart memberikan struktur yang jelas untuk data yang diterima atau dikirim dalam format JSON. Dengan model, setiap field memiliki tipe yang pasti sehingga validasi tipe dan null-safety dapat dilakukan sebelum data dipakai. Tanpa model, penggunaan Map<String, dynamic> membuat data tidak terjamin tipe-nya, rentan error runtime, sulit ditelusuri ketika field hilang/berubah, dan menurunkan maintainability karena tidak ada kontrak data yang eksplisit. Model juga memudahkan konversi otomatis melalui fromJson/toJson sehingga alur data lebih aman dan terorganisir.

### 2) Apa fungsi package http dan CookieRequest? Apa perbedaan perannya?

Package http menyediakan fungsi dasar untuk melakukan request HTTP seperti GET, POST, atau PUT tanpa manajemen sesi. Ia cocok untuk permintaan yang tidak membutuhkan autentikasi berbasis cookie.
Sebaliknya, CookieRequest menyimpan dan mengelola cookie sesi untuk menjaga keadaan login pengguna. Setiap request akan membawa cookie yang terasosiasi dengan user sehingga autentikasi dapat dipertahankan. Sederhananya: http untuk request stateless, sementara CookieRequest untuk request yang memerlukan session-based authentication.

### 3) Mengapa instance CookieRequest perlu dibagikan ke semua komponen Flutter?

Karena cookie menyimpan status autentikasi pengguna, setiap bagian aplikasi harus memakai instance yang sama agar sesi tetap konsisten. Jika setiap komponen membuat instance baru, cookie tidak akan terbawa dan pengguna dianggap logout setiap kali halaman berganti. Dengan membagikan instance yang sama (melalui Provider atau dependency injection), seluruh modul aplikasi membaca status login yang sama dan dapat mengakses endpoint Django yang membutuhkan autentikasi.

### 4) Konfigurasi konektivitas agar Flutter dapat berkomunikasi dengan Django

Flutter pada emulator Android mengakses host menggunakan alamat khusus 10.0.2.2, sehingga Django harus memasukkannya ke dalam ALLOWED_HOSTS agar request tidak ditolak. CORS perlu diaktifkan agar browser engine di Flutter mengizinkan komunikasi lintas origin. Pengaturan SameSite dan cookie diperlukan agar sesi dapat dibawa dari Flutter ke Django tanpa diblokir oleh mekanisme keamanan browser. Selain itu, Android perlu diizinkan mengakses internet melalui konfigurasi manifest. Jika konfigurasi tersebut salah, request akan gagal, cookie tidak terkirim, autentikasi tidak berfungsi, dan respons dari Django tidak dapat diterima.

### 5) Jelaskan mekanisme pengiriman data dari input sampai tampil di Flutter

Pengguna memasukkan data melalui form di Flutter, kemudian data tersebut dikirim sebagai JSON ke endpoint Django. Django memproses payload, melakukan validasi, dan menyimpannya ke database melalui model. Django kemudian mengirim respons JSON kembali ke Flutter. Flutter mengonversi data itu ke dalam model Dart menggunakan fromJson, kemudian menampilkannya di UI melalui widget yang membaca objek model tersebut.

### 6) Jelaskan mekanisme autentikasi login, register, dan logout

Untuk register, Flutter mengirim data akun ke endpoint Django. Django membuat user baru, lalu mengembalikan respons sukses. Untuk login, Flutter mengirim username dan password ke endpoint autentikasi Django. Jika benar, Django membuat sesi dan mengembalikan cookie melalui CookieRequest. Cookie tersebut dipakai pada setiap request berikutnya sebagai bukti bahwa pengguna telah login. Logout dilakukan dengan memanggil endpoint logout Django yang menghapus sesi user. Setelah sesi dihapus, Flutter memperbarui UI dengan menampilkan menu yang sesuai kondisi logout.

### 7) Jelaskan implementasi checklist secara step-by-step

Saya memulai dengan memastikan proyek Django telah berhasil dideploy. Setelah itu, saya membuat fitur registrasi dan login pada Flutter serta mengatur autentikasi menggunakan CookieRequest. Selanjutnya, saya menambahkan model kustom pada Django dan membuat endpoint JSON untuk menyediakan data item. Di Flutter, saya membuat halaman daftar item dengan mengambil data dari endpoint tersebut dan menampilkan field penting seperti name dan price. Lalu saya membuat halaman detail yang muncul saat item dipilih. Setelah itu, saya menerapkan filter agar daftar item hanya menampilkan data yang terkait dengan pengguna login. Terakhir, saya menjawab seluruh pertanyaan yang diperlukan di README sebagai dokumentasi teknis tugas.
