import 'package:flutter/material.dart';
import 'package:ui/presentation/pages/home_page/widgets/category_item.dart';
import 'package:ui/presentation/pages/home_page/widgets/home_search_bar.dart';


class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) => Column(
      children: [
        const HomeSearchBar(),
        // Category list
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              CategoryItem(title: 'All', icon: Icons.apps),
              CategoryItem(title: 'Clothes', icon: Icons.shopping_bag),
              CategoryItem(title: 'Shoes', icon: Icons.shopping_bag),
              CategoryItem(title: 'Electronics', icon: Icons.shopping_bag),
              CategoryItem(title: 'Furniture', icon: Icons.shopping_bag),
              CategoryItem(title: 'Books', icon: Icons.shopping_bag),
            ],
          ),
        ),
      ],
    );
}
