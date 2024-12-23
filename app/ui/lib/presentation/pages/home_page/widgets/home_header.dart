// home_header.dart

import 'package:flutter/material.dart';
import 'package:ui/presentation/pages/home_page/widgets/category_list.dart';
import 'package:ui/presentation/widgets/search_bar_input.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchBarInput(hintText: 'Search on Somba.com', onSearch: (query) {}),
        const SizedBox(height: 10),
        const CategoryList(),
      ],
    );
  }
}
