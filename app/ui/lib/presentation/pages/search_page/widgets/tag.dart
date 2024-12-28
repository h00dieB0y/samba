import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final String text;
  final Color color;
  final double marginLeft;

  const Tag({
    super.key,
    required this.text,
    required this.color,
    this.marginLeft = 0.0,
  });

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.only(left: marginLeft),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
      );
}
