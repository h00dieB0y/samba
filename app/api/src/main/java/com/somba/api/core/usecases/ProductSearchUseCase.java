package com.somba.api.core.usecases;

import java.util.List;

import org.springframework.stereotype.Service;

import com.somba.api.core.entities.Product;
import com.somba.api.core.ports.ProductSearchRepository;

@Service
public class ProductSearchUseCase {

  ProductSearchRepository productSearchRepository;

  public ProductSearchUseCase(ProductSearchRepository productSearchRepository) {
    this.productSearchRepository = productSearchRepository;
  }

  public List<Product> search(String keyword) {
    return productSearchRepository.search(keyword);
  }
}
