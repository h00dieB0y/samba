import 'package:flutter/material.dart';
import 'package:ui/domain/entities/search_product_item_entity.dart';
import 'package:ui/presentation/pages/search_page/widgets/product_card.dart';
import 'package:ui/presentation/widgets/app_bottom_navigation_bar.dart';
import 'package:ui/presentation/widgets/search_bar_input.dart';
import 'dart:math';

class SearchPage extends StatelessWidget {
  final random = Random();

  SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SearchBarInput(
                hintText: 'Search on Somba.com', onSearch: (query) {}),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ProductCard(
                    product: SearchProductItemEntity(
                        id: 'product-$index',
                        name: 'Product Name $index',
                        brand: 'Brand Name $index',
                        price: '\$${(index + 1) * 10}',
                        rating: random.nextDouble() * 5,
                        reviewCount: 120,
                        isSponsored: (index % 3 == 0),
                        isBestSeller: (index % 4 == 0 || index % 5 == 0)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        onTap: (index) {
          // Handle navigation on tap
        },
        currentIndex: 0,
      ),
    );
  }
}
