import 'package:flutter/material.dart';
import 'package:ui/presentation/pages/home_page/widgets/category_list.dart';
import 'package:ui/presentation/pages/widgets/search_bar_input.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  void _handleSearch(BuildContext context, String query) {
    if (query.isEmpty) return;

    // Pass the query as a navigation argument
    Navigator.of(context).pushNamed(
      '/search',
      arguments: query,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchBarInput(
          hintText: 'Search on Somba.com',
          onSearch: (query) => _handleSearch(context, query),
        ),
        const SizedBox(height: 10),
        const CategoryList(),
      ],
    );
  }
}
