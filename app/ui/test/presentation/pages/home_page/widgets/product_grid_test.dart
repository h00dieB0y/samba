import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:ui/domain/entities/product_item_entity.dart';
import 'package:ui/presentation/cubits/products/products_cubit.dart';
import 'package:ui/presentation/cubits/products/products_state.dart';
import 'package:ui/presentation/pages/home_page/widgets/product_grid.dart';
import 'package:ui/presentation/pages/home_page/widgets/product_card.dart';

@GenerateMocks([ProductsCubit])
import 'product_grid_test.mocks.dart'; // The generated mocks file

void main() {
  // Here is where our generated class (MockProductsCubit) will come from
  late MockProductsCubit mockProductsCubit;

  // A helper widget to inject our mock cubit into the widget tree
  Widget makeTestableWidget(Widget body) {
    return BlocProvider<ProductsCubit>(
      create: (context) => mockProductsCubit,
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  setUp(() {
    mockProductsCubit = MockProductsCubit();
    when(mockProductsCubit.stream).thenAnswer((_) => Stream.fromIterable([]));
  });

  group('ProductGrid tests', () {
    testWidgets('shows CircularProgressIndicator when state is ProductsLoading',
        (WidgetTester tester) async {
      // Arrange
      when(mockProductsCubit.state).thenReturn(ProductsLoading());

      // Act
      await tester.pumpWidget(makeTestableWidget(const ProductGrid()));

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows GridView with ProductCards when state is ProductsLoaded',
        (WidgetTester tester) async {
      // Arrange
      final productList = [
        ProductItemEntity(id: '1', name: 'Item 1', brand: 'Brand A', price: '10.0'),
        ProductItemEntity(id: '2', name: 'Item 2', brand: 'Brand B', price: '20.0'),
        ProductItemEntity(id: '3', name: 'Item 3', brand: 'Brand C', price: '30.0'),
      ];
      when(mockProductsCubit.state).thenReturn(ProductsLoaded(productList));

      // Act
      await tester.pumpWidget(makeTestableWidget(const ProductGrid()));

      // Assert
      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(ProductCard), findsNWidgets(productList.length));
    });

    testWidgets('shows error message when state is ProductsError',
        (WidgetTester tester) async {
      // Arrange
      const errorMsg = 'Unable to load products';
      when(mockProductsCubit.state).thenReturn(ProductsError(errorMsg));

      // Act
      await tester.pumpWidget(makeTestableWidget(const ProductGrid()));

      // Assert
      expect(find.text(errorMsg), findsOneWidget);
      expect(find.byType(GridView), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('renders empty SizedBox for any other (e.g. initial) state',
        (WidgetTester tester) async {
      // Arrange
      when(mockProductsCubit.state).thenReturn(ProductsInitial());

      // Act
      await tester.pumpWidget(makeTestableWidget(const ProductGrid()));

      // Assert
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(GridView), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}