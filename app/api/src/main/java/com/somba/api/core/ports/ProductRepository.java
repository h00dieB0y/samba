package com.somba.api.core.ports;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import com.somba.api.core.entities.Product;
import com.somba.api.core.enums.Category;

public interface ProductRepository {

  List<Product> getProducts(int page, int size);

  Optional<Product> getProductById(UUID id);

  List<Product> getProductsByCategory(Category category, int page, int size);

  Product save(Product product);

  void saveAll(List<Product> products);

  void deleteAll();
}
