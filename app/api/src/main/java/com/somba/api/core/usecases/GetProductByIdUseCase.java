package com.somba.api.core.usecases;

import java.util.UUID;

import org.springframework.stereotype.Service;

import com.somba.api.core.entities.Product;
import com.somba.api.core.exceptions.ResourceNotFoundException;
import com.somba.api.core.ports.ProductRepository;

@Service
public class GetProductByIdUseCase {
  private final ProductRepository productRepository;

  public GetProductByIdUseCase(ProductRepository productRepository) {
    this.productRepository = productRepository;
  }

  public Product execute(String productId) {
    UUID id;
    try {
      id = UUID.fromString(productId);
    } catch (IllegalArgumentException | NullPointerException e) {
      throw new ResourceNotFoundException(productId, Product.class);
    }

    return productRepository.getProductById(id)
    .orElseThrow(() -> new ResourceNotFoundException(productId, Product.class));
  }
}
