import 'package:flutter/material.dart';
import 'star_rating.dart';

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
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
        // Review Breakdown (Example: 5 Stars - 50%, etc.)
        ReviewBreakdown(rating: rating),
      ],
    );
  }
}

class ReviewBreakdown extends StatelessWidget {
  final double rating;

  const ReviewBreakdown({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    // Example data, replace with actual data
    final Map<int, double> breakdown = {
      5: 50.0,
      4: 30.0,
      3: 10.0,
      2: 5.0,
      1: 5.0,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: breakdown.entries.map((entry) {
        return Row(
          children: [
            Text('${entry.key}'),
            SizedBox(width: 4),
            Icon(Icons.star, color: Colors.orange, size: 16),
            SizedBox(width: 8),
            Expanded(
              child: LinearProgressIndicator(
                value: entry.value / 100,
                color: Colors.orange,
                backgroundColor: Colors.grey[300],
              ),
            ),
            SizedBox(width: 8),
            Text('${entry.value.toStringAsFixed(0)}%'),
          ],
        );
      }).toList(),
    );
  }
}
