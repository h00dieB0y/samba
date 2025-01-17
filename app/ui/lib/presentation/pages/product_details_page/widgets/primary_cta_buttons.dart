import 'package:flutter/material.dart';

class PrimaryCTAButtons extends StatelessWidget {
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;
  final bool isOutOfStock;

  const PrimaryCTAButtons({
    super.key,
    required this.onAddToCart,
    required this.onBuyNow,
    this.isOutOfStock = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    final double buttonHeight = isMobile ? 50 : 60;
    final double fontSize = isMobile ? 16 : 18;

    return Column(
      children: [
        ElevatedButton(
          onPressed: isOutOfStock ? null : onAddToCart,
          style: ElevatedButton.styleFrom(
            backgroundColor: isOutOfStock ? theme.disabledColor : theme.colorScheme.primary,
            minimumSize: Size(double.infinity, buttonHeight),
            textStyle: TextStyle(fontSize: fontSize),
            elevation: isOutOfStock ? 0 : 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            isOutOfStock ? 'Out of Stock' : 'Add to Cart',
            style: TextStyle(
              color: isOutOfStock ? theme.colorScheme.onSurface : theme.colorScheme.onPrimary,
            ),
          ),
        ),
        SizedBox(height: 12),
        OutlinedButton(
          onPressed: isOutOfStock ? null : onBuyNow,
          style: OutlinedButton.styleFrom(
            minimumSize: Size(double.infinity, buttonHeight),
            side: BorderSide(
              color: isOutOfStock ? theme.disabledColor : theme.colorScheme.primary,
            ),
            textStyle: TextStyle(fontSize: fontSize),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Buy Now',
            style: TextStyle(
              color: isOutOfStock ? theme.disabledColor : theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
