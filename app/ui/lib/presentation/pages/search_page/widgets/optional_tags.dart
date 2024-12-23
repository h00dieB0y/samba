import 'package:flutter/material.dart';
import 'package:ui/domain/entities/search_product_item_entity.dart';
import 'package:ui/presentation/pages/search_page/widgets/tag.dart';

class OptionalTags extends StatelessWidget {
  final SearchProductItemEntity product;

  const OptionalTags({super.key, required this.product});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          if (product.isSponsored)
            const Tag(
              text: 'Sponsored',
              color: Colors.orangeAccent,
            ),
          if (product.isBestSeller)
            Tag(
              text: 'Best Seller',
              color: Colors.green,
              marginLeft: product.isSponsored ? 4.0 : 0.0,
            ),
        ],
      );
}
