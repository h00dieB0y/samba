package com.somba.api.core.usecases;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.List;
import java.util.UUID;
import java.util.stream.IntStream;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.somba.api.core.entities.Product;
import com.somba.api.core.enums.Category;
import com.somba.api.core.exceptions.InvalidCategoryException;
import com.somba.api.core.exceptions.InvalidPaginationParameterException;
import com.somba.api.core.exceptions.NullCategoryException;
import com.somba.api.core.ports.ProductRepository;

@ExtendWith(MockitoExtension.class)
class ListProductsByCategoryUsecaseTest {

  @Mock
  private ProductRepository productRepository;

  @InjectMocks
  private ListProductsByCategoryUsecase searchProductsByCategoryUsecase;

  private List<Product> generateProducts(int size, Category category) {
    return IntStream.range(0, size)
        .mapToObj(i -> new Product(UUID.randomUUID(), "Product " + i, "Description " + i, "Brand " + i, 100 * i, 10 * i,
            category))
        .toList();
  }

  @Test
  void shouldReturnProductsWhenRepositoryIsNotEmpty() {
    // Given
    var category = "electronics";
    var page = 0;
    var size = 2;
    var products = generateProducts(size, Category.fromValue(category));

    when(productRepository.getProductsByCategory(Category.fromValue(category), page, size)).thenReturn(products);

    // When
    List<Product> result = searchProductsByCategoryUsecase.execute(category, page, size);

    // Then
    assertThat(result).hasSize(2);
    verify(productRepository).getProductsByCategory(Category.fromValue(category), page, size);
  }

  @Test
  void shouldThrowInvalidCategoryExceptionWhenCategoryIsInvalid() {
    // Given
    var category = "invalid";
    var page = 0;
    var size = 2;

    // When & Then
    assertThrows(InvalidCategoryException.class, () -> {
      searchProductsByCategoryUsecase.execute(category, page, size);
    });
  }

  @Test
  void shouldThrowNullCategoryExceptionWhenCategoryIsNull() {
    // Given
    String category = null;
    var page = 0;
    var size = 2;

    // When & Then
    assertThrows(NullCategoryException.class, () -> {
      searchProductsByCategoryUsecase.execute(category, page, size);
    });
  }

  @Test
  void shouldThrowInvalidPageExceptionWhenPageIsNegative() {
    // Given
    var category = "electronics";
    var page = -1;
    var size = 2;

    // When & Then
    assertThrows(InvalidPaginationParameterException.class, () -> {
      searchProductsByCategoryUsecase.execute(category, page, size);
    });
  }

  @Test
  void shouldThrowInvalidSizeExceptionWhenSizeIsNegative() {
    // Given
    var category = "electronics";
    var page = 0;
    var size = -1;

    // When & Then
    assertThrows(InvalidPaginationParameterException.class, () -> {
      searchProductsByCategoryUsecase.execute(category, page, size);
    });
  }
}
