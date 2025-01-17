import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final double size;
  final Color color;
  final int maxRating;
  final bool allowHalfRating;

  const StarRating({
    super.key,
    required this.rating,
    this.size = 24.0,
    this.color = Colors.orange,
    this.maxRating = 5,
    this.allowHalfRating = true,
  });

  @override
  Widget build(BuildContext context) {
    int fullStars = rating.floor();
    bool hasHalfStar = allowHalfRating && (rating - fullStars) >= 0.5;

    List<Widget> stars = List.generate(maxRating, (index) {
      if (index < fullStars) {
        return Icon(Icons.star, color: color, size: size, semanticLabel: 'Full star');
      } else if (index == fullStars && hasHalfStar) {
        return Icon(Icons.star_half, color: color, size: size, semanticLabel: 'Half star');
      } else {
        return Icon(Icons.star_border, color: color, size: size, semanticLabel: 'Empty star');
      }
    });

    return Semantics(
      label: 'Rating: $rating out of $maxRating',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: stars,
      ),
    );
  }
}
