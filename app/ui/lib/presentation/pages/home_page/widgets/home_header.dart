import 'package:flutter/material.dart';
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
            children: [
              categoryItem('All'),
              categoryItem('Fashion'),
              categoryItem('Electronics'),
              categoryItem('Home'),
              categoryItem('Beauty'),
              categoryItem('Toys'),
              categoryItem('Sports'),
              categoryItem('Books'),
            ],
          ),
        ),
      ],
    );

    Widget categoryItem(String title) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(title),
      ),
    );
  }
}
