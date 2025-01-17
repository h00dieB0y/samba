import 'package:flutter/material.dart';

class ReviewBreakdown extends StatelessWidget {
  final double rating;
  final Map<int, int> reviewBreakdown;

  const ReviewBreakdown({
    super.key,
    required this.rating,
    required this.reviewBreakdown,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalReviews = reviewBreakdown.values.fold(0, (a, b) => a + b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: reviewBreakdown.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Row(
                key: Key('star_rating_$entry.key'),
                children: List.generate(
                  entry.key,
                  (index) => Icon(Icons.star, color: theme.colorScheme.secondary, size: 16),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LinearProgressIndicator(
                  value: entry.value / totalReviews,
                  minHeight: 8,
                  color: theme.colorScheme.secondary,
                  backgroundColor: theme.dividerColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${entry.value}%',
                style: theme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}