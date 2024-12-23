// test/presentation/cubits/products/products_cubit_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ui/domain/entities/product_item_entity.dart';
import 'package:ui/domain/enums/category.dart';
import 'package:ui/domain/usecases/get_products_use_case.dart';
import 'package:ui/domain/usecases/get_products_by_category_use_case.dart';
import 'package:ui/presentation/cubits/products/products_cubit.dart';
import 'package:ui/presentation/cubits/products/products_state.dart';
import 'package:bloc_test/bloc_test.dart';

@GenerateNiceMocks([
  MockSpec<GetProductsUseCase>(),
  MockSpec<GetProductsByCategoryUseCase>(),
])
import 'products_cubit_test.mocks.dart';

void main() {
  late MockGetProductsUseCase mockGetProductsUseCase;
  late MockGetProductsByCategoryUseCase mockGetProductsByCategoryUseCase;
  late ProductsCubit productsCubit;

  setUp(() {
    // Initialize the mocks before each test
    mockGetProductsUseCase = MockGetProductsUseCase();
    mockGetProductsByCategoryUseCase = MockGetProductsByCategoryUseCase();

    // Instantiate the ProductsCubit with mocked use cases
    productsCubit = ProductsCubit(
      mockGetProductsUseCase,
      mockGetProductsByCategoryUseCase,
    );
  });

  tearDown(() {
    // Close the cubit after each test
    productsCubit.close();
  });

  group('ProductsCubit', () {
    test('initial state is ProductsInitial', () {
      expect(productsCubit.state, equals(ProductsInitial()));
    });

    blocTest<ProductsCubit, ProductsState>(
      'emits [ProductsLoading, ProductsLoaded] when fetchProducts is called with isInitialLoad: true and category: all',
      build: () {
        // Stub the GetProductsUseCase to return a list of products
        when(mockGetProductsUseCase.execute(page: anyNamed('page'), perPage: anyNamed('perPage')))
            .thenAnswer((_) async => [
                  const ProductItemEntity(id: '1', name: 'Product 1', brand: 'Brand A', price: '10.0'),
                  const ProductItemEntity(id: '2', name: 'Product 2', brand: 'Brand B', price: '20.0'),
                ]);
        return productsCubit;
      },
      act: (cubit) => cubit.fetchProducts(isInitialLoad: true),
      expect: () => [
        ProductsLoading(),
        ProductsLoaded([
          const ProductItemEntity(id: '1', name: 'Product 1', brand: 'Brand A', price: '10.0'),
          const ProductItemEntity(id: '2', name: 'Product 2', brand: 'Brand B', price: '20.0'),
        ]),
      ],
      verify: (_) {
        // Verify that fetchProducts was called with correct parameters
        verify(mockGetProductsUseCase.execute(page: 0, perPage: 10)).called(1);
      },
    );

    blocTest<ProductsCubit, ProductsState>(
      'emits [ProductsLoadingMore, ProductsLoaded] when fetchProducts is called without isInitialLoad and has more data',
      build: () {
        // Initial fetch
        when(mockGetProductsUseCase.execute(page: anyNamed('page'), perPage: anyNamed('perPage')))
            .thenAnswer((_) async => [
                  const ProductItemEntity(id: '1', name: 'Product 1', brand: 'Brand A', price: '10.0'),
                  const ProductItemEntity(id: '2', name: 'Product 2', brand: 'Brand B', price: '20.0'),
                ]);
        return productsCubit;
      },
      act: (cubit) async {
        // Initial fetch
        await cubit.fetchProducts(isInitialLoad: true);
        // Fetch more
        when(mockGetProductsUseCase.execute(page: 1, perPage: 10)).thenAnswer((_) async => [
              const ProductItemEntity(id: '3', name: 'Product 3', brand: 'Brand C', price: '30.0'),
              const ProductItemEntity(id: '4', name: 'Product 4', brand: 'Brand D', price: '40.0'),
            ]);
        await cubit.fetchProducts();
      },
      expect: () => [
        ProductsLoading(),
        ProductsLoaded([
          const ProductItemEntity(id: '1', name: 'Product 1', brand: 'Brand A', price: '10.0'),
          const ProductItemEntity(id: '2', name: 'Product 2', brand: 'Brand B', price: '20.0'),
        ]),
        ProductsLoadingMore([
          const ProductItemEntity(id: '1', name: 'Product 1', brand: 'Brand A', price: '10.0'),
          const ProductItemEntity(id: '2', name: 'Product 2', brand: 'Brand B', price: '20.0'),
        ]),
        ProductsLoaded([
          const ProductItemEntity(id: '1', name: 'Product 1', brand: 'Brand A', price: '10.0'),
          const ProductItemEntity(id: '2', name: 'Product 2', brand: 'Brand B', price: '20.0'),
          const ProductItemEntity(id: '3', name: 'Product 3', brand: 'Brand C', price: '30.0'),
          const ProductItemEntity(id: '4', name: 'Product 4', brand: 'Brand D', price: '40.0'),
        ]),
      ],
      verify: (_) {
        // Verify initial and subsequent fetches
        verify(mockGetProductsUseCase.execute(page: 0, perPage: 10)).called(1);
        verify(mockGetProductsUseCase.execute(page: 1, perPage: 10)).called(1);
      },
    );

    blocTest<ProductsCubit, ProductsState>(
      'emits [ProductsLoading, ProductsLoaded] with empty list and sets hasMoreData to false when no more products are fetched',
      build: () {
        // Stub the GetProductsUseCase to return empty list on initial load
        when(mockGetProductsUseCase.execute(page: anyNamed('page'), perPage: anyNamed('perPage')))
            .thenAnswer((_) async => []);
        return productsCubit;
      },
      act: (cubit) => cubit.fetchProducts(isInitialLoad: true),
      expect: () => [
        ProductsLoading(),
        ProductsLoaded([]),
      ],
      verify: (_) {
        // Verify that fetchProducts was called with correct parameters
        verify(mockGetProductsUseCase.execute(page: 0, perPage: 10)).called(1);
      },
    );

    blocTest<ProductsCubit, ProductsState>(
      'emits [ProductsError] when fetchProducts throws an exception',
      build: () {
        // Stub the GetProductsUseCase to throw an exception
        when(mockGetProductsUseCase.execute(page: anyNamed('page'), perPage: anyNamed('perPage')))
            .thenThrow(Exception('Failed to fetch products'));
        return productsCubit;
      },
      act: (cubit) => cubit.fetchProducts(isInitialLoad: true),
      expect: () => [
        ProductsLoading(),
        ProductsError('Exception: Failed to fetch products'),
      ],
      verify: (_) {
        // Verify that fetchProducts was called with correct parameters
        verify(mockGetProductsUseCase.execute(page: 0, perPage: 10)).called(1);
      },
    );

    blocTest<ProductsCubit, ProductsState>(
      'emits [ProductsLoading, ProductsLoaded] when selectCategory is called and fetchProducts is successful',
      build: () {
        // Stub the GetProductsByCategoryUseCase to return a list of products for the selected category
        when(mockGetProductsByCategoryUseCase.execute(
          category: anyNamed('category'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        )).thenAnswer((_) async => [
              const ProductItemEntity(id: '5', name: 'Product 5', brand: 'Brand E', price: '50.0'),
              const ProductItemEntity(id: '6', name: 'Product 6', brand: 'Brand F', price: '60.0'),
            ]);
        return productsCubit;
      },
      act: (cubit) => cubit.selectCategory(Category.electronics),
      expect: () => [
        ProductsLoading(),
        ProductsLoaded([
          const ProductItemEntity(id: '5', name: 'Product 5', brand: 'Brand E', price: '50.0'),
          const ProductItemEntity(id: '6', name: 'Product 6', brand: 'Brand F', price: '60.0'),
        ]),
      ],
      verify: (_) {
        // Verify that GetProductsByCategoryUseCase.execute was called with correct parameters
        verify(mockGetProductsByCategoryUseCase.execute(
          category: 'Electronics',
          page: 0,
          perPage: 10,
        )).called(1);
      },
    );

    blocTest<ProductsCubit, ProductsState>(
      'does not fetch products if already fetching',
      build: () {
        // Stub the GetProductsUseCase to delay the response
        when(mockGetProductsUseCase.execute(page: anyNamed('page'), perPage: anyNamed('perPage')))
            .thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return [
            const ProductItemEntity(id: '1', name: 'Product 1', brand: 'Brand A', price: '10.0'),
          ];
        });
        return productsCubit;
      },
      act: (cubit) async {
        // Start fetching products
        cubit.fetchProducts(isInitialLoad: true);
        // Immediately try to fetch again while the first fetch is still in progress
        cubit.fetchProducts();
        // Wait for the first fetch to complete
        await Future.delayed(const Duration(milliseconds: 150));
      },
      expect: () => [
        ProductsLoading(),
        ProductsLoaded([
          const ProductItemEntity(id: '1', name: 'Product 1', brand: 'Brand A', price: '10.0'),
        ]),
      ],
      verify: (_) {
        // Ensure that the second fetchProducts call was ignored
        verify(mockGetProductsUseCase.execute(page: 0, perPage: 10)).called(1);
        verifyNever(mockGetProductsUseCase.execute(page: 1, perPage: 10));
      },
    );

    blocTest<ProductsCubit, ProductsState>(
      'emits [ProductsLoading, ProductsLoaded] when refreshing products',
      build: () {
        // Stub the GetProductsUseCase to return a list of products
        when(mockGetProductsUseCase.execute(page: anyNamed('page'), perPage: anyNamed('perPage')))
            .thenAnswer((_) async => [
                  const ProductItemEntity(id: '7', name: 'Product 7', brand: 'Brand G', price: '70.0'),
                  const ProductItemEntity(id: '8', name: 'Product 8', brand: 'Brand H', price: '80.0'),
                ]);
        return productsCubit;
      },
      act: (cubit) => cubit.refreshProducts(),
      expect: () => [
        ProductsLoading(),
        ProductsLoaded([
          const ProductItemEntity(id: '7', name: 'Product 7', brand: 'Brand G', price: '70.0'),
          const ProductItemEntity(id: '8', name: 'Product 8', brand: 'Brand H', price: '80.0'),
        ]),
      ],
      verify: (_) {
        // Verify that fetchProducts was called with isInitialLoad: true
        verify(mockGetProductsUseCase.execute(page: 0, perPage: 10)).called(1);
      },
    );
  });
}
