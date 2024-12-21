import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ui/data/datasources/remote/product_remote_data_source.dart';
import 'package:ui/data/models/product_item_model.dart';
import 'package:ui/data/repositories/product_repository_impl.dart';
import 'package:ui/domain/entities/product_item_entity.dart';

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
      ProductItemModel(id: '1', name: 'Test Product 1', brand: 'Brand 1', price: 1000),
      ProductItemModel(id: '2', name: 'Test Product 2', brand: 'Brand 2', price: 2000),
    ];

    final tProductEntities = [
      ProductItemEntity(id: '1', name: 'Test Product 1', brand: 'Brand 1', price: '1,000'),
      ProductItemEntity(id: '2', name: 'Test Product 2', brand: 'Brand 2', price: '2,000'),
    ];

    test('should return a list of ProductItemEntity when the call to remote data source is successful', () async {
      // Arrange
      when(mockRemoteDataSource.getProducts(page: anyNamed('page'), perPage: anyNamed('perPage')))
          .thenAnswer((_) async => tProductModels);

      // Act
      final result = await repository.getProducts(page: 1, perPage: 10);

      // Assert
      verify(mockRemoteDataSource.getProducts(page: 1, perPage: 10));
      expect(result, tProductEntities);
    });

    test('should throw an exception when the call to remote data source is unsuccessful', () async {
      // Arrange
      when(mockRemoteDataSource.getProducts(page: anyNamed('page'), perPage: anyNamed('perPage')))
          .thenThrow(Exception());

      // Act
      final call = repository.getProducts(page: 1, perPage: 10);

      // Assert
      expect(() => call, throwsException);
    });

    test('should return an empty list when the remote data source returns an empty list', () async {
      // Arrange
      when(mockRemoteDataSource.getProducts(page: anyNamed('page'), perPage: anyNamed('perPage')))
          .thenAnswer((_) async => []);

      // Act
      final result = await repository.getProducts(page: 1, perPage: 10);

      // Assert
      expect(result, []);
    });

    test('should handle additional fields in the response from remote data source', () async {
      // Arrange
      final tProductModelsWithExtraFields = [
        ProductItemModel(id: '1', name: 'Test Product 1', brand: 'Brand 1', price: 1000),
        ProductItemModel(id: '2', name: 'Test Product 2', brand: 'Brand 2', price: 2000),
      ];
      when(mockRemoteDataSource.getProducts(page: anyNamed('page'), perPage: anyNamed('perPage')))
          .thenAnswer((_) async => tProductModelsWithExtraFields);

      // Act
      final result = await repository.getProducts(page: 1, perPage: 10);

      // Assert
      expect(result, tProductEntities);
    });

    test('should handle nested objects in the response from remote data source', () async {
      // Arrange
      final tProductModelsWithNestedObjects = [
        ProductItemModel(id: '1', name: 'Test Product 1', brand: 'Brand 1', price: 1000),
        ProductItemModel(id: '2', name: 'Test Product 2', brand: 'Brand 2', price: 2000),
      ];
      when(mockRemoteDataSource.getProducts(page: anyNamed('page'), perPage: anyNamed('perPage')))
          .thenAnswer((_) async => tProductModelsWithNestedObjects);

      // Act
      final result = await repository.getProducts(page: 1, perPage: 10);

      // Assert
      expect(result, tProductEntities);
    });

    test('should throw an exception when the remote data source returns invalid JSON', () async {
      // Arrange
      when(mockRemoteDataSource.getProducts(page: anyNamed('page'), perPage: anyNamed('perPage')))
          .thenThrow(FormatException());

      // Act
      final call = repository.getProducts(page: 1, perPage: 10);

      // Assert
      expect(() => call, throwsException);
    });
  });
}