import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/presentation/widgets/app_bottom_navigation_bar.dart';

void main() {
  group('AppBottomNavigationBar', () {
    testWidgets('should render correctly', (WidgetTester tester) async {
      // Arrange
      onTap(int index) {}
      const currentIndex = 0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: AppBottomNavigationBar(
              onTap: onTap,
              currentIndex: currentIndex,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.category), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('should call onTap with correct index', (WidgetTester tester) async {
      // Arrange
      int tappedIndex = -1;
      onTap(int index) {
        tappedIndex = index;
      }
      const currentIndex = 0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: AppBottomNavigationBar(
              onTap: onTap,
              currentIndex: currentIndex,
            ),
          ),
        ),
      );

      // Tap on the Categories icon
      await tester.tap(find.byIcon(Icons.category));
      await tester.pumpAndSettle();

      // Assert
      expect(tappedIndex, 1);
    });

    testWidgets('should set currentIndex correctly', (WidgetTester tester) async {
      // Arrange
      onTap(int index) {}
      const currentIndex = 2;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: AppBottomNavigationBar(
              onTap: onTap,
              currentIndex: currentIndex,
            ),
          ),
        ),
      );

      // Assert
      final bottomNavigationBar = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNavigationBar.currentIndex, currentIndex);
    });
  });
}