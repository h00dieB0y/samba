import 'package:flutter/material.dart';
import 'package:ui/domain/entities/product_details_entity.dart';
import 'package:ui/presentation/pages/product_details_page/widgets/customer_qn_a.dart';
import 'package:ui/presentation/pages/product_details_page/widgets/social_sharing.dart';
import 'package:ui/presentation/pages/search_page/search_page.dart';
import 'package:ui/presentation/pages/widgets/app_bottom_navigation_bar.dart';
import 'widgets/collapsible_sections.dart';
import 'widgets/product_info_section.dart';
import 'widgets/product_media_carousel.dart';
import 'widgets/related_products_section.dart';

class ProductDetailsPage extends StatelessWidget {
  final ProductDetailsEntity product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductMediaCarousel(images: product.images),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ProductInfoSection(product: product),
                ),
                RelatedProductsSection(
                  relatedProducts: product.relatedProducts,
                ),
                CollapsibleSections(product: product),
                SocialSharing(
                  productName: product.name,
                  productUrl: "https://example.com/product/${product.id}",
                ),
              ],
            ),
          ),
          // Floating Search Icon positioned at the top-right corner
          Positioned(
            top: MediaQuery.of(context).padding.top +
                16, // Adjust for status bar
            right: 16,
            child: Semantics(
              label: 'Search',
              button: true,
              child: FloatingActionButton(
                onPressed: () {
                  // Navigate to the SearchPage when tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SearchPage()),
                  );
                },
                backgroundColor:
                    theme.colorScheme.surface.withValues(alpha: 0.9),
                elevation: 4,
                tooltip: 'Search',
                child: Icon(
                  Icons.search,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle bottom navigation taps
        },
      ),
    );
  }
}
