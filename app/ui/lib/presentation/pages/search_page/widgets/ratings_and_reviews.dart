import 'package:flutter/material.dart';

class RatingsAndReviews extends StatelessWidget {
  final double rating;
  final int reviewCount;

  const RatingsAndReviews({
    super.key,
    required this.rating,
    required this.reviewCount,
  });

  // Helper method to build star ratings
  Widget _buildStarRating(double rating) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      if (i <= rating.floor()) {
        stars.add(const Icon(Icons.star, size: 16, color: Colors.amber));
      } else if (i - rating < 1) {
        stars.add(const Icon(Icons.star_half, size: 16, color: Colors.amber));
      } else {
        stars.add(const Icon(Icons.star_border, size: 16, color: Colors.amber));
      }
    }
    return Row(children: stars);
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          _buildStarRating(rating),
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
