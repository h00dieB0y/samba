package com.somba.api.adapter.presenters;

public record ProductSearchView(
    String id,
    String name,
    String brand,
    int price,
    double rating,
    int reviewsCount
) {
  
}
