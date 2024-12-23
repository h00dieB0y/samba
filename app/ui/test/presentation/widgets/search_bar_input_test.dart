import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/presentation/widgets/search_bar_input.dart';

class SearchCallbackTracker {
  final List<String> queries = [];

  void call(String query) {
    queries.add(query);
  }
}

void main() {
  group('SearchBarInput Widget Tests', () {
    // A helper class to track the onSearch callback calls

    late SearchCallbackTracker callbackTracker;

    setUp(() {
      // Initialize the callback tracker before each test
      callbackTracker = SearchCallbackTracker();
    });

    testWidgets('renders SearchBarInput without errors',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarInput(
              hintText: 'Search on Somba.com',
              onSearch: callbackTracker.call,
            ),
          ),
        ),
      );

      // Act
      // No action needed for rendering test

      // Assert
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('contains a TextField with the correct hint and prefix icon',
        (WidgetTester tester) async {
      // Arrange
      const hintText = 'Search on Somba.com';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarInput(
              hintText: hintText,
              onSearch: callbackTracker.call,
            ),
          ),
        ),
      );

      // Act
      final textFieldFinder = find.byType(TextField);
      final textField = tester.widget<TextField>(textFieldFinder);

      // Assert
      expect(textField.decoration?.hintText, hintText);
      expect(textField.decoration?.prefixIcon, isA<Icon>());
      final prefixIcon = textField.decoration?.prefixIcon as Icon;
      expect(prefixIcon.icon, Icons.search);
    });

    testWidgets('clear icon is not visible initially',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarInput(
              hintText: 'Search',
              onSearch: callbackTracker.call,
            ),
          ),
        ),
      );

      // Act
      // No action needed

      // Assert
      expect(find.byIcon(Icons.clear), findsNothing);
    });

    testWidgets('clear icon appears when text is entered',
        (WidgetTester tester) async {
      // Arrange
      const initialText = 'Flutter';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarInput(
              hintText: 'Search',
              onSearch: callbackTracker.call,
            ),
          ),
        ),
      );

      // Act
      final textFieldFinder = find.byType(TextField);
      await tester.enterText(textFieldFinder, initialText);
      await tester.pump(); // Rebuild after text input

      // Assert
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets(
        'pressing clear icon clears the text and calls onSearch with empty string',
        (WidgetTester tester) async {
      // Arrange
      const initialText = 'Flutter';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarInput(
              hintText: 'Search',
              onSearch: callbackTracker.call,
            ),
          ),
        ),
      );

      // Act
      final textFieldFinder = find.byType(TextField);
      await tester.enterText(textFieldFinder, initialText);
      await tester.pump(); // Rebuild after text input

      // Verify clear icon is present
      final clearIconFinder = find.byIcon(Icons.clear);
      expect(clearIconFinder, findsOneWidget);

      // Tap the clear icon
      await tester.tap(clearIconFinder);
      await tester.pump(); // Rebuild after tapping

      // Assert
      expect(find.byIcon(Icons.clear),
          findsNothing); // Clear icon should disappear
      final textField = tester.widget<TextField>(textFieldFinder);
      expect(textField.controller?.text, '');

      // Verify onSearch was called with empty string
      expect(callbackTracker.queries, ['']);
    });

    testWidgets('typing into TextField calls onSearch after debounce duration',
        (WidgetTester tester) async {
      // Arrange
      const debounceDuration = Duration(milliseconds: 300);
      const searchQuery = 'Flutter';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarInput(
              hintText: 'Search',
              onSearch: callbackTracker.call,
              debounceDuration: debounceDuration,
            ),
          ),
        ),
      );

      // Act
      final textFieldFinder = find.byType(TextField);
      await tester.enterText(textFieldFinder, searchQuery);
      await tester.pump(); // Trigger the listener

      // At this point, debounce timer is active but hasn't fired yet
      expect(callbackTracker.queries, isEmpty);

      // Advance time by debounceDuration
      await tester.pump(debounceDuration);

      // Now, the debounce timer should have fired
      expect(callbackTracker.queries, [searchQuery]);
    });

    testWidgets('pressing enter submits the search immediately',
        (WidgetTester tester) async {
      // Arrange
      const searchQuery = 'Flutter';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarInput(
              hintText: 'Search',
              onSearch: callbackTracker.call,
              debounceDuration: Duration(milliseconds: 300),
            ),
          ),
        ),
      );

      // Act
      final textFieldFinder = find.byType(TextField);
      await tester.enterText(textFieldFinder, searchQuery);
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump(); // Process the action

      // Assert
      expect(callbackTracker.queries, [searchQuery]);

      // Additionally, ensure debounce doesn't call onSearch again
      await tester.pump(const Duration(milliseconds: 300));
      expect(callbackTracker.queries.length, 1); // Should still be 1
    });

    testWidgets('multiple rapid text changes debounce correctly',
        (WidgetTester tester) async {
      // Arrange
      const debounceDuration = Duration(milliseconds: 300);
      const searchQueries = ['F', 'Fl', 'Flu', 'Flut', 'Flutt', 'Flutter'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarInput(
              hintText: 'Search',
              onSearch: callbackTracker.call,
              debounceDuration: debounceDuration,
            ),
          ),
        ),
      );

      // Act
      final textFieldFinder = find.byType(TextField);
      for (final query in searchQueries) {
        await tester.enterText(textFieldFinder, query);
        await tester
            .pump(const Duration(milliseconds: 100)); // Less than debounce
      }

      // At this point, debounce timer should still be active
      expect(callbackTracker.queries, isEmpty);

      // Advance time to exceed debounce duration
      await tester.pump(debounceDuration);

      // Assert
      expect(callbackTracker.queries, [searchQueries.last]);
    });

    testWidgets(
        'clear button does not appear when text is empty after clearing',
        (WidgetTester tester) async {
      // Arrange
      const initialText = 'Flutter';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarInput(
              hintText: 'Search',
              onSearch: callbackTracker.call,
            ),
          ),
        ),
      );

      // Act
      final textFieldFinder = find.byType(TextField);
      await tester.enterText(textFieldFinder, initialText);
      await tester.pump(); // Rebuild after text input

      // Verify clear icon is present
      final clearIconFinder = find.byIcon(Icons.clear);
      expect(clearIconFinder, findsOneWidget);

      // Tap the clear icon
      await tester.tap(clearIconFinder);
      await tester.pump(); // Rebuild after tapping

      // Assert
      expect(find.byIcon(Icons.clear),
          findsNothing); // Clear icon should disappear
      expect(
          callbackTracker.queries, ['']); // onSearch called with empty string
    });
  });
}
