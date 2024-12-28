package com.somba.api.core.usecases;

import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.when;

import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.NullSource;
import org.junit.jupiter.params.provider.ValueSource;
import org.junit.jupiter.api.Nested;

import com.somba.api.core.ports.ProductRepository;
import com.somba.api.core.ports.ReviewRepository;
import com.somba.api.core.entities.Product;
import com.somba.api.core.exceptions.ResourceNotFoundException;

@ExtendWith(MockitoExtension.class)
class CalculateProductAverageRatingUseCaseTest {
  
  @Mock
  private ReviewRepository reviewRepository;

  @Mock
  private ProductRepository productRepository;

  private CalculateProductAverageRatingUseCase calculateProductAverageRatingUseCase;

  private GetProductByIdUseCase getProductByIdUseCase;

  private Product product;

  @BeforeEach
  void setUp() {
    getProductByIdUseCase = new GetProductByIdUseCase(productRepository);
    calculateProductAverageRatingUseCase = new CalculateProductAverageRatingUseCase(reviewRepository, getProductByIdUseCase);
  }

  @Nested
  class GivenValidProductId {

    @BeforeEach
    void setUp() {
      product = new Product("Product 1", "Description 1", "Brand 1", 100, 10, null);
    }

    @Nested
    class WhenCalculateProductAverageRating {
      private double result;

      @BeforeEach
      void executeUseCase() {
        when(productRepository.getProductById(product.id())).thenReturn(Optional.of(product));
        when(reviewRepository.getAverageRatingByProductId(product.id().toString())).thenReturn(4.5);
        result = calculateProductAverageRatingUseCase.execute(product.id().toString());
      }

      @Test
      void shouldReturnProduct() {
        assertThat(result).isEqualTo(4.5);
      }
    }
  }

  @Nested
  class WhenCalculateProductAverageRatingWithInvalidId {
    @ParameterizedTest
    @NullSource
    @ValueSource(strings = {"", " ", "invalid"})
    void shouldThrowException(String invalidId) {
      assertThrows(ResourceNotFoundException.class, () -> calculateProductAverageRatingUseCase.execute(invalidId));
    }
  }
}
