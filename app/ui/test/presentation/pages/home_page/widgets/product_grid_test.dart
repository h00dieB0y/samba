import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ui/domain/entities/product_item_entity.dart';
import 'package:ui/presentation/cubits/products/products_cubit.dart';
import 'package:ui/presentation/cubits/products/products_state.dart';
import 'package:ui/presentation/pages/home_page/widgets/product_grid.dart';
import 'package:ui/presentation/pages/home_page/widgets/product_card.dart';

/// Mock implementation of ProductsCubit
class MockProductsCubit extends MockCubit<ProductsState> implements ProductsCubit {}

/// Fake implementation of ProductsState
class FakeProductsState extends Fake implements ProductsState {}

void main() {
  // 3. Register fallback values (if using mocktail)
  setUpAll(() {
    registerFallbackValue(FakeProductsState());
  });

  late MockProductsCubit mockProductsCubit;

  setUp(() {
    // 4. Instantiate the mock cubit before each test
    mockProductsCubit = MockProductsCubit();
  });

  Widget makeTestableWidget(Widget body) {
    // Helper method to wrap the widget with BlocProvider and MaterialApp
    return BlocProvider<ProductsCubit>(
      create: (context) => mockProductsCubit,
      child: MaterialApp(
        home: Scaffold(body: body),
      ),
    );
  }

  group('ProductGrid tests', () {
    testWidgets('shows CircularProgressIndicator when state is ProductsLoading',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockProductsCubit.state).thenReturn(ProductsLoading());

      // Act
      await tester.pumpWidget(makeTestableWidget(const ProductGrid()));

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows GridView with ProductCards when state is ProductsLoaded',
        (WidgetTester tester) async {
      // Arrange: create some sample product data
      final productList = [
        ProductItemEntity(id: '1', name: 'Item 1', brand: 'Brand A', price: '10.0'),
        ProductItemEntity(id: '2', name: 'Item 2', brand: 'Brand B', price: '20.0'),
        ProductItemEntity(id: '3', name: 'Item 3', brand: 'Brand C', price: '30.0'),
      ];
      when(() => mockProductsCubit.state).thenReturn(ProductsLoaded(productList));

      // Act
      await tester.pumpWidget(makeTestableWidget(const ProductGrid()));

      // Assert
      // 1. We expect to find one GridView
      expect(find.byType(GridView), findsOneWidget);
      // 2. We expect as many ProductCards as items in productList
      expect(find.byType(ProductCard), findsNWidgets(productList.length));
    });

    testWidgets('shows error message when state is ProductsError',
        (WidgetTester tester) async {
      // Arrange
      const errorMessage = 'Unable to load products';
      when(() => mockProductsCubit.state).thenReturn(ProductsError(errorMessage));

      // Act
      await tester.pumpWidget(makeTestableWidget(const ProductGrid()));

      // Assert
      // Check for the error text
      expect(find.text(errorMessage), findsOneWidget);
      // Make sure no GridView or CircularProgressIndicator is found
      expect(find.byType(GridView), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('renders empty SizedBox for any other state',
        (WidgetTester tester) async {
      // Arrange: Some unknown state
      when(() => mockProductsCubit.state).thenReturn(ProductsInitial());

      // Act
      await tester.pumpWidget(makeTestableWidget(const ProductGrid()));

      // Assert
      // We expect an empty SizedBox
      expect(find.byType(SizedBox), findsOneWidget);
      // No GridView, no error text, no spinner
      expect(find.byType(GridView), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}