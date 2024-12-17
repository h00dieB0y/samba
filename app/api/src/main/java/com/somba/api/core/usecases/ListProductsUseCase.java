
package com.somba.api.core.usecases;

import java.util.List;
import org.springframework.stereotype.Service;

import com.somba.api.core.entities.Product;
import com.somba.api.core.ports.ProductRepository;

@Service
public class ListProductsUseCase {

  private final ProductRepository productRepository;

  public ListProductsUseCase(ProductRepository productRepository) {
    this.productRepository = productRepository;
  }

  public List<Product> execute(int page, int size) {
    return productRepository.getProducts(page, size);
  }
}
