import 'package:flutter/material.dart';
import 'package:ui/presentation/pages/home_page/widgets/product_card.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible( // Use Flexible instead of Expanded
      child: GridView.builder(
        padding: const EdgeInsets.all(8), // Add padding to grid
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 columns
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75, // Adjust ratio for balanced height
        ),
        itemCount: 10,
        itemBuilder: (context, index) {
          return const ProductCard();
        },
      ),
    );
  }
}