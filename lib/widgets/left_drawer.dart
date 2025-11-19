import 'package:flutter/material.dart';
import 'package:adibos_store_mobile/screens/home.dart';
import 'package:adibos_store_mobile/screens/product_entry_list.dart';
import 'package:adibos_store_mobile/screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:adibos_store_mobile/config.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Drawer(
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
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('Product List'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProductEntryListPage()),
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
          const Divider(),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Login'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              Navigator.pop(context);
              // Perform logout via CookieRequest
              final response = await request.logout('$baseUrl/auth/logout/');
              final message = response['message'] ?? '';
              if (context.mounted) {
                if (response['status'] == true) {
                  final uname = response['username'] ?? '';
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$message See you again, $uname.')));
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
