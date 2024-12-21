import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/data/datasources/remote/product_remote_data_source.dart';
import 'package:ui/data/repositories/product_repository_impl.dart';
import 'package:ui/domain/repositories/product_repository.dart';
import 'package:http/http.dart' as http;

// Http Client Provider (shared across the app)
final httpClientProvider = Provider((ref) => http.Client());

// Remote Data Source Provider
final productRemoteDataSourceProvider = Provider(
  (ref) => ProductRemoteDataSource(ref.read(httpClientProvider)),
);

// Repository Provider (Implements ProductRepository)
final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepositoryImpl(ref.read(productRemoteDataSourceProvider)),
);