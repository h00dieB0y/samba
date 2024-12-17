package com.somba.api.adapters.mappers;

import java.util.UUID;

import org.springframework.stereotype.Component;

import com.somba.api.adapters.presenters.ProductResponse;
import com.somba.api.core.entities.Product;
import com.somba.api.infrastructure.persistence.entities.ProductEntity;

@Component
public class ProductMapper {
  
  public ProductResponse toResponse(Product product) {
    return new ProductResponse(
        product.getId().toString(),
        product.getName(),
        product.getBrand(),
        product.getPrice()
    );
  }
  
  // ProductEntity to Product
  public Product toDomain(ProductEntity productEntity) {
    return new Product(
      UUID.fromString(productEntity.getId()),
      productEntity.getName(),
      productEntity.getDescription(),
      productEntity.getBrand(),
      productEntity.getPrice(),
      productEntity.getStock()
    );
  }
}
