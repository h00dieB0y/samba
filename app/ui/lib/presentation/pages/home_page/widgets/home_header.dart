// home_header.dart

import 'package:flutter/material.dart';
import 'package:ui/presentation/pages/home_page/widgets/category_list.dart';
import 'package:ui/presentation/pages/home_page/widgets/home_search_bar.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSearchBar(),
        SizedBox(height: 10),
        CategoryList(),
      ],
    );
  }
}
