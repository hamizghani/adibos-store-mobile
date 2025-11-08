import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adibos Store',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Halaman Utama'),
              onTap: () {
                Navigator.pop(context);
                // If already on home, this will simply close drawer; otherwise replace
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Tambah Produk'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddProductScreen()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Adibos Store'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.list),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text('All Products'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () => _showSnackbar(context, 'Kamu telah menekan tombol All Products'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.shopping_bag),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text('My Products'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () => _showSnackbar(context, 'Kamu telah menekan tombol My Products'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text('Tambah Produk'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // Navigate to Add Product form
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddProductScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _thumbnailController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  bool _isFeatured = false;

  String? _validateNotEmpty(String? v, String fieldName, {int? minLen, int? maxLen}) {
    if (v == null || v.trim().isEmpty) return '$fieldName tidak boleh kosong';
    final len = v.trim().length;
    if (minLen != null && len < minLen) return '$fieldName minimal $minLen karakter';
    if (maxLen != null && len > maxLen) return '$fieldName maksimal $maxLen karakter';
    return null;
  }

  String? _validatePrice(String? v) {
    if (v == null || v.trim().isEmpty) return 'Price tidak boleh kosong';
    final parsed = double.tryParse(v.replaceAll(',', '.'));
    if (parsed == null) return 'Price harus berupa angka';
    if (parsed <= 0) return 'Price harus lebih besar dari 0';
    return null;
  }

  String? _validateThumbnail(String? v) {
    final err = _validateNotEmpty(v, 'Thumbnail');
    if (err != null) return err;
    final uri = Uri.tryParse(v!.trim());
    if (uri == null || !uri.hasScheme || !(uri.scheme == 'http' || uri.scheme == 'https')) {
      return 'Thumbnail harus berupa URL yang valid (http/https)';
    }
    return null;
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final price = double.parse(_priceController.text.replaceAll(',', '.'));
      final description = _descriptionController.text.trim();
      final thumbnail = _thumbnailController.text.trim();
      final category = _categoryController.text.trim();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Data Produk'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Name: $name'),
                Text('Price: $price'),
                Text('Description: $description'),
                Text('Thumbnail: $thumbnail'),
                Text('Category: $category'),
                Text('Is Featured: ${_isFeatured ? 'Ya' : 'Tidak'}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Tutup dialog lalu kembali ke halaman sebelumnya (Home)
                Navigator.of(context).pop(); // close dialog
                Navigator.of(context).pop(); // pop AddProductScreen -> back to Home
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _thumbnailController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Halaman Utama'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Tambah Produk'),
              onTap: () {
                Navigator.pop(context);
                // already here maybe; do nothing or recreate
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const AddProductScreen()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(title: const Text('Tambah Produk')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => _validateNotEmpty(v, 'Name', minLen: 3, maxLen: 100),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: _validatePrice,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                validator: (v) => _validateNotEmpty(v, 'Description', minLen: 10, maxLen: 1000),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _thumbnailController,
                decoration: const InputDecoration(labelText: 'Thumbnail (URL)'),
                keyboardType: TextInputType.url,
                validator: _validateThumbnail,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (v) => _validateNotEmpty(v, 'Category', minLen: 2, maxLen: 50),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Checkbox(
                    value: _isFeatured,
                    onChanged: (val) => setState(() => _isFeatured = val ?? false),
                  ),
                  const Text('isFeatured'),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _onSave,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
