import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/presentation/pages/home_page/widgets/home_header.dart';
import 'package:ui/presentation/pages/home_page/widgets/category_item.dart';
import 'package:ui/presentation/pages/home_page/widgets/home_search_bar.dart';

void main() {
  group('HomeHeader Widget Tests', () {
    testWidgets('renders HomeHeader without errors', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HomeHeader(),
          ),
        ),
      );

      // Act & Assert
      // 1. Verify HomeSearchBar is present.
      expect(find.byType(HomeSearchBar), findsOneWidget);

      // 2. Verify four CategoryItem widgets are present.
      expect(find.byType(CategoryItem), findsNWidgets(4));
    });

    testWidgets('tapping on a category changes the selected category',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HomeHeader(),
          ),
        ),
      );

      // The category items should be: [All, Clothes, Shoes, Electronics].
      // By default, index 0 ("All") is selected.

      // Act
      // Find all CategoryItem widgets.
      final categoryItems = find.byType(CategoryItem);
      // Verify there are 4 items.
      expect(categoryItems, findsNWidgets(4));

      // Initially, the first item ("All") should be selected.
      CategoryItem allCategory = tester.widget<CategoryItem>(categoryItems.at(0));
      expect(allCategory.isSelected, isTrue);

      // Tap the third category ("Shoes", index 2).
      await tester.tap(categoryItems.at(2));
      // Wait for the widget tree to rebuild.
      await tester.pumpAndSettle();

      // Assert
      // After tapping "Shoes", "All" should no longer be selected.
      allCategory = tester.widget<CategoryItem>(categoryItems.at(0));
      expect(allCategory.isSelected, isFalse);

      // "Shoes" should now be selected.
      final shoesCategory = tester.widget<CategoryItem>(categoryItems.at(2));
      expect(shoesCategory.isSelected, isTrue);
    });
  });
}