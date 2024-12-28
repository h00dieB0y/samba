package com.somba.api.core.entities;

import java.util.UUID;

public record Review(
  UUID id,
  UUID productId,
  int rating
) {

  public Review(UUID productId, int rating) {
    this(UUID.randomUUID(), productId, rating);
  }

  public static boolean isValidRating(int rating) {
    return rating >= 1 && rating <= 5;
  }
}
