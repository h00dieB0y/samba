import 'package:flutter/material.dart';
import 'package:ui/presentation/pages/widgets/star_rating.dart';

class RatingsAndReviews extends StatelessWidget {
  final double rating;
  final int reviewCount;

  const RatingsAndReviews({
    super.key,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          StarRating(rating: rating, size: 16),
          const SizedBox(width: 5),
          Text(
            '($reviewCount)',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.blueGrey,
            ),
          ),
        ],
      );
}
