import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:adibos_store_mobile/config.dart';

class ItemDetailPage extends StatelessWidget {
  final int id;
  const ItemDetailPage({super.key, required this.id});

  Future<Map<String, dynamic>> _fetchDetail(BuildContext context) async {
    final request = context.read<CookieRequest>();
    final url = '$baseUrl/api/items/$id/';
    final resp = await request.get(url);
    return resp as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Item Detail')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchDetail(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          final item = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item['thumbnail'] != null && item['thumbnail'] != '')
                  Image.network(item['thumbnail']),
                const SizedBox(height: 12),
                Text(item['name'] ?? '', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text('Rp ${item['price'] ?? ''}', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('Category: ${item['category'] ?? ''}'),
                const SizedBox(height: 12),
                Text(item['description'] ?? ''),
                const SizedBox(height: 16),
                Text('Featured: ${item['is_featured'] == true ? 'Yes' : 'No'}'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
