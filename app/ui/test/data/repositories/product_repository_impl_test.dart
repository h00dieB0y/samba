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
      when(mockRemoteDataSource.getProducts()).thenAnswer((_) async => tProductModels);

      // Act
      final result = await repository.getProducts();

      // Assert
      verify(mockRemoteDataSource.getProducts());
      expect(result, tProductEntities);
    });

    test('should throw an exception when the call to remote data source is unsuccessful', () async {
      // Arrange
      when(mockRemoteDataSource.getProducts()).thenThrow(Exception());

      // Act
      final call = repository.getProducts();

      // Assert
      expect(() => call, throwsException);
    });
  });
}