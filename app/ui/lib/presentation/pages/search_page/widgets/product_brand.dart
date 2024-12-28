import 'package:flutter/material.dart';

class ProductBrand extends StatelessWidget {
  final String brand;

  const ProductBrand({super.key, required this.brand});

  @override
  Widget build(BuildContext context) => Text(
        brand,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.blueGrey,
          fontWeight: FontWeight.w500,
        ),
      );
}