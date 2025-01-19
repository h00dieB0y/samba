import 'package:flutter/material.dart';
import 'package:ui/domain/entities/related_product_entity.dart';
import 'related_product_card.dart';

class RelatedProductsSection extends StatelessWidget {
  final List<RelatedProductEntity> relatedProducts;

  const RelatedProductsSection({super.key, required this.relatedProducts});

  @override
  Widget build(BuildContext context) {


    if (relatedProducts.isEmpty) return SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Related Products',
            style: Theme.of(context).textTheme.titleLarge,
            semanticsLabel: 'Related Products Section',
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: relatedProducts.length,
              separatorBuilder: (context, index) => SizedBox(width: 16),
              itemBuilder: (context, index) {
                return RelatedProductCard(product: relatedProducts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
