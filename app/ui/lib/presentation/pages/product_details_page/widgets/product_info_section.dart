import 'package:flutter/material.dart';
import 'package:ui/domain/entities/product_details_entity.dart';
import 'price_and_availability.dart';
import 'primary_cta_buttons.dart';
import 'product_title_and_rating.dart';

class ProductInfoSection extends StatelessWidget {
  final ProductDetailsEntity product;

  const ProductInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductTitleAndRating(
          productName: product.name,
          brandName: product.brand,
          rating: product.rating,
          reviewCount: product.reviewCount,
          reviewBreakdown: product.ratingDistribution,
        ),
        SizedBox(height: 8),
        PriceAndAvailability(
          price: product.price,
          oldPrice: product.oldPrice,
          discount: product.discount,
          stockStatus: product.stockStatus,
          shippingLabel: product.shippingLabel,
          offerEndTime: product.offerEndTime, // Pass offer end time if any
        ),
        SizedBox(height: 16),
        PrimaryCTAButtons(
          onAddToCart: () {
            // Handle Add to Cart functionality
          },
          onBuyNow: () {
            // Handle Buy Now functionality
          },
          isOutOfStock: product.stockStatus.toLowerCase() != 'in stock',
        ),
      ],
    );
  }
}
