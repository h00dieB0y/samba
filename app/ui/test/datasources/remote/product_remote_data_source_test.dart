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

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = ProductRemoteDataSource(mockHttpClient);
  });

  group('getProducts', () {
    final tProductList = [
      ProductItemModel(id: '1', name: 'Test Product 1', brand: 'Brand 1', price: 1000),
      ProductItemModel(id: '2', name: 'Test Product 2', brand: 'Brand 2', price: 2000),
    ];

    test('should return a list of ProductItemModel when the response code is 200', () async {
      // Arrange
      when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response(
          json.encode({
            'data': [
              {'id': '1', 'name': 'Test Product 1', 'brand': 'Brand 1', 'price': 1000},
              {'id': '2', 'name': 'Test Product 2', 'brand': 'Brand 2', 'price': 2000},
            ]
          }),
          200));

      // Act
      final result = await dataSource.getProducts();

      // Assert
      expect(result, tProductList);
    });

    test('should throw an exception when the response code is not 200', () async {
      // Arrange
      when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response('Something went wrong', 404));

      // Act
      final call = dataSource.getProducts();

      // Assert
      expect(() => call, throwsException);
    });

    test('should return an empty list when the response code is 200 but data is empty', () async {
      // Arrange
      when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response(
          json.encode({'data': []}),
          200));

      // Act
      final result = await dataSource.getProducts();

      // Assert
      expect(result, []);
    });

    test('should throw an exception when the response body is not a valid JSON', () async {
      // Arrange
      when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response('Invalid JSON', 200));

      // Act
      final call = dataSource.getProducts();

      // Assert
      expect(() => call, throwsException);
    });
  });
}