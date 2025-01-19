import 'package:flutter/material.dart';

class ProductPrice extends StatelessWidget {
  final String price;

  const ProductPrice({super.key, required this.price});

  @override
  Widget build(BuildContext context) => Text(
        price,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.green,
          fontWeight: FontWeight.w600,
        ),
      );
}
