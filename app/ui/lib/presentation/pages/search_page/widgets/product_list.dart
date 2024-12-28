import 'package:flutter/material.dart';
import 'package:ui/domain/entities/search_product_item_entity.dart';
import 'product_card.dart';

class ProductList extends StatelessWidget {
  final List<SearchProductItemEntity> products;

  const ProductList({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: const Key('product_list_view'),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(product: product);
      },
    );
  }
}
