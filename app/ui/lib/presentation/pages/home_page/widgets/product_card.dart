import 'package:flutter/material.dart';
import 'package:ui/domain/entities/product_item_entity.dart';

class ProductCard extends StatelessWidget {

  final ProductItemEntity product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          // Navigate to product details (example navigation placeholder)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Placeholder()),
          );
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 6,
                offset: const Offset(0, 2), // Soft shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with Hero animation
              Hero(
                tag: 'productImage', // Unique tag for smooth navigation animation
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/placeholder-image.png',
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Shop Name
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
            ],
          ),
        ),
      );
}