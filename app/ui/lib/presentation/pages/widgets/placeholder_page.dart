import 'package:flutter/material.dart';

class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$title Page\nComing Soon...',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
