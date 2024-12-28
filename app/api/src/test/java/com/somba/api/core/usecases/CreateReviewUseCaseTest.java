package com.somba.api.core.usecases;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.NullSource;
import org.junit.jupiter.params.provider.ValueSource;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.somba.api.core.entities.Product;
import com.somba.api.core.entities.Review;
import com.somba.api.core.exceptions.InvalidRatingException;
import com.somba.api.core.exceptions.ResourceNotFoundException;
import com.somba.api.core.ports.ProductRepository;
import com.somba.api.core.ports.ReviewRepository;

@ExtendWith(MockitoExtension.class)
class CreateReviewUseCaseTest {

  @Mock
  private ReviewRepository reviewRepository;

  @Mock
  private ProductRepository productRepository;

  @InjectMocks
  private CreateReviewUseCase createReviewUseCase;

  private Product product;

  @Nested
  class GivenValidProductId {

    @BeforeEach
    void setUp() {
      product = new Product("Product 1", "Description 1", "Brand 1", 100, 10, null);
    }

    @Nested
    class WhenCreateReview {
      @Nested
      class WithValidRating {
        private Review review;

        @BeforeEach
        void executeUseCase() {
          when(productRepository.getProductById(product.id())).thenReturn(Optional.of(product));
          review = createReviewUseCase.execute(product.id().toString(), 5);
        }

        @Test
        void shouldReturnReview() {
          assertThat(review).isNotNull();
          assertThat(review.product()).isEqualTo(product);
          assertThat(review.rating()).isEqualTo(5);
          verify(productRepository).getProductById(product.id());
          verify(productRepository).save(product);
          verify(reviewRepository).save(review);
        }

        @Test
        void shouldAddReviewToProduct() {
          assertThat(product.reviews()).hasSize(1);
        }
      }

      @Nested
      class WithInvalidRating {
        @ParameterizedTest
        @ValueSource(ints = { 0, 6 })
        void shouldThrowInvalidRatingException(int rating) {
          InvalidRatingException exception = 
              assertThrows(
                  InvalidRatingException.class, 
                  () -> createReviewUseCase.execute(product.id().toString(), rating)
              );
          assertThat(exception.getMessage())
              .isEqualTo("Invalid rating: " + rating + ". Rating must be between 1 and 5");
        }
      }
    }
  }

  @Nested
  class GivenInvalidProductId {
    @Nested
    class WhenCreateReview {
      @ParameterizedTest
      @ValueSource(strings = { "invalid" })
      @NullSource
      void shouldThrowResourceNotFoundException(String productId) {
        ResourceNotFoundException exception = 
            assertThrows(
                ResourceNotFoundException.class, 
                () -> createReviewUseCase.execute(productId, 5)
            );
        assertThat(exception.getMessage())
            .isEqualTo("Resource of type Product with id <<" + productId + ">> not found");
      }
    }
  }
}
