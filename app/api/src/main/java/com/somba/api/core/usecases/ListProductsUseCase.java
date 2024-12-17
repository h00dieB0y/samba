
package com.somba.api.core.usecases;

import java.util.List;

import com.somba.api.core.entities.Product;
import com.somba.api.core.interfaces.ProductRepository;

public class ListProductsUseCase {

  private final ProductRepository productRepository;

  public ListProductsUseCase(ProductRepository productRepository) {
    this.productRepository = productRepository;
  }

  public List<Product> execute(int page, int size) {
    return productRepository.getProducts(page, size);
  }
}
