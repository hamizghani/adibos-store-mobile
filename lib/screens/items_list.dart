import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:adibos_store_mobile/config.dart';
import 'item_detail.dart';

class ItemsListPage extends StatelessWidget {
  final bool showMine;
  const ItemsListPage({super.key, required this.showMine});

  Future<List<dynamic>> _fetchItems(BuildContext context) async {
    final request = context.read<CookieRequest>();
    String url = '$baseUrl/api/items/';
    if (showMine) url += '?mine=1';
    final resp = await request.get(url);
    return resp as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(showMine ? 'My Products' : 'All Products')),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchItems(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) return const Center(child: Text('No items'));
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index] as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  leading: item['thumbnail'] != null && item['thumbnail'] != ''
                      ? Image.network(item['thumbnail'], width: 56, height: 56, fit: BoxFit.cover)
                      : const SizedBox(width: 56, height: 56, child: Icon(Icons.image)),
                  title: Text(item['name'] ?? 'No name'),
                  subtitle: Text('Rp ${item['price'] ?? ''} — ${item['category'] ?? ''}'),
                  trailing: item['is_featured'] == true ? const Icon(Icons.star, color: Colors.amber) : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ItemDetailPage(id: item['id'])),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
