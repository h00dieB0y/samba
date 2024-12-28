import 'package:flutter/material.dart';

class ProductPrice extends StatelessWidget {
  final String price;

  const ProductPrice({Key? key, required this.price}) : super(key: key);

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
