package com.somba.api.core.entities;

import java.util.List;
import java.util.UUID;

import com.somba.api.core.enums.Category;

public record Product(
    UUID id,
    String name,
    String description,
    String brand,
    int price,
    int stock,
    Category category,
    List<Review> reviews
) {

  public Product(UUID id, String name, String description, String brand, int price, int stock, Category category) {
    this(id, name, description, brand, price, stock, category, List.of());
  }

  public Product(String name, String description, String brand, int price, int stock, Category category) {
    this(UUID.randomUUID(), name, description, brand, price, stock, category);
  }
}
