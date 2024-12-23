import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/presentation/widgets/search_bar_input.dart';

void main() {
  group('HomeSearchBar Widget Tests', () {
    testWidgets('renders the HomeSearchBar without errors', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SearchBar(),
          ),
        ),
      );

      // Act
      // (In this case, there's no specific action to perform)

      // Assert
      // Check if HomeSearchBar builds by finding a TextField
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('contains a TextField with the correct hint and prefix icon',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SearchBar(),
          ),
        ),
      );

      // Act
      final textFieldFinder = find.byType(TextField);
      final textField = tester.widget<TextField>(textFieldFinder);

      // Assert
      // Check hint text
      expect(textField.decoration?.hintText, 'Search on Somba.com');
      // Check prefix icon
      expect(textField.decoration?.prefixIcon, isA<Icon>());
      final prefixIcon = textField.decoration?.prefixIcon as Icon;
      expect(prefixIcon.icon, Icons.search);
    });
  });
}