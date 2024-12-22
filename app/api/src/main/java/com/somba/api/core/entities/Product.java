package com.somba.api.core.entities;

import java.util.UUID;

import com.somba.api.core.enums.Category;

public record Product(
    UUID id,
    String name,
    String description,
    String brand,
    int price,
    int stock,
    Category category
) {

  public Product(UUID id, String name, String description, String brand, int price, int stock) {
    this(id, name, description, brand, price, stock, Category.OTHERS);
  }
}
