import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/presentation/pages/home_page/widgets/category_item.dart';

void main() {
  group('CategoryItem', () {
    testWidgets('should render correctly', (WidgetTester tester) async {
      // Arrange
      const title = 'Category';
      const isSelected = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryItem(
              title: title,
              isSelected: isSelected,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(title), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (WidgetTester tester) async {
      // Arrange
      bool tapped = false;
      onTap() {
        tapped = true;
      }
      const title = 'Category';
      const isSelected = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryItem(
              title: title,
              isSelected: isSelected,
              onTap: onTap,
            ),
          ),
        ),
      );

      // Tap on the widget
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      // Assert
      expect(tapped, true);
    });

    testWidgets('should change appearance when isSelected is true', (WidgetTester tester) async {
      // Arrange
      const title = 'Category';
      const isSelected = true;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryItem(
              title: title,
              isSelected: isSelected,
            ),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.blue.shade50);
      expect(decoration.border, isNotNull);
      expect(decoration.border!.top.color, Colors.blue.shade300);
    });
  });
}