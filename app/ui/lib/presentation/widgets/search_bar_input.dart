import 'package:flutter/material.dart';

class SearchBarInput extends StatelessWidget {
  const SearchBarInput({super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search on Somba.com',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}