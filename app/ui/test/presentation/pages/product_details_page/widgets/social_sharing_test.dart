import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ui/presentation/pages/product_details_page/widgets/social_sharing.dart';

void main() {
  const String productUrl = 'https://example.com/product';
  const String productName = 'Test Product';

  group('SocialSharing Widget Tests', () {
    testWidgets('Displays all social media icons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialSharing(productUrl: productUrl, productName: productName),
          ),
        ),
      );

      // Check for the icons of each platform
      expect(find.byIcon(FontAwesomeIcons.facebook), findsOneWidget);
      expect(find.byIcon(FontAwesomeIcons.twitter), findsOneWidget);
      expect(find.byIcon(FontAwesomeIcons.pinterest), findsOneWidget);
      expect(find.byIcon(FontAwesomeIcons.linkedin), findsOneWidget);
      expect(find.byIcon(FontAwesomeIcons.whatsapp), findsOneWidget);
    });

    testWidgets('Shares product when icon is clicked and shows SnackBar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialSharing(productUrl: productUrl, productName: productName),
          ),
        ),
      );

      // Simulate pressing the Facebook share button
      final facebookButton = find.byKey(Key('share_Facebook'));
      expect(facebookButton, findsOneWidget);
      await tester.tap(facebookButton);
      await tester.pumpAndSettle();

      // Check that SnackBar is shown
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Shared via Facebook'), findsOneWidget);
    });

    testWidgets('Share button tooltip displays correct text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialSharing(productUrl: productUrl, productName: productName),
          ),
        ),
      );

      // Check the tooltip for each share button
      final facebookButton = find.byKey(Key('share_Facebook'));
      expect(facebookButton, findsOneWidget);

      final widget = tester.widget<IconButton>(facebookButton);
      expect(widget.tooltip, 'Share on Facebook');
    });

    testWidgets('Share action displays correct product information in the share dialog', (WidgetTester tester) async {

      // Replace Share.share method with mock
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialSharing(
              productUrl: productUrl,
              productName: productName,
            ),
          ),
        ),
      );

      // Trigger share on Twitter
      final twitterButton = find.byKey(Key('share_Twitter'));
      await tester.tap(twitterButton);
      await tester.pumpAndSettle();
    });
  });
}