package com.somba.api.core.usecases;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.List;
import java.util.UUID;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import com.somba.api.core.entities.Product;
import com.somba.api.core.exceptions.InvalidKeywordException;
import com.somba.api.core.ports.ProductSearchRepository;

class ProductSearchUseCaseTest {
  
  @Mock
  private ProductSearchRepository productSearchRepository;

  private ProductSearchUseCase productSearchUseCase;

  @BeforeEach
  void setUp() {
    MockitoAnnotations.openMocks(this);
    productSearchUseCase = new ProductSearchUseCase(productSearchRepository);
  }

  @Test
  void shouldReturnProductsWhenRepositoryIsNotEmpty() {
    // Given
    var products = List.of(
        new Product(UUID.randomUUID(), "Product 1", "Description 1", "Brand 1", 100, 10),
        new Product(UUID.randomUUID(), "Product 2", "Description 2", "Brand 2", 200, 20)
    );
    
    when(productSearchRepository.search("Product")).thenReturn(products);

    // When
    List<Product> result = productSearchUseCase.search("Product");

    // Then
    assertThat(result).hasSize(2);
    assertThat(result.get(0).name()).isEqualTo("Product 1");
    verify(productSearchRepository, times(1)).search("Product");
  }

  @Test
  void shouldReturnEmptyListWhenRepositoryIsEmpty() {
    // Given
    when(productSearchRepository.search("Product")).thenReturn(List.of());

    // When
    List<Product> result = productSearchUseCase.search("Product");

    // Then
    assertThat(result).isEmpty();
    verify(productSearchRepository, times(1)).search("Product");
  }

  @Test
  void shouldThrowExceptionWhenQueryIsNull() {
    // Given
    // When
    // Then
    assertThrows(InvalidKeywordException.class, () -> productSearchUseCase.search(null));
  }

  @Test
  void shouldThrowExceptionWhenQueryIsEmpty() {
    // Given
    // When
    // Then
    assertThrows(InvalidKeywordException.class, () -> productSearchUseCase.search(""));
  }

  @Test
  void shouldThrowExceptionWhenQueryIsTooShort() {
    // Given
    // When
    // Then
    assertThrows(InvalidKeywordException.class, () -> productSearchUseCase.search("ab"));
  }

  @Test
  void shouldThrowExceptionWhenQueryIsTooShortWithSpaces() {
    // Given
    // When
    // Then
    assertThrows(InvalidKeywordException.class, () -> productSearchUseCase.search(" ab "));
  }
}
