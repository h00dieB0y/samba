import 'package:flutter/material.dart';
import 'package:ui/domain/entities/search_product_item_entity.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final SearchProductItemEntity product;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1), // Subtle shadow
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Hero animation and Favorites Icon
            Stack(
              children: [
                Hero(
                  tag: 'productImage-${product.id}', // Stable Hero tag
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      "assets/images/placeholder-image.png",
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Favorites Icon at the Left Bottom
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: GestureDetector(
                    onTap: () {
                      // Implement favorite functionality
                      // For example, toggle favorite state
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 16,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Optional Tags (e.g., Sponsored, Best Seller)
                  Row(
                    children: [
                      if (product.isSponsored)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Sponsored',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      if (product.isBestSeller)
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Best Seller',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  // Brand Name
                  Text(
                    product.brand,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Product Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 5),

                  // Price
                  Text(
                    product.price,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Ratings and Reviews
                  Row(
                    children: [
                      _buildStarRating(product.rating),
                      const SizedBox(width: 5),
                      Text(
                        '(${product.reviewCount})',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );

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
}
