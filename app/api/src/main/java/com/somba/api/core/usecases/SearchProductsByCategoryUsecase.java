package com.somba.api.core.usecases;

import java.util.List;

import org.springframework.stereotype.Service;

import com.somba.api.core.entities.Product;
import com.somba.api.core.enums.Category;
import com.somba.api.core.exceptions.InvalidPaginationParameterException;
import com.somba.api.core.ports.ProductRepository;

@Service
public class SearchProductsByCategoryUsecase {

  private final ProductRepository productRepository;

  public SearchProductsByCategoryUsecase(ProductRepository productRepository) {
    this.productRepository = productRepository;
  }
  
  public List<Product> execute(String category, int page, int size) {
    if (page < 0 || size < 1) {
      throw new InvalidPaginationParameterException(page, size);
    }
    return productRepository.getProductsByCategory(Category.fromValue(category), page, size);
  }
}
