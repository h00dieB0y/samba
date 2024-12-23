// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:ui/data/datasources/remote/product_remote_data_source.dart';
import 'package:ui/data/repositories/product_repository_impl.dart';
import 'package:ui/domain/repositories/product_repository.dart';
import 'package:ui/domain/usecases/get_products_by_category_use_case.dart';
import 'package:ui/domain/usecases/get_products_use_case.dart';
import 'package:ui/presentation/pages/home_page/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProductRepository>(
          create: (context) => ProductRepositoryImpl(
            ProductRemoteDataSource(http.Client()),
          ),
        ),
        RepositoryProvider<GetProductsUseCase>(
          create: (context) => GetProductsUseCase(
            context.read<ProductRepository>(),
          ),
        ),
        RepositoryProvider<GetProductsByCategoryUseCase>(
          create: (context) => GetProductsByCategoryUseCase(
            context.read<ProductRepository>(),
          ),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}