package com.somba.api.core.usecases;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.*;

import java.util.List;
import java.util.UUID;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import com.somba.api.core.entities.Product;
import com.somba.api.core.ports.ProductRepository;

class ListProductsUseCaseTest {

    @Mock
    private ProductRepository productRepository;

    private ListProductsUseCase listProductsUseCase;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        listProductsUseCase = new ListProductsUseCase(productRepository);
    }

    @Test
    void shouldReturnProductsWhenRepositoryIsNotEmpty() {
        // Given
        var products = List.of(
            new Product(UUID.randomUUID(), "Product 1", "Description 1", "Brand 1", 100, 10, null),
            new Product(UUID.randomUUID(), "Product 2", "Description 2", "Brand 2", 200, 20, null)
        );
        
        when(productRepository.getProducts(0, 2)).thenReturn(products);

        // When
        List<Product> result = listProductsUseCase.execute(0, 2);

        // Then
        assertThat(result).hasSize(2);
        assertThat(result.get(0).name()).isEqualTo("Product 1");
        verify(productRepository, times(1)).getProducts(0, 2);
    }

    @Test
    void shouldReturnEmptyListWhenRepositoryIsEmpty() {
        // Given
        when(productRepository.getProducts(0, 5)).thenReturn(List.of());

        // When
        List<Product> result = listProductsUseCase.execute(0, 5);

        // Then
        assertThat(result).isEmpty();
        verify(productRepository, times(1)).getProducts(0, 5);
    }

    @Test
    void shouldHandleLargePageRequestsGracefully() {
        // Given
        when(productRepository.getProducts(100, 10)).thenReturn(List.of());

        // When
        List<Product> result = listProductsUseCase.execute(100, 10);

        // Then
        assertThat(result).isEmpty();
        verify(productRepository, times(1)).getProducts(100, 10);
    }
}
