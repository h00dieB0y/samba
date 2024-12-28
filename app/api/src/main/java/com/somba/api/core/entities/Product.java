package com.somba.api.core.entities;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
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
    List<UUID> reviews
) {

  public Product(UUID id, String name, String description, String brand, int price, int stock, Category category) {
    this(id, name, description, brand, price, stock, category, new ArrayList<>());
  }

  public Product(String name, String description, String brand, int price, int stock, Category category) {
    this(UUID.randomUUID(), name, description, brand, price, stock, category);
  }

  public void addReview(UUID reviewId) {
    Objects.requireNonNull(reviewId, "Review ID must not be null");

    if (reviews.contains(reviewId)) {
      throw new IllegalArgumentException("Review ID already exists");
    }

    reviews.add(reviewId);
  }
}
