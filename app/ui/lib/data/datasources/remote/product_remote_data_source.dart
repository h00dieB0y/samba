import 'package:http/http.dart' as http;
import 'package:ui/data/models/product_item_model.dart';
import 'dart:convert';

class ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSource(this.client);

  Future<List<ProductItemModel>> getProducts(
      {required int page, required int perPage}) async {
    final response =
        await client.get(Uri.parse('http://localhost:8081/api/v1/products?page=$page&size=$perPage'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> products = jsonResponse['data'];

      return products
          .map((product) => ProductItemModel.fromJson(product))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<ProductItemModel>> getProductsByCategory(
      {required String category, required int page, required int perPage}) async {
    final response = await client.get(
        Uri.parse('http://localhost:8081/api/v1/products/search?category=$category&page=$page&size=$perPage'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> products = jsonResponse['data'];

      return products
          .map((product) => ProductItemModel.fromJson(product))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
