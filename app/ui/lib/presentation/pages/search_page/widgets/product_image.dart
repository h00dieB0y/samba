
import 'package:flutter/material.dart';
import 'package:ui/domain/entities/search_product_item_entity.dart';

class ProductImage extends StatelessWidget {
  final SearchProductItemEntity product;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const ProductImage({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 100, // Fixed width
        height: 100, // Fixed height
        child: Stack(
          children: [
            // Product Image with Hero animation
            GestureDetector(
              onTap: () {
                // Navigate to ProductDetailPage
                
              },
              child: Hero(
                tag: 'productImage-${product.id}', // Stable Hero tag
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    "assets/images/placeholder-image.png",
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            // Favorites Icon at the Top Right
            Positioned(
              bottom: 8,
              left: 8,
              child: InkWell(
                onTap: onFavoriteToggle,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 16,
                    color: Colors.red,
                    semanticLabel:
                        isFavorite ? 'Remove from favorites' : 'Add to favorites',
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
