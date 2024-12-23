import 'package:flutter/material.dart';
import 'package:ui/presentation/widgets/app_bottom_navigation_bar.dart';
import 'package:ui/presentation/widgets/search_bar_input.dart';


class SearchPage extends StatelessWidget {

  const SearchPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SearchBarInput(hintText: 'Search on Somba.com', onSearch: (query) {}),
            const SizedBox(height: 10),
            Expanded(
              child: const SizedBox(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        onTap: (index) {
          // Handle navigation on tap
        },
        currentIndex: 0,
      ),
    );
  }
  
}