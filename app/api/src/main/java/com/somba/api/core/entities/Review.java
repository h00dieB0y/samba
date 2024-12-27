package com.somba.api.core.entities;

import java.util.UUID;

public record Review(
  UUID id,
  Product product,
  int rating
) {

  public Review(Product product, int rating) {
    this(UUID.randomUUID(), product, rating);
  }

  public static boolean isValidRating(int rating) {
    return rating >= 1 && rating <= 5;
  }
}
