import 'package:flutter/material.dart';
import 'package:ui/domain/entities/review_entity.dart';
import '../../widgets/star_rating.dart';
import 'package:intl/intl.dart';

class ReviewTile extends StatelessWidget {
  final ReviewEntity review;

  const ReviewTile({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMMd().format(review.date.toLocal());

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Username and Verified Badge
            Row(
              children: [
                Text(
                  review.username,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  semanticsLabel: 'Review by ${review.username}',
                ),
                SizedBox(width: 8),
                if (review.isVerifiedPurchase)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Verified',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                      ),
                      semanticsLabel: 'Verified Purchase',
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            // Star Rating
            StarRating(rating: review.rating, size: 16.0),
            const SizedBox(height: 8),
            // Comment
            Text(
              review.comment,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              semanticsLabel: 'Review comment: ${review.comment}',
            ),
            const SizedBox(height: 8),
            // Date
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                formattedDate,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                semanticsLabel: 'Reviewed on $formattedDate',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
