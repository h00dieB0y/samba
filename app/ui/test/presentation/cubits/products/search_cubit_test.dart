import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ui/domain/entities/search_product_item_entity.dart';
import 'package:ui/domain/usecases/search_products_use_case.dart';
import 'package:ui/presentation/cubits/products/search_cubit.dart';
import 'package:ui/presentation/cubits/products/search_state.dart';

import 'search_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SearchProductsUseCase>(),
])
void main() {
  late MockSearchProductsUseCase mockSearchProductsUseCase;

  setUp(() {
    mockSearchProductsUseCase = MockSearchProductsUseCase();
  });

  group('SearchCubit', () {
    test('initial state should be SearchInitial', () {
      final searchCubit = SearchCubit(mockSearchProductsUseCase);
      expect(searchCubit.state, equals(SearchInitial()));
      searchCubit.close();
    });

    blocTest<SearchCubit, SearchState>(
      'emits [SearchLoading, SearchEmpty] when search returns an empty list',
      build: () {
        when(mockSearchProductsUseCase.execute(any))
            .thenAnswer((_) async => []);
        return SearchCubit(mockSearchProductsUseCase);
      },
      act: (cubit) => cubit.searchProducts('empty query'),
      expect: () => [
        SearchLoading(),
        SearchEmpty(),
      ],
      verify: (cubit) {
        verify(mockSearchProductsUseCase.execute('empty query')).called(1);
      },
    );

    blocTest<SearchCubit, SearchState>(
      'emits [SearchLoading, SearchLoaded] when search returns results',
      build: () {
        final tResults = [
          const SearchProductItemEntity(
            id: '1',
            name: 'Search Product 1',
            brand: 'Brand A',
            price: '1,999',
            rating: 4.5,
            reviewCount: 100,
            isSponsored: false,
            isBestSeller: false,
          ),
          const SearchProductItemEntity(
            id: '2',
            name: 'Search Product 2',
            brand: 'Brand B',
            price: '3,499',
            rating: 4.2,
            reviewCount: 50,
            isSponsored: false,
            isBestSeller: true,
          ),
        ];

        when(mockSearchProductsUseCase.execute(any))
            .thenAnswer((_) async => tResults);
        return SearchCubit(mockSearchProductsUseCase);
      },
      act: (cubit) => cubit.searchProducts('normal query'),
      expect: () => [
        SearchLoading(),
        SearchLoaded([
          const SearchProductItemEntity(
            id: '1',
            name: 'Search Product 1',
            brand: 'Brand A',
            price: '1,999',
            rating: 4.5,
            reviewCount: 100,
            isSponsored: false,
            isBestSeller: false,
          ),
          const SearchProductItemEntity(
            id: '2',
            name: 'Search Product 2',
            brand: 'Brand B',
            price: '3,499',
            rating: 4.2,
            reviewCount: 50,
            isSponsored: false,
            isBestSeller: true,
          ),
        ]),
      ],
      verify: (cubit) {
        verify(mockSearchProductsUseCase.execute('normal query')).called(1);
      },
    );

    blocTest<SearchCubit, SearchState>(
      'emits [SearchLoading, SearchError] when search throws an exception',
      build: () {
        when(mockSearchProductsUseCase.execute(any))
            .thenThrow(Exception('Failed to search'));
        return SearchCubit(mockSearchProductsUseCase);
      },
      act: (cubit) => cubit.searchProducts('error query'),
      expect: () => [
        SearchLoading(),
        SearchError('Exception: Failed to search'),
      ],
      verify: (cubit) {
        verify(mockSearchProductsUseCase.execute('error query')).called(1);
      },
    );

    blocTest<SearchCubit, SearchState>(
      'emits [SearchInitial] when reset is called',
      build: () => SearchCubit(mockSearchProductsUseCase),
      act: (cubit) => cubit.reset(),
      expect: () => [
        SearchInitial(),
      ],
    );

    blocTest<SearchCubit, SearchState>(
      'emits [SearchLoading, SearchInitial] when search is called with empty query',
      build: () => SearchCubit(mockSearchProductsUseCase),
      act: (cubit) => cubit.searchProducts(''),
      expect: () => [
        SearchInitial(),
      ],
      verify: (cubit) {
        verifyNever(mockSearchProductsUseCase.execute(any));
      },
    );
  });
}
