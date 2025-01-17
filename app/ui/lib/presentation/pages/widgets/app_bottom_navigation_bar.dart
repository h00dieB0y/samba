import 'package:flutter/material.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final Function(int) onTap;
  final int currentIndex;

  const AppBottomNavigationBar({
    super.key,
    required this.onTap,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) => BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, semanticLabel: 'Home'),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, semanticLabel: 'Profile'),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, semanticLabel: 'Cart'),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu, semanticLabel: 'Menu'),
            label: 'Menu',
          ),
        ],
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        iconSize: 24,
        elevation: 8,
      );
}
