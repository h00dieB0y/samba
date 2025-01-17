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
    final shareText = '$productName\n$productUrl';
    Share.share(shareText, subject: 'Check out this product!');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Shared via $platform')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final platforms = [
      {
        'icon': FontAwesomeIcons.facebook,
        'color': Colors.blue,
        'name': 'Facebook',
      },
      {
        'icon': FontAwesomeIcons.twitter,
        'color': Colors.lightBlue,
        'name': 'Twitter',
      },
      {
        'icon': FontAwesomeIcons.pinterest,
        'color': Colors.red,
        'name': 'Pinterest',
      },
      {
        'icon': FontAwesomeIcons.linkedin,
        'color': Colors.blueAccent,
        'name': 'LinkedIn',
      },
      {
        'icon': FontAwesomeIcons.whatsapp,
        'color': Colors.green,
        'name': 'WhatsApp',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Text(
            'Share:',
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          ...platforms.map((platform) => IconButton(
                icon: Icon(platform['icon'] as IconData, color: platform['color'] as Color),
                onPressed: () => _share(context, platform['name'] as String),
                tooltip: 'Share on ${platform['name']}',
              )),
        ],
      ),
    );
  }
}
