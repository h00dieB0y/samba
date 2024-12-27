package com.somba.api.core.ports;

public interface ReviewRepository {
  void addReview(String productId, int rating);
}
