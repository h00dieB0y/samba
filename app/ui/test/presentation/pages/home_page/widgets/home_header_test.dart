// Enhanced test/presentation/pages/home_page/widgets/home_header_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ui/domain/enums/category.dart';
import 'package:ui/presentation/cubits/products/products_cubit.dart';
import 'package:ui/presentation/cubits/products/products_state.dart';
import 'package:ui/presentation/pages/home_page/widgets/category_item.dart';
import 'package:ui/presentation/pages/home_page/widgets/home_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/presentation/widgets/search_bar_input.dart';

// Generate a MockProductsCubit using the Mockito package.
@GenerateNiceMocks([MockSpec<ProductsCubit>()])
import 'home_header_test.mocks.dart';

void main() {
  late MockProductsCubit mockProductsCubit;

  setUp(() {
    mockProductsCubit = MockProductsCubit();
    when(mockProductsCubit.stream).thenAnswer((_) => Stream<ProductsState>.empty());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Scaffold(
              body: BlocProvider<ProductsCubit>.value(
                value: mockProductsCubit,
                child: const HomeHeader(),
              ),
            ),
        '/search': (context) => Scaffold(
          body: const Text('Search Page'),
        )
        
      },
    );
  }

  group('HomeHeader Widget Tests', () {
    testWidgets('renders HomeHeader without errors', (WidgetTester tester) async {
      // Arrange
      when(mockProductsCubit.selectedCategory).thenReturn(Category.all);
      when(mockProductsCubit.state).thenReturn(ProductsLoaded([]));
      when(mockProductsCubit.stream).thenAnswer((_) => Stream.value(ProductsLoaded([])));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(SearchBarInput), findsOneWidget);
      expect(find.byType(CategoryItem), findsNWidgets(Category.values.length));
    });

    testWidgets('tapping on a category changes the selected category',
        (WidgetTester tester) async {
      // Arrange
      when(mockProductsCubit.selectedCategory).thenReturn(Category.all);
      when(mockProductsCubit.state).thenReturn(ProductsLoaded([]));
      when(mockProductsCubit.stream).thenAnswer(
        (_) => Stream.fromIterable([
          ProductsLoaded([]),
          ProductsLoaded([]),
        ]),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert initial state
      final allCategoryFinder = find.widgetWithText(CategoryItem, 'All');
      expect(allCategoryFinder, findsOneWidget);
      var allCategoryItem = tester.widget<CategoryItem>(allCategoryFinder);
      expect(allCategoryItem.isSelected, isTrue);

      // Update selected category
      when(mockProductsCubit.selectedCategory).thenReturn(Category.shoes);

      // Tap on "Shoes"
      final shoesCategoryFinder = find.widgetWithText(CategoryItem, 'Shoes');
      expect(shoesCategoryFinder, findsOneWidget);
      await tester.tap(shoesCategoryFinder);
      await tester.pumpAndSettle();

      verify(mockProductsCubit.selectCategory(Category.shoes)).called(1);

      // Rebuild with updated state
      when(mockProductsCubit.state).thenReturn(ProductsLoaded([]));
      await tester.pump();

      // Verify selection
      final updatedShoesCategoryItem = tester.widget<CategoryItem>(shoesCategoryFinder);
      expect(updatedShoesCategoryItem.isSelected, isTrue);

      allCategoryItem = tester.widget<CategoryItem>(allCategoryFinder);
      expect(allCategoryItem.isSelected, isFalse);
    });

    testWidgets('does not invoke selectCategory when the selected category is tapped',
        (WidgetTester tester) async {
      // Arrange
      when(mockProductsCubit.selectedCategory).thenReturn(Category.clothing);
      when(mockProductsCubit.state).thenReturn(ProductsLoaded([]));
      when(mockProductsCubit.stream).thenAnswer((_) => Stream.value(ProductsLoaded([])));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert initial state
      final clothingCategoryFinder = find.widgetWithText(CategoryItem, 'Clothes');
      expect(clothingCategoryFinder, findsOneWidget);
      final clothingCategoryItem = tester.widget<CategoryItem>(clothingCategoryFinder);
      expect(clothingCategoryItem.isSelected, isTrue);

      // Tap on "Clothing"
      await tester.tap(clothingCategoryFinder);
      await tester.pumpAndSettle();

      verifyNever(mockProductsCubit.selectCategory(Category.clothing));
    });

    testWidgets('rebuilds correctly on state changes', (WidgetTester tester) async {
      // Arrange
      when(mockProductsCubit.selectedCategory).thenReturn(Category.all);
      when(mockProductsCubit.state).thenReturn(ProductsLoaded([]));
      when(mockProductsCubit.stream).thenAnswer(
        (_) => Stream.fromIterable([
          ProductsLoaded([]),
          ProductsLoaded([]),
        ]),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert initial selection
      final allCategoryFinder = find.widgetWithText(CategoryItem, 'All');
      expect(allCategoryFinder, findsOneWidget);
      var allCategoryItem = tester.widget<CategoryItem>(allCategoryFinder);
      expect(allCategoryItem.isSelected, isTrue);

      // Change selected category
      when(mockProductsCubit.selectedCategory).thenReturn(Category.electronics);

      await tester.pump();

      // Verify new selection
      final electronicsCategoryFinder = find.widgetWithText(CategoryItem, 'Electronics');
      expect(electronicsCategoryFinder, findsOneWidget);
      final electronicsCategoryItem = tester.widget<CategoryItem>(electronicsCategoryFinder);
      expect(electronicsCategoryItem.isSelected, isTrue);

      allCategoryItem = tester.widget<CategoryItem>(allCategoryFinder);
      expect(allCategoryItem.isSelected, isFalse);
    });
  });

  // Submit search query with empty string should not redirect to search page
  testWidgets('does not navigate to search page when search query is empty',
      (WidgetTester tester) async {
    // Arrange
    when(mockProductsCubit.selectedCategory).thenReturn(Category.all);
    when(mockProductsCubit.state).thenReturn(ProductsLoaded([]));
    when(mockProductsCubit.stream).thenAnswer((_) => Stream.value(ProductsLoaded([])));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Tap on search button
    final searchButtonFinder = find.byIcon(Icons.search);
    await tester.tap(searchButtonFinder);
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Search Page'), findsNothing);
   
  });

  testWidgets('navigates to search page when search query is not empty',
      (WidgetTester tester) async {
    // Arrange
    when(mockProductsCubit.selectedCategory).thenReturn(Category.all);
    when(mockProductsCubit.state).thenReturn(ProductsLoaded([]));
    when(mockProductsCubit.stream).thenAnswer((_) => Stream.value(ProductsLoaded([])));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Enter search query
    final searchQuery = 'search query';
    final searchBarFinder = find.byType(SearchBarInput);
    await tester.enterText(searchBarFinder, searchQuery);
    await tester.pump();

    // Submit search query by tapping "Enter" key
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Search Page'), findsOneWidget);
  });
}
