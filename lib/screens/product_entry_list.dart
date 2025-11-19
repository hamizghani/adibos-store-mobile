import 'package:flutter/material.dart';
import 'package:adibos_store_mobile/models/product_entry.dart';
import 'package:adibos_store_mobile/widgets/product_entry_card.dart';
import 'package:adibos_store_mobile/screens/product_detail.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:adibos_store_mobile/config.dart';

class ProductEntryListPage extends StatefulWidget {
  const ProductEntryListPage({super.key});

  @override
  State<ProductEntryListPage> createState() => _ProductEntryListPageState();
}

class _ProductEntryListPageState extends State<ProductEntryListPage> {
  Future<List<ProductEntry>> fetchProducts(CookieRequest request) async {
    // Use emulator URL for localhost
    final response = await request.get('$baseUrl/api/items/');

    var data = response;

    List<ProductEntry> list = [];
    for (var d in data) {
      if (d == null) continue;

      // Accept two possible formats:
      // 1) Dumpdata-like: {"model":..., "pk":..., "fields":{...}}
      // 2) API dict: {"id":..., "name":..., "price":..., "description":..., "thumbnail":..., "category":..., "is_featured":...}

      if (d.containsKey('pk') && d.containsKey('fields')) {
        list.add(ProductEntry.fromJson(Map<String, dynamic>.from(d)));
      } else {
        // construct ProductEntry manually
        final fields = Fields(
          owner: d['owner'],
          name: d['name'] ?? '',
          price: d['price'] is int ? d['price'] : (d['price']?.toInt() ?? 0),
          description: d['description'] ?? '',
          thumbnail: d['thumbnail'] ?? '',
          category: d['category'] ?? '',
          isFeatured: d['is_featured'] == true || d['is_featured'] == 1,
        );
        list.add(ProductEntry(model: Model.mainProduct, pk: d['id'] ?? d['pk'] ?? 0, fields: fields));
      }
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(title: const Text('Product List')),
      body: FutureBuilder<List<ProductEntry>>(
        future: fetchProducts(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) return const Center(child: Text('No products'));
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ProductEntryCard(
                product: item,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProductDetailPage(product: item)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
