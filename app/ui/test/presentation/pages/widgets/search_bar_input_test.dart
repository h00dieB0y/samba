import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/presentation/pages/widgets/search_bar_input.dart';

class SearchCallbackTracker {
  final List<String> queries = [];

  void call(String query) {
    queries.add(query);
  }
}

void main() {
  group('SearchBarInput Widget Tests', () {
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
      expect(find.byKey(const Key('search_bar_input_text_field')), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets(
        'contains a TextField with the correct hint and prefix icon',
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
      final textFieldFinder = find.byKey(const Key('search_bar_input_text_field'));
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
      expect(find.byKey(const Key('search_bar_input_clear_button')), findsNothing);
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
      final textFieldFinder = find.byKey(const Key('search_bar_input_text_field'));
      await tester.enterText(textFieldFinder, initialText);
      await tester.pump(); // Rebuild after text input

      // Assert
      expect(find.byKey(const Key('search_bar_input_clear_button')), findsOneWidget);
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
      final textFieldFinder = find.byKey(const Key('search_bar_input_text_field'));
      await tester.enterText(textFieldFinder, initialText);
      await tester.pump(); // Rebuild after text input

      // Verify clear icon is present
      final clearIconFinder = find.byKey(const Key('search_bar_input_clear_button'));
      expect(clearIconFinder, findsOneWidget);

      // Tap the clear icon
      await tester.tap(clearIconFinder);
      await tester.pump(); // Rebuild after tapping

      // Assert
      expect(find.byKey(const Key('search_bar_input_clear_button')), findsNothing);
      final textField = tester.widget<TextField>(textFieldFinder);
      expect(textField.controller?.text, '');

      // Verify onSearch was called with empty string
      expect(callbackTracker.queries, ['']);
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
            ),
          ),
        ),
      );

      // Act
      final textFieldFinder = find.byKey(const Key('search_bar_input_text_field'));
      await tester.enterText(textFieldFinder, searchQuery);
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump(); // Process the action

      // Assert
      expect(callbackTracker.queries, [searchQuery]);
    });

    testWidgets('onSearch is not called on text change without submission',
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
      final textFieldFinder = find.byKey(const Key('search_bar_input_text_field'));
      await tester.enterText(textFieldFinder, 'F');
      await tester.pump(); // Rebuild after text input

      await tester.enterText(textFieldFinder, 'Fl');
      await tester.pump(); // Rebuild after text input

      await tester.enterText(textFieldFinder, 'Flu');
      await tester.pump(); // Rebuild after text input

      // Assert
      expect(callbackTracker.queries, isEmpty); // onSearch should not be called
    });

    testWidgets(
        'multiple rapid text changes do not trigger onSearch, only submission does',
        (WidgetTester tester) async {
      // Arrange
      const searchQueries = ['F', 'Fl', 'Flu', 'Flut', 'Flutt', 'Flutter'];

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
      final textFieldFinder = find.byKey(const Key('search_bar_input_text_field'));
      for (final query in searchQueries) {
        await tester.enterText(textFieldFinder, query);
        await tester.pump(const Duration(milliseconds: 100)); // Rapid changes
      }

      // Assert
      expect(callbackTracker.queries, isEmpty); // onSearch should not be called

      // Now submit the search
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump(); // Process the action

      expect(callbackTracker.queries, ['Flutter']); // onSearch called once
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
      final textFieldFinder = find.byKey(const Key('search_bar_input_text_field'));
      await tester.enterText(textFieldFinder, initialText);
      await tester.pump(); // Rebuild after text input

      // Verify clear icon is present
      final clearIconFinder = find.byKey(const Key('search_bar_input_clear_button'));
      expect(clearIconFinder, findsOneWidget);

      // Tap the clear icon
      await tester.tap(clearIconFinder);
      await tester.pump(); // Rebuild after tapping

      // Assert
      expect(find.byKey(const Key('search_bar_input_clear_button')), findsNothing);
      expect(
          callbackTracker.queries, ['']); // onSearch called with empty string
    });

    // Additional Tests for Enhanced Coverage

    testWidgets('uses external TextEditingController if provided',
        (WidgetTester tester) async {
      // Arrange
      final externalController = TextEditingController();
      const externalText = 'External Text';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarInput(
              hintText: 'Search',
              onSearch: callbackTracker.call,
              controller: externalController,
            ),
          ),
        ),
      );

      // Act
      externalController.text = externalText;
      await tester.pump(); // Rebuild after external text change

      // Assert
      final textFieldFinder = find.byKey(const Key('search_bar_input_text_field'));
      final textField = tester.widget<TextField>(textFieldFinder);
      expect(textField.controller?.text, externalText);
      expect(find.byKey(const Key('search_bar_input_clear_button')), findsOneWidget);
    });

    testWidgets('uses external FocusNode if provided and manages focus accordingly',
        (WidgetTester tester) async {
      // Arrange
      final externalFocusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarInput(
              hintText: 'Search',
              onSearch: callbackTracker.call,
              focusNode: externalFocusNode,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byKey(const Key('search_bar_input_text_field')));
      await tester.pump(); // Rebuild after tapping

      // Assert
      expect(externalFocusNode.hasFocus, isTrue);

      // Now, simulate clearing the search which should not unfocus since focus node is externally managed
      final clearIconFinder = find.byKey(const Key('search_bar_input_clear_button'));
      await tester.enterText(find.byKey(const Key('search_bar_input_text_field')), 'Flutter');
      await tester.pump();
      await tester.tap(clearIconFinder);
      await tester.pump();

      expect(externalFocusNode.hasFocus, isTrue); // Focus should remain
    });

    testWidgets('handles whitespace-only search submission by trimming input',
        (WidgetTester tester) async {
      // Arrange
      const searchQuery = '   Flutter   ';

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
      final textFieldFinder = find.byKey(const Key('search_bar_input_text_field'));
      await tester.enterText(textFieldFinder, searchQuery);
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump(); // Process the action

      // Assert
      expect(callbackTracker.queries, ['Flutter']); // Should be trimmed
    });

    testWidgets('accessibility: TextField has appropriate semantics',
        (WidgetTester tester) async {
      // Arrange
      const hintText = 'Search Products';
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
      final semantics = tester.getSemantics(find.byKey(const Key('search_bar_input_text_field')));

      // Assert
      expect(semantics.hasFlag(SemanticsFlag.isTextField), isTrue);
      expect(
          semantics.label, contains(hintText)); // Hint text is part of semantics
    });
  });
}
