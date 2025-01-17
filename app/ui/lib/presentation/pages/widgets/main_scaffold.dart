// lib/presentation/pages/main_scaffold.dart

import 'package:flutter/material.dart';
import 'package:ui/presentation/pages/home_page/home_page.dart';
import 'package:ui/presentation/pages/search_page/search_page.dart';
import 'package:ui/presentation/pages/widgets/app_bottom_navigation_bar.dart';
import 'package:ui/presentation/pages/widgets/placeholder_page.dart';
import 'package:ui/presentation/pages/widgets/search_bar_input.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void _openSearch(String query) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SearchPage(),
        settings: RouteSettings(arguments: query),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Define the list of pages for scalability
  final List<Widget> _pages = const [
    HomePage(),
    PlaceholderPage(title: 'Profile'),
    PlaceholderPage(title: 'Cart'),
    PlaceholderPage(title: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _currentIndex == 0
            ? SearchBarInput(
                onSearch: _openSearch,
                hintText: 'Search on Somba.com',
              )
            : Text(
                _getAppBarTitle(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
        actions: _currentIndex == 0
            ? []
            : [
                IconButton(
                  icon: const Icon(Icons.search, semanticLabel: 'Search'),
                  onPressed: () => _showSearchModal(),
                ),
              ],
        automaticallyImplyLeading: false, // Remove back button for main scaffold
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          if (_currentIndex != index) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        physics: const NeverScrollableScrollPhysics(), // Disable swipe
        children: _pages,
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: _currentIndex,
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 1:
        return 'Profile';
      case 2:
        return 'Cart';
      case 3:
        return 'Settings';
      default:
        return '';
    }
  }

  void _showSearchModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: SearchBarInput(
            hintText: 'Search on Somba.com',
            onSearch: (query) {
              Navigator.pop(context); // Close the modal
              _openSearch(query);
            },
          ),
        );
      },
    );
  }
}