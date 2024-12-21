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
  const baseUrl = 'http://localhost:8081/api/v1/products?page=1&size=10';
  final tProductList = [
    ProductItemModel(id: '1', name: 'Test Product 1', brand: 'Brand 1', price: 1000),
    ProductItemModel(id: '2', name: 'Test Product 2', brand: 'Brand 2', price: 2000),
  ];

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = ProductRemoteDataSource(mockHttpClient);
  });

  void arrangeHttpClientSuccess(dynamic data) {
    when(mockHttpClient.get(Uri.parse(baseUrl))).thenAnswer(
      (_) async => http.Response(json.encode({'data': data}), 200),
    );
  }

  void arrangeHttpClientFailure(int statusCode, String message) {
    when(mockHttpClient.get(Uri.parse(baseUrl))).thenAnswer(
      (_) async => http.Response(message, statusCode),
    );
  }

  group('getProducts', () {
    test('returns product list on successful response', () async {
      arrangeHttpClientSuccess([
        {'id': '1', 'name': 'Test Product 1', 'brand': 'Brand 1', 'price': 1000},
        {'id': '2', 'name': 'Test Product 2', 'brand': 'Brand 2', 'price': 2000},
      ]);

      final result = await dataSource.getProducts(page: 1, perPage: 10);

      expect(result, tProductList);
      verify(mockHttpClient.get(Uri.parse(baseUrl))).called(1);
    });

    test('throws exception on non-200 response', () {
      arrangeHttpClientFailure(404, 'Not Found');

      expect(() => dataSource.getProducts(page: 1, perPage: 10), throwsException);
      verify(mockHttpClient.get(Uri.parse(baseUrl))).called(1);
    });

    test('returns empty list when data is empty', () async {
      arrangeHttpClientSuccess([]);

      final result = await dataSource.getProducts(page: 1, perPage: 10);

      expect(result, []);
      verify(mockHttpClient.get(Uri.parse(baseUrl))).called(1);
    });

    test('throws exception on invalid JSON', () {
      when(mockHttpClient.get(Uri.parse(baseUrl))).thenAnswer(
        (_) async => http.Response('Invalid JSON', 200),
      );

      expect(() => dataSource.getProducts(page: 1, perPage: 10), throwsException);
      verify(mockHttpClient.get(Uri.parse(baseUrl))).called(1);
    });

    test('ignores additional fields in response', () async {
      arrangeHttpClientSuccess([
        {
          'id': '1',
          'name': 'Test Product 1',
          'brand': 'Brand 1',
          'price': 1000,
          'extra': 'field'
        },
        {
          'id': '2',
          'name': 'Test Product 2',
          'brand': 'Brand 2',
          'price': 2000,
          'extra': 'field'
        },
      ]);

      final result = await dataSource.getProducts(page: 1, perPage: 10);

      expect(result, tProductList);
      verify(mockHttpClient.get(Uri.parse(baseUrl))).called(1);
    });

    test('throws exception on server error', () {
      arrangeHttpClientFailure(500, 'Internal Server Error');

      expect(() => dataSource.getProducts(page: 1, perPage: 10), throwsException);
      verify(mockHttpClient.get(Uri.parse(baseUrl))).called(1);
    });

    test('handles nested objects in response', () async {
      arrangeHttpClientSuccess([
        {
          'id': '1',
          'name': 'Test Product 1',
          'brand': 'Brand 1',
          'price': 1000,
          'details': {'color': 'red'}
        },
        {
          'id': '2',
          'name': 'Test Product 2',
          'brand': 'Brand 2',
          'price': 2000,
          'details': {'color': 'blue'}
        },
      ]);

      final result = await dataSource.getProducts(page: 1, perPage: 10);

      expect(result, tProductList);
      verify(mockHttpClient.get(Uri.parse(baseUrl))).called(1);
    });
  });
}