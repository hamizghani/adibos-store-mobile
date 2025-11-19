import 'package:flutter/material.dart';
import 'package:adibos_store_mobile/models/product_entry.dart';
import 'package:adibos_store_mobile/screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:adibos_store_mobile/config.dart';

class ProductEntryCard extends StatelessWidget {
  final ProductEntry product;
  final VoidCallback onTap;

  const ProductEntryCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final thumb = product.fields.thumbnail;
    final title = product.fields.name;
    final content = product.fields.description;
    final category = product.fields.category;
    final isFeatured = product.fields.isFeatured;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: InkWell(
        onTap: () async {
          final request = context.watch<CookieRequest>();

          // If this product acts as a Logout action (name == "Logout"), perform logout
          if (product.fields.name == 'Logout') {
            // Use configured baseUrl and include trailing slash
            final response = await request.logout('$baseUrl/auth/logout/');
            String message = response["message"];
            if (context.mounted) {
                if (response['status']) {
                    String uname = response["username"];
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("$message See you again, $uname."),
                    ));
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(message),
                        ),
                    );
                }
            }
            return;
          }
          

          // otherwise, propagate the tap handler
          onTap();
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: thumb.isNotEmpty
                      ? Image.network(
                          thumb,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 150,
                            color: Colors.grey[300],
                            child: const Center(child: Icon(Icons.broken_image)),
                          ),
                        )
                      : Container(
                          height: 150,
                          color: Colors.grey[300],
                          child: const Center(child: Icon(Icons.image)),
                        ),
                ),
                const SizedBox(height: 8),

                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),

                // Category
                Text('Category: $category'),
                const SizedBox(height: 6),

                // Content preview
                Text(
                  content.length > 100 ? '${content.substring(0, 100)}...' : content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 6),

                // Featured indicator
                if (isFeatured)
                  const Text(
                    'Featured',
                    style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
