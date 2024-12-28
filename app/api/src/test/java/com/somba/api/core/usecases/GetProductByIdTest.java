package com.somba.api.core.usecases;

import static org.mockito.Mockito.when;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertThrows;


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
import com.somba.api.core.exceptions.ResourceNotFoundException;
import com.somba.api.core.ports.ProductRepository;

@ExtendWith(MockitoExtension.class)
class GetProductByIdTest {
  @Mock
  private ProductRepository productRepository;

  @InjectMocks
  private GetProductByIdUseCase getProductByIdUseCase;

  private Product product;

  @Nested
  class GivenValidProductId {

    @BeforeEach
    void setUp() {
      product = new Product("Product 1", "Description 1", "Brand 1", 100, 10, null);
    }

    @Nested
    class WhenGetProductById {
      private Product result;

      @BeforeEach
      void executeUseCase() {
        when(productRepository.getProductById(product.id())).thenReturn(Optional.of(product));
        result = getProductByIdUseCase.execute(product.id().toString());
      }

      @Test
      void shouldReturnProduct() {
        assertThat(result).isEqualTo(product);
      }

      @Test
      void shouldCallRepository() {
        verify(productRepository, times(1)).getProductById(product.id());
      }
    }

    @Nested
    class WhenGetProductByIdWithInvalidId {
      @ParameterizedTest
      @ValueSource(strings = { "invalid" })
      @NullSource
      void shouldThrowResourceNotFoundException(String id) {
        assertThrows(ResourceNotFoundException.class, () -> getProductByIdUseCase.execute(id));
      }
    }
  }
}
