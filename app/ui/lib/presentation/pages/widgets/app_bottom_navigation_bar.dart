import 'package:flutter/material.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar(
      {super.key, required this.onTap, required this.currentIndex});

  final Function(int) onTap;
  final int currentIndex;

  @override
  Widget build(BuildContext context) => BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: "Menu"
          ),
        ],
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.white, // Set the background color
        selectedItemColor: Colors.blue, // Set the color of the selected item
        unselectedItemColor:
            Colors.grey, // Set the color of the unselected items
      );
}
