import 'package:flutter/material.dart';
import 'dart:async';

class PriceAndAvailability extends StatefulWidget {
  final String price;
  final String? oldPrice;
  final String? discount;
  final String stockStatus;
  final String shippingLabel;
  final DateTime? offerEndTime; // For limited-time offers

  const PriceAndAvailability({
    super.key,
    required this.price,
    this.oldPrice,
    this.discount,
    required this.stockStatus,
    required this.shippingLabel,
    this.offerEndTime,
  });

  @override
  _PriceAndAvailabilityState createState() => _PriceAndAvailabilityState();
}

class _PriceAndAvailabilityState extends State<PriceAndAvailability> {
  Timer? _timer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    if (widget.offerEndTime != null) {
      _updateTimer();
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        _updateTimer();
      });
    }
  }

  void _updateTimer() {
    final now = DateTime.now();
    if (widget.offerEndTime != null) {
      final difference = widget.offerEndTime!.difference(now);
      if (difference.isNegative) {
        setState(() {
          _timeLeft = Duration.zero;
        });
        _timer?.cancel();
      } else {
        setState(() {
          _timeLeft = difference;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String days = duration.inDays > 0 ? '${duration.inDays}d ' : '';
    String hours = twoDigits(duration.inHours.remainder(24));
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$days$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    TextStyle priceStyle = theme.textTheme.headlineSmall!.copyWith(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );

    TextStyle oldPriceStyle = theme.textTheme.bodyLarge!.copyWith(
      color: theme.colorScheme.onSurface.withOpacity(0.6),
      decoration: TextDecoration.lineThrough,
    );

    TextStyle discountStyle = theme.textTheme.labelMedium!.copyWith(
      color: theme.colorScheme.error,
      fontWeight: FontWeight.bold,
    );

    TextStyle stockStyle = theme.textTheme.titleMedium!.copyWith(
      color: widget.stockStatus.toLowerCase() == 'in stock'
          ? theme.colorScheme.primary
          : theme.colorScheme.error,
      fontWeight: FontWeight.bold,
    );

    TextStyle shippingStyle = theme.textTheme.labelMedium!.copyWith(
      color: theme.colorScheme.onSurface.withOpacity(0.7),
    );

    TextStyle countdownStyle = theme.textTheme.bodyMedium!.copyWith(
      color: theme.colorScheme.error,
      fontWeight: FontWeight.bold,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Price Row
        Row(
          children: [
            Text('\$${widget.price}', style: priceStyle),
            SizedBox(width: 8),
            if (widget.oldPrice != null)
              Text('\$${widget.oldPrice}', style: oldPriceStyle),
            SizedBox(width: 8),
            if (widget.discount != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.discount!,
                  style: discountStyle,
                ),
              ),
          ],
        ),
        if (widget.offerEndTime != null && _timeLeft > Duration.zero) ...[
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.timer, color: theme.colorScheme.error),
              SizedBox(width: 4),
              Text(
                'Offer ends in ${_formatDuration(_timeLeft)}',
                style: countdownStyle,
              ),
            ],
          ),
        ],
        SizedBox(height: 8),
        // Savings Information
        if (widget.oldPrice != null && widget.discount != null)
          Text(
            'You save \$${(double.parse(widget.oldPrice!) - double.parse(widget.price)).toStringAsFixed(2)} (${widget.discount!})',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.secondary,
            ),
            semanticsLabel:
                'You save \$${(double.parse(widget.oldPrice!) - double.parse(widget.price)).toStringAsFixed(2)} (${widget.discount!})',
          ),
        SizedBox(height: 8),
        // Stock Status
        Text(
          widget.stockStatus,
          style: stockStyle,
        ),
        SizedBox(height: 4),
        // Shipping Information
        Text(
          widget.shippingLabel,
          style: shippingStyle,
        ),
      ],
    );
  }
}
