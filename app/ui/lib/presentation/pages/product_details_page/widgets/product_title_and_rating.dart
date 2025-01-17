import 'package:flutter/material.dart';
import 'package:ui/presentation/pages/product_details_page/widgets/review_breakdown.dart';
import '../../widgets/star_rating.dart';

class ProductTitleAndRating extends StatelessWidget {
  final String productName;
  final String brandName;
  final double rating;
  final int reviewCount;

  const ProductTitleAndRating({
    super.key,
    required this.productName,
    required this.brandName,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          brandName,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
          ),
          semanticsLabel: 'Brand: $brandName',
        ),
        const SizedBox(height: 4),
        Text(
          productName,
          style:
              theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          semanticsLabel: 'Product Name: $productName',
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            StarRating(rating: rating, size: 24.0),
            const SizedBox(width: 8),
            InkWell(
              onTap: () {
                // Scroll to Reviews Section or navigate to Reviews
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  '($reviewCount reviews)',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                  semanticsLabel: '$reviewCount reviews',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ReviewBreakdown(
          rating: rating,
          reviewBreakdown: {
            5: 80,
            4: 15,
            3: 3,
            2: 1,
            1: 1,
          },
        ),
      ],
    );
  }
}
