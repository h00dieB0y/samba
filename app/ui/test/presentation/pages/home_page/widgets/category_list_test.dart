import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ui/domain/enums/category.dart';
import 'package:ui/presentation/cubits/products/products_cubit.dart';
import 'package:ui/presentation/cubits/products/products_state.dart';
import 'package:ui/presentation/pages/home_page/widgets/category_item.dart';
import 'package:ui/presentation/pages/home_page/widgets/category_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Use @GenerateNiceMocks instead of @GenerateMocks
@GenerateNiceMocks([MockSpec<ProductsCubit>()])
import 'category_list_test.mocks.dart';

void main() {
  late MockProductsCubit mockProductsCubit;

  setUp(() {
    mockProductsCubit = MockProductsCubit();
  });

  // Helper function to create the widget under test
  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<ProductsCubit>.value(
          value: mockProductsCubit,
          child: const CategoryList(),
        ),
      ),
    );
  }

  group('CategoryList Widget Tests', () {
    testWidgets('displays all categories correctly', (WidgetTester tester) async {
      // Arrange: Stub the selectedCategory getter
      when(mockProductsCubit.selectedCategory).thenReturn(Category.all);

      // Stub the stream of states
      when(mockProductsCubit.stream).thenAnswer((_) => Stream<ProductsState>.fromIterable([
            ProductsLoaded([]),
          ]));

      // Stub the state getter
      when(mockProductsCubit.state).thenReturn(ProductsLoaded([]));

      // Act: Build the widget
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert: Verify that all categories are displayed
      for (var category in Category.values) {
        expect(find.text(category.name), findsOneWidget);
      }
    });

    testWidgets('highlights the selected category', (WidgetTester tester) async {
      // Arrange: Stub the selectedCategory getter
      when(mockProductsCubit.selectedCategory).thenReturn(Category.electronics);

      // Stub the stream of states
      when(mockProductsCubit.stream).thenAnswer((_) => Stream<ProductsState>.fromIterable([
            ProductsLoaded([]),
          ]));

      // Stub the state getter
      when(mockProductsCubit.state).thenReturn(ProductsLoaded([]));

      // Act: Build the widget
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert: Verify that the selected category is highlighted
      final selectedCategoryFinder = find.widgetWithText(CategoryItem, Category.electronics.name);
      expect(selectedCategoryFinder, findsOneWidget);

      // Retrieve the CategoryItem widget
      final CategoryItem categoryItemWidget = tester.widget(selectedCategoryFinder);
      expect(categoryItemWidget.isSelected, isTrue);
    });

    testWidgets('invokes selectCategory when a non-selected category is tapped', (WidgetTester tester) async {
      // Arrange: Stub the selectedCategory getter
      when(mockProductsCubit.selectedCategory).thenReturn(Category.all);

      // Stub the stream of states
      when(mockProductsCubit.stream).thenAnswer((_) => Stream<ProductsState>.fromIterable([
            ProductsLoaded([]),
          ]));

      // Stub the state getter
      when(mockProductsCubit.state).thenReturn(ProductsLoaded([]));

      // Act: Build the widget
      await tester.pumpWidget(createWidgetUnderTest());

      // Find a category that is not selected, e.g., Electronics
      final nonSelectedCategory = Category.electronics;
      final categoryFinder = find.widgetWithText(CategoryItem, nonSelectedCategory.name);

      // Tap the non-selected category
      await tester.tap(categoryFinder);
      await tester.pumpAndSettle();

      // Assert: Verify that selectCategory was called with the correct category
      verify(mockProductsCubit.selectCategory(nonSelectedCategory)).called(1);
    });

    testWidgets('does not invoke selectCategory when the selected category is tapped', (WidgetTester tester) async {
      // Arrange: Stub the selectedCategory getter
      when(mockProductsCubit.selectedCategory).thenReturn(Category.clothing);

      // Stub the stream of states
      when(mockProductsCubit.stream).thenAnswer((_) => Stream<ProductsState>.fromIterable([
            ProductsLoaded([]),
          ]));

      // Stub the state getter
      when(mockProductsCubit.state).thenReturn(ProductsLoaded([]));

      // Act: Build the widget
      await tester.pumpWidget(createWidgetUnderTest());

      // Find the selected category
      final selectedCategory = Category.clothing;
      final categoryFinder = find.widgetWithText(CategoryItem, selectedCategory.name);

      // Tap the selected category
      await tester.tap(categoryFinder);
      await tester.pumpAndSettle();

      // Assert: Verify that selectCategory was not called
      verifyNever(mockProductsCubit.selectCategory(selectedCategory));
    });

    testWidgets('rebuilds correctly on state changes', (WidgetTester tester) async {
      // Arrange: Initial state with selectedCategory = Category.all
      when(mockProductsCubit.selectedCategory).thenReturn(Category.all);

      // Stub the stream of states to emit ProductsLoaded initially
      when(mockProductsCubit.stream).thenAnswer((_) => Stream<ProductsState>.fromIterable([
            ProductsLoaded([]),
          ]));

      // Stub the state getter
      when(mockProductsCubit.state).thenReturn(ProductsLoaded([]));

      // Act: Build the widget
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert: Verify initial category selection
      final allCategoryFinder = find.widgetWithText(CategoryItem, Category.all.name);
      expect(allCategoryFinder, findsOneWidget);
      CategoryItem allCategoryItem = tester.widget(allCategoryFinder);
      expect(allCategoryItem.isSelected, isTrue);

      // Update the selected category to Electronics
      when(mockProductsCubit.selectedCategory).thenReturn(Category.electronics);

      // Emit a new state to simulate category change
      when(mockProductsCubit.stream).thenAnswer((_) => Stream<ProductsState>.fromIterable([
            ProductsLoaded([]),
            ProductsLoaded([]),
          ]));

      // Rebuild the widget with the updated state
      await tester.pump();

      // Assert: Verify that Electronics is now selected
      final electronicsCategoryFinder = find.widgetWithText(CategoryItem, Category.electronics.name);
      expect(electronicsCategoryFinder, findsOneWidget);
      CategoryItem electronicsCategoryItem = tester.widget(electronicsCategoryFinder);
      expect(electronicsCategoryItem.isSelected, isTrue);

      // Verify that the 'All' category is no longer selected
      CategoryItem updatedAllCategoryItem = tester.widget(allCategoryFinder);
      expect(updatedAllCategoryItem.isSelected, isFalse);
    });
  });
}
