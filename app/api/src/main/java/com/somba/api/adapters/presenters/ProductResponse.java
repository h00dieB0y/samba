package com.somba.api.adapters.presenters;

import com.somba.api.core.entities.Product;

public record ProductResponse(
    String id,
    String name,
    String brand,
    int price
) {
  
  public static ProductResponse fromDomain(Product product) {
    return new ProductResponse(
        product.getId().toString(),
        product.getName(),
        product.getBrand(),
        product.getPrice()
    );
  }
}
