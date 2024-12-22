package com.somba.api.core.ports;

import java.util.List;

import com.somba.api.core.entities.Product;
import com.somba.api.core.enums.Category;

public interface ProductRepository {

  List<Product> getProducts(int page, int size);

  List<Product> getProductsByCategory(Category category, int page, int size);

  void saveAll(List<Product> products);

  void deleteAll();
}
