package com.somba.api.core.ports;

import java.util.List;

import com.somba.api.core.entities.Product;

public interface ProductSearchRepository {
  void index(Product product);
  List<Product> search(String query);
}
