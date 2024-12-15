import 'package:flutter/material.dart';
import 'package:ui/presentation/pages/home_page/widgets/category_item.dart';
import 'package:ui/presentation/pages/home_page/widgets/home_search_bar.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  int selectedCategoryIndex = 0; // Track the selected category

  final List<String> categoryList = [
    'All',
    'Clothes',
    'Shoes',
    'Electronics',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeSearchBar(),
        const SizedBox(height: 10),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(), // Smooth scroll
            itemCount: categoryList.length,
            itemBuilder: (context, index) {
              return CategoryItem(
                title: categoryList[index],
                isSelected: selectedCategoryIndex == index,
                onTap: () {
                  setState(() {
                    selectedCategoryIndex = index;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
}