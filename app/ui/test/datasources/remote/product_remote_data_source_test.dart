// product_remote_data_source_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ui/data/datasources/remote/product_remote_data_source.dart';
import 'package:ui/data/models/product_item_model.dart';
import 'dart:convert';

import 'product_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late ProductRemoteDataSource dataSource;
  late MockClient mockHttpClient;

  const baseUrl = 'http://localhost:8081/api/v1/products';
  
  setUp(() {
    mockHttpClient = MockClient();
    dataSource = ProductRemoteDataSource(mockHttpClient);
  });

  // Helper function to arrange successful HTTP responses
  void arrangeHttpClientSuccess(String endpoint, dynamic data) {
    when(mockHttpClient.get(Uri.parse(endpoint))).thenAnswer(
      (_) async => http.Response(json.encode({'data': data}), 200),
    );
  }

  // Helper function to arrange failed HTTP responses
  void arrangeHttpClientFailure(String endpoint, int statusCode, String message) {
    when(mockHttpClient.get(Uri.parse(endpoint))).thenAnswer(
      (_) async => http.Response(message, statusCode),
    );
  }

  group('getProducts', () {
    const int page = 1;
    const int perPage = 10;
    final String endpoint = '$baseUrl?page=$page&size=$perPage';

    final tProductList = [
      ProductItemModel(id: '1', name: 'Test Product 1', brand: 'Brand 1', price: 1000),
      ProductItemModel(id: '2', name: 'Test Product 2', brand: 'Brand 2', price: 2000),
    ];

    test('should return product list on successful response', () async {
      // Arrange
      final responseData = [
        {'id': '1', 'name': 'Test Product 1', 'brand': 'Brand 1', 'price': 1000},
        {'id': '2', 'name': 'Test Product 2', 'brand': 'Brand 2', 'price': 2000},
      ];
      arrangeHttpClientSuccess(endpoint, responseData);

      // Act
      final result = await dataSource.getProducts(page: page, perPage: perPage);

      // Assert
      expect(result, tProductList);
      verify(mockHttpClient.get(Uri.parse(endpoint))).called(1);
    });

    test('should throw exception on non-200 response', () {
      // Arrange
      arrangeHttpClientFailure(endpoint, 404, 'Not Found');

      // Act
      final call = dataSource.getProducts(page: page, perPage: perPage);

      // Assert
      expect(() => call, throwsA(isA<Exception>()));
      verify(mockHttpClient.get(Uri.parse(endpoint))).called(1);
    });

    test('should return empty list when data is empty', () async {
      // Arrange
      arrangeHttpClientSuccess(endpoint, []);

      // Act
      final result = await dataSource.getProducts(page: page, perPage: perPage);

      // Assert
      expect(result, []);
      verify(mockHttpClient.get(Uri.parse(endpoint))).called(1);
    });

    test('should throw exception on invalid JSON', () {
      // Arrange
      when(mockHttpClient.get(Uri.parse(endpoint))).thenAnswer(
        (_) async => http.Response('Invalid JSON', 200),
      );

      // Act
      final call = dataSource.getProducts(page: page, perPage: perPage);

      // Assert
      expect(() => call, throwsA(isA<FormatException>()));
      verify(mockHttpClient.get(Uri.parse(endpoint))).called(1);
    });
  });

  group('getProductsByCategory', () {
    const String category = 'Electronics';
    const int page = 1;
    const int perPage = 10;
    final String endpoint = '$baseUrl?category=$category&page=$page&size=$perPage';

    final tProductListByCategory = [
      ProductItemModel(id: '3', name: 'Electronics Product 1', brand: 'Brand E1', price: 3000),
      ProductItemModel(id: '4', name: 'Electronics Product 2', brand: 'Brand E2', price: 4000),
    ];

    test('should return product list on successful response', () async {
      // Arrange
      final responseData = [
        {'id': '3', 'name': 'Electronics Product 1', 'brand': 'Brand E1', 'price': 3000},
        {'id': '4', 'name': 'Electronics Product 2', 'brand': 'Brand E2', 'price': 4000},
      ];
      arrangeHttpClientSuccess(endpoint, responseData);

      // Act
      final result = await dataSource.getProductsByCategory(
        category: category,
        page: page,
        perPage: perPage,
      );

      // Assert
      expect(result, tProductListByCategory);
      verify(mockHttpClient.get(Uri.parse(endpoint))).called(1);
    });

    test('should throw exception on non-200 response', () {
      // Arrange
      arrangeHttpClientFailure(endpoint, 500, 'Internal Server Error');

      // Act
      final call = dataSource.getProductsByCategory(
        category: category,
        page: page,
        perPage: perPage,
      );

      // Assert
      expect(() => call, throwsA(isA<Exception>()));
      verify(mockHttpClient.get(Uri.parse(endpoint))).called(1);
    });

    test('should return empty list when data is empty', () async {
      // Arrange
      arrangeHttpClientSuccess(endpoint, []);

      // Act
      final result = await dataSource.getProductsByCategory(
        category: category,
        page: page,
        perPage: perPage,
      );

      // Assert
      expect(result, []);
      verify(mockHttpClient.get(Uri.parse(endpoint))).called(1);
    });

    test('should throw exception on invalid JSON', () {
      // Arrange
      when(mockHttpClient.get(Uri.parse(endpoint))).thenAnswer(
        (_) async => http.Response('Invalid JSON', 200),
      );

      // Act
      final call = dataSource.getProductsByCategory(
        category: category,
        page: page,
        perPage: perPage,
      );

      // Assert
      expect(() => call, throwsA(isA<FormatException>()));
      verify(mockHttpClient.get(Uri.parse(endpoint))).called(1);
    });
  });
}
