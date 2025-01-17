import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:ui/data/datasources/remote/product_remote_data_source.dart';
import 'package:ui/data/repositories/product_repository_impl.dart';
import 'package:ui/domain/entities/product_details_entity.dart';
import 'package:ui/domain/entities/related_product_entity.dart';
import 'package:ui/domain/entities/review_entity.dart';
import 'package:ui/domain/repositories/product_repository.dart';
import 'package:ui/domain/usecases/get_products_by_category_use_case.dart';
import 'package:ui/domain/usecases/get_products_use_case.dart';
import 'package:ui/domain/usecases/search_products_use_case.dart';
import 'package:ui/presentation/pages/product_details_page/product_details_page.dart';

import 'presentation/pages/widgets/main_scaffold.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final exampleProductDetails = ProductDetailsEntity(
    id: 'prod123',
    name: 'Wireless Bluetooth Headphones',
    brand: 'SoundMagic',
    price: '99.99',
    oldPrice: '129.99',
    discount: '23% off',
    stockStatus: 'In Stock',
    shippingLabel: 'Free shipping over \$50',
    images: [
      'https://placehold.co/600x400.png',
      'https://placehold.co/600x400.png',
      'https://placehold.co/600x400.png',
    ],
    description:
        'Experience high-quality sound without the wires. Our Wireless Bluetooth Headphones offer superior comfort and exceptional audio clarity.',
    specifications: {
      'Brand': 'SoundMagic',
      'Model': 'BT-100',
      'Color': 'Black',
      'Connectivity': 'Bluetooth',
      'Battery Life': '20 hours',
      'Weight': '200g',
    },
    reviews: [
      ReviewEntity(
        username: 'John Doe',
        rating: 4.5,
        comment: 'Great sound quality and very comfortable to wear.',
        date: DateTime.parse('2023-08-15'),
      ),
      ReviewEntity(
        username: 'Jane Smith',
        rating: 5.0,
        comment: 'Excellent headphones! Battery life lasts all day.',
        date: DateTime.parse('2023-09-05'),
      ),
      ReviewEntity(
        username: 'Mike Johnson',
        rating: 4.0,
        comment: 'Good value for the price. A bit bulky but works well.',
        date: DateTime.parse('2023-09-10'),
      ),
    ],
    cartCount: 0,
    relatedProducts: [
      RelatedProductEntity(
        id: 'prod124',
        name: 'Noise Cancelling Earbuds',
        price: '79.99',
        image: 'https://placehold.co/600x400.png',
      ),
      RelatedProductEntity(
        id: 'prod125',
        name: 'Wireless Charging Pad',
        price: '29.99',
        image: 'https://placehold.co/600x400.png',
      ),
      RelatedProductEntity(
        id: 'prod126',
        name: 'Bluetooth Smart Watch',
        price: '199.99',
        image: 'https://placehold.co/600x400.png',
      ),
    ],
    questions: [],
  );
  MyApp({super.key});

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
        RepositoryProvider<SearchProductsUseCase>(
          create: (context) => SearchProductsUseCase(
            context.read<ProductRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Somba',
        home: ProductDetailsPage(product: exampleProductDetails),
      ),
    );
  }
}
