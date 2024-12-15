import 'package:flutter/material.dart';
import 'package:ui/presentation/pages/home_page/widgets/home_header.dart';
import 'package:ui/presentation/pages/home_page/widgets/product_grid.dart';
import 'package:ui/presentation/widgets/app_bottom_navigation_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SafeArea(
        child: Column(
          children: [
            HomeHeader(),
            ProductGrid(),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(onTap: (index) {
        // Handle navigation on tap
      }, currentIndex: 0),
    );
  }
}
