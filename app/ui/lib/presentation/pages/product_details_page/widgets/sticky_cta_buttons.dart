import 'package:flutter/material.dart';

class StickyCTAButtons extends StatelessWidget {
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;
  final bool isOutOfStock;

  const StickyCTAButtons({
    super.key,
    required this.onAddToCart,
    required this.onBuyNow,
    this.isOutOfStock = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Social Proof Text
          if (!isOutOfStock)
            Text(
              'Added to Cart by 1000+ users today',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          SizedBox(height: 8),
          // CTA Buttons
          ElevatedButton(
            onPressed: isOutOfStock ? null : onAddToCart,
            style: ElevatedButton.styleFrom(
              backgroundColor: isOutOfStock
                  ? Theme.of(context).disabledColor
                  : Theme.of(context).colorScheme.primary,
              minimumSize: Size(double.infinity, 50),
              textStyle: TextStyle(fontSize: 16),
              elevation: isOutOfStock ? 0 : 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              isOutOfStock ? 'Out of Stock' : 'Add to Cart',
              style: TextStyle(
                color: isOutOfStock
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          SizedBox(height: 8),
          OutlinedButton(
            onPressed: isOutOfStock ? null : onBuyNow,
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
              side: BorderSide(
                color: isOutOfStock
                    ? Theme.of(context).disabledColor
                    : Theme.of(context).colorScheme.primary,
              ),
              textStyle: TextStyle(fontSize: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Buy Now',
              style: TextStyle(
                color: isOutOfStock
                    ? Theme.of(context).disabledColor
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
