package com.somba.api.adapter.repositories;

import java.util.List;

import com.somba.api.core.entities.Product;
import com.somba.api.core.ports.ProductSearchRepository;

public class ElasticSearchProductRepositoryAdapter implements ProductSearchRepository {

  @Override
  public void index(Product product) {
    throw new UnsupportedOperationException("Unimplemented method 'index'");
  }

  @Override
  public List<Product> search(String query) {
    throw new UnsupportedOperationException("Unimplemented method 'search'");
  }
}
