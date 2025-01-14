import 'package:flutter/material.dart';
import 'package:ui/presentation/pages/home_page/home_page.dart';

import 'search_page/search_page.dart';
import 'widgets/app_bottom_navigation_bar.dart';
import 'widgets/search_bar_input.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index);
    });
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _currentIndex == 0
            ? SearchBarInput(
                onSearch: _openSearch,
                hintText: 'Search on Somba.com',
              )
            : null,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        physics: const NeverScrollableScrollPhysics(),
        children: [
          HomePage(),
          _comingSoonPage('Profile'),
          _comingSoonPage('Cart'),
          _comingSoonPage('Settings'),
        ], // Disable swipe
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: _currentIndex,
      ),
    );
  }

  Widget _comingSoonPage(String title) {
    return Center(
      child: Text(
        '$title Page\nComing Soon...',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
