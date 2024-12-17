
package com.somba.api.core.usecases;

import java.util.List;

import com.somba.api.adapters.presenters.ProductResponse;
import com.somba.api.adapters.repositories.ProductRepository;

public class ListProductsUseCase {

  private final ProductRepository productRepository;

  public ListProductsUseCase(ProductRepository productRepository) {
    this.productRepository = productRepository;
  }

  public List<ProductResponse> execute(int page, int size) {
    return productRepository.getProducts(page, size).stream()
        .map(ProductResponse::fromDomain)
        .toList();
  }
}
