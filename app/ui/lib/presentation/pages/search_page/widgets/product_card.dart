// lib/presentation/pages/search_page/widgets/product_card.dart

import 'package:flutter/material.dart';
import 'package:ui/domain/entities/search_product_item_entity.dart';
import 'package:ui/presentation/pages/search_page/widgets/optional_tags.dart';
import 'package:ui/presentation/pages/search_page/widgets/product_brand.dart';
import 'package:ui/presentation/pages/search_page/widgets/product_image.dart';
import 'package:ui/presentation/pages/search_page/widgets/product_name.dart';
import 'package:ui/presentation/pages/search_page/widgets/product_price.dart';
import 'package:ui/presentation/pages/search_page/widgets/ratings_and_reviews.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({super.key, required this.product});

  final SearchProductItemEntity product;

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false; // Local state for favorite

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
            // Product Image with Favorites Icon
            ProductImage(
              product: widget.product,
              isFavorite: isFavorite,
              onFavoriteToggle: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isFavorite
                          ? '${widget.product.name} added to favorites.'
                          : '${widget.product.name} removed from favorites.',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
            const SizedBox(width: 10),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Optional Tags (e.g., Sponsored, Best Seller)
                  OptionalTags(product: widget.product),
                  const SizedBox(height: 5),

                  // Brand Name
                  ProductBrand(brand: widget.product.brand),
                  const SizedBox(height: 5),

                  // Product Name
                  ProductName(name: widget.product.name),
                  const SizedBox(height: 5),

                  // Price
                  ProductPrice(price: widget.product.price),
                  const SizedBox(height: 5),

                  // Ratings and Reviews
                  RatingsAndReviews(
                    rating: widget.product.rating,
                    reviewCount: widget.product.reviewCount,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
