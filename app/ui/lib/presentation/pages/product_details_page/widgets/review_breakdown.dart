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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: reviewBreakdown.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child: Row(
                  children: List.generate(
                    entry.key,
                    (index) => Icon(Icons.star, color: theme.colorScheme.secondary, size: 16),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: LinearProgressIndicator(
                  value: entry.value / reviewBreakdown.values.reduce((a, b) => a + b),
                  minHeight: 8,
                  color: theme.colorScheme.secondary,
                  backgroundColor: theme.dividerColor,
                ),
              ),
              SizedBox(width: 8),
              Text('${entry.value}%', style: theme.textTheme.bodyMedium),
            ],
          ),
        );
      }).toList(),
    );
  }
}
