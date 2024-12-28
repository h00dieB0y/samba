import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/presentation/pages/search_page/widgets/tag.dart';

void main() {
  group('Tag Widget Tests', () {
    testWidgets('Tag displays correct text and color', (WidgetTester tester) async {
      const String tagText = 'Best Seller';
      const Color tagColor = Colors.green;

      // Build the Tag widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Tag(text: tagText, color: tagColor),
          ),
        ),
      );

      // Verify that the text is displayed
      expect(find.text(tagText), findsOneWidget);

      // Verify that the container has the correct background color
      final Container container = tester.widget(find.byType(Container));
      final BoxDecoration? decoration = container.decoration as BoxDecoration?;
      expect(decoration?.color, tagColor);
    });

    testWidgets('Tag applies left margin correctly', (WidgetTester tester) async {
      const String tagText = 'Sponsored';
      const Color tagColor = Colors.orangeAccent;
      const double marginLeft = 4.0;

      // Build the Tag widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Tag(text: tagText, color: tagColor, marginLeft: marginLeft),
          ),
        ),
      );

      // Verify that the Container has the correct margin
      final Container container = tester.widget(find.byType(Container));
      final EdgeInsets margin = container.margin as EdgeInsets;
      expect(margin.left, marginLeft);
    });
  });
}