import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';

class SocialSharing extends StatelessWidget {
  final String productUrl;
  final String productName;

  const SocialSharing({
    super.key,
    required this.productUrl,
    required this.productName,
  });

  void _share(BuildContext context, String platform) {
    String shareText = '$productName\n$productUrl';
    // Customize sharing based on platform if needed
    Share.share(shareText, subject: 'Check out this product!');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Text(
            'Share:',
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(FontAwesomeIcons.facebook, color: Colors.blue),
            onPressed: () => _share(context, 'facebook'),
            tooltip: 'Share on Facebook',
          ),
          IconButton(
            icon: Icon(FontAwesomeIcons.twitter, color: Colors.lightBlue),
            onPressed: () => _share(context, 'twitter'),
            tooltip: 'Share on Twitter',
          ),
          IconButton(
            icon: Icon(FontAwesomeIcons.pinterest, color: Colors.red),
            onPressed: () => _share(context, 'pinterest'),
            tooltip: 'Share on Pinterest',
          ),
        ],
      ),
    );
  }
}
