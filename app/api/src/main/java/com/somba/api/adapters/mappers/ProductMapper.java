package com.somba.api.adapters.mappers;

import java.util.UUID;

import org.springframework.stereotype.Component;

import com.somba.api.adapters.presenters.ProductView;
import com.somba.api.core.entities.Product;
import com.somba.api.infrastructure.persistence.entities.ProductEntity;

@Component
public class ProductMapper {
  
  public ProductView toResponse(Product product) {
    return new ProductView(
        product.id().toString(),
        product.name(),
        product.brand(),
        product.price()
    );
  }
  
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
