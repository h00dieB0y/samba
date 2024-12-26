package com.somba.api.core.usecases;

import java.util.List;
import java.util.Objects;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.somba.api.core.entities.Product;
import com.somba.api.core.exceptions.InvalidKeywordException;
import com.somba.api.core.ports.ProductSearchRepository;

@Service
public class ProductSearchUseCase {

  private final ProductSearchRepository productSearchRepository;

  public ProductSearchUseCase(ProductSearchRepository productSearchRepository) {
    this.productSearchRepository = productSearchRepository;
  }

  public List<Product> execute(String keyword) {
    String query = Optional.ofNullable(keyword).map(String::trim).orElse(null);

    if (Objects.isNull(query) || query.length() < 3) {
      throw new InvalidKeywordException(keyword);
    }

    return productSearchRepository.search(query);
  }
}
