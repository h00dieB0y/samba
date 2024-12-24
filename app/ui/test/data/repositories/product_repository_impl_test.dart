import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ui/data/datasources/remote/product_remote_data_source.dart';
import 'package:ui/data/models/product_item_model.dart';
import 'package:ui/data/models/search_product_item_model.dart';
//import 'package:ui/data/models/search_product_item_model.dart'; // <-- Import the new search model
import 'package:ui/data/repositories/product_repository_impl.dart';
import 'package:ui/domain/entities/product_item_entity.dart';
import 'package:ui/domain/entities/search_product_item_entity.dart';
//import 'package:ui/domain/entities/search_product_item_entity.dart'; // <-- Import the search entity

import 'product_repository_impl_test.mocks.dart';

@GenerateMocks([ProductRemoteDataSource])
void main() {
  late ProductRepositoryImpl repository;
  late MockProductRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockProductRemoteDataSource();
    repository = ProductRepositoryImpl(mockRemoteDataSource);
  });

  group('getProducts', () {
    final tProductModels = [
      ProductItemModel(
          id: '1', name: 'Test Product 1', brand: 'Brand 1', price: 1000),
      ProductItemModel(
          id: '2', name: 'Test Product 2', brand: 'Brand 2', price: 2000),
    ];

    final tProductEntities = [
      ProductItemEntity(
          id: '1', name: 'Test Product 1', brand: 'Brand 1', price: '1,000'),
      ProductItemEntity(
          id: '2', name: 'Test Product 2', brand: 'Brand 2', price: '2,000'),
    ];

    test(
      'should return a list of ProductItemEntity when the call to remote data source is successful',
      () async {
        // Arrange
        when(mockRemoteDataSource.getProducts(
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        )).thenAnswer((_) async => tProductModels);

        // Act
        final result = await repository.getProducts(page: 1, perPage: 10);

        // Assert
        verify(mockRemoteDataSource.getProducts(page: 1, perPage: 10));
        expect(result, tProductEntities);
      },
    );

    test(
      'should throw an exception when the call to remote data source is unsuccessful',
      () async {
        // Arrange
        when(mockRemoteDataSource.getProducts(
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        )).thenThrow(Exception('Failed to fetch products'));

        // Act
        final call = repository.getProducts(page: 1, perPage: 10);

        // Assert
        expect(() => call, throwsA(isA<Exception>()));
        verify(mockRemoteDataSource.getProducts(page: 1, perPage: 10));
      },
    );

    test(
      'should return an empty list when the remote data source returns an empty list',
      () async {
        // Arrange
        when(mockRemoteDataSource.getProducts(
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        )).thenAnswer((_) async => []);

        // Act
        final result = await repository.getProducts(page: 1, perPage: 10);

        // Assert
        verify(mockRemoteDataSource.getProducts(page: 1, perPage: 10));
        expect(result, []);
      },
    );
  });

  group('getProductsByCategory', () {
    final tCategory = 'Electronics';
    final tProductModelsByCategory = [
      ProductItemModel(
          id: '3',
          name: 'Electronics Product 1',
          brand: 'Brand E1',
          price: 3000),
      ProductItemModel(
          id: '4',
          name: 'Electronics Product 2',
          brand: 'Brand E2',
          price: 4000),
    ];

    final tProductEntitiesByCategory = [
      ProductItemEntity(
          id: '3',
          name: 'Electronics Product 1',
          brand: 'Brand E1',
          price: '3,000'),
      ProductItemEntity(
          id: '4',
          name: 'Electronics Product 2',
          brand: 'Brand E2',
          price: '4,000'),
    ];

    test(
      'should return a list of ProductItemEntity when fetching products by category is successful',
      () async {
        // Arrange
        when(mockRemoteDataSource.getProductsByCategory(
          category: anyNamed('category'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        )).thenAnswer((_) async => tProductModelsByCategory);

        // Act
        final result = await repository.getProductsByCategory(
          category: tCategory,
          page: 1,
          perPage: 10,
        );

        // Assert
        verify(mockRemoteDataSource.getProductsByCategory(
          category: tCategory,
          page: 1,
          perPage: 10,
        ));
        expect(result, tProductEntitiesByCategory);
      },
    );

    test(
      'should throw an exception when fetching products by category is unsuccessful',
      () async {
        // Arrange
        when(mockRemoteDataSource.getProductsByCategory(
          category: anyNamed('category'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        )).thenThrow(Exception('Failed to fetch products by category'));

        // Act
        final call = repository.getProductsByCategory(
          category: tCategory,
          page: 1,
          perPage: 10,
        );

        // Assert
        expect(() => call, throwsA(isA<Exception>()));
        verify(mockRemoteDataSource.getProductsByCategory(
          category: tCategory,
          page: 1,
          perPage: 10,
        ));
      },
    );

    test(
      'should return an empty list when the remote data source returns an empty list for a category',
      () async {
        // Arrange
        when(mockRemoteDataSource.getProductsByCategory(
          category: anyNamed('category'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        )).thenAnswer((_) async => []);

        // Act
        final result = await repository.getProductsByCategory(
          category: tCategory,
          page: 1,
          perPage: 10,
        );

        // Assert
        verify(mockRemoteDataSource.getProductsByCategory(
          category: tCategory,
          page: 1,
          perPage: 10,
        ));
        expect(result, []);
      },
    );
  });

  group('searchProducts', () {
    final tQuery = 'test';

    // Example search product models returned from the remote data source
    final tSearchProductModels = [
      SearchProductItemModel(
        id: '1',
        name: 'Test Product 1',
        brand: 'Brand 1',
        price: 10,
        rating: 4.5,
        reviewCount: 20,
        isSponsored: false,
        isBestSeller: false,
      ),
      SearchProductItemModel(
        id: '2',
        name: 'Test Product 2',
        brand: 'Brand 2',
        price: 20,
        rating: 4.0,
        reviewCount: 10,
        isSponsored: true,
        isBestSeller: false,
      ),
    ];

    // The corresponding search product entities that should come out of the repository
    final tSearchProductEntities = [
      SearchProductItemEntity(
        id: '1',
        name: 'Test Product 1',
        brand: 'Brand 1',
        price: '10',
        rating: 4.5,
        reviewCount: 20,
        isSponsored: false,
        isBestSeller: false,
      ),
      SearchProductItemEntity(
        id: '2',
        name: 'Test Product 2',
        brand: 'Brand 2',
        price: '20',
        rating: 4.0,
        reviewCount: 10,
        isSponsored: true,
        isBestSeller: false,
      ),
    ];

    test(
      'should return a list of SearchProductItemEntity when the call to remote data source is successful',
      () async {
        // Arrange
        when(mockRemoteDataSource.searchProducts(tQuery))
            .thenAnswer((_) async => tSearchProductModels);

        // Act
        final result = await repository.searchProducts(tQuery);

        // Assert
        verify(mockRemoteDataSource.searchProducts(tQuery));
        expect(result, tSearchProductEntities);
      },
    );

    test(
      'should throw an exception when the call to remote data source is unsuccessful',
      () async {
        // Arrange
        when(mockRemoteDataSource.searchProducts(tQuery))
            .thenThrow(Exception('Failed to search products'));

        // Act
        final call = repository.searchProducts(tQuery);

        // Assert
        expect(() => call, throwsA(isA<Exception>()));
        verify(mockRemoteDataSource.searchProducts(tQuery));
      },
    );

    test(
      'should return an empty list when the remote data source returns an empty list',
      () async {
        // Arrange
        when(mockRemoteDataSource.searchProducts(tQuery))
            .thenAnswer((_) async => []);

        // Act
        final result = await repository.searchProducts(tQuery);

        // Assert
        verify(mockRemoteDataSource.searchProducts(tQuery));
        expect(result, []);
      },
    );
  });
}
