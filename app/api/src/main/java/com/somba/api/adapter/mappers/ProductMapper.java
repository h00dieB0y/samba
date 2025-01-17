package com.somba.api.adapter.mappers;

import java.util.ArrayList;
import java.util.UUID;

import org.springframework.stereotype.Component;

import com.somba.api.adapter.presenters.ProductSearchView;
import com.somba.api.adapter.presenters.ProductView;
import com.somba.api.core.entities.Product;
import com.somba.api.core.enums.Category;
import com.somba.api.infrastructure.persistence.entities.ProductEntity;
import com.somba.api.infrastructure.search.ProductDocument;

@Component
public class ProductMapper {

  public ProductView toProductView(Product product) {
    return new ProductView(
        product.id().toString(),
        product.name(),
        product.brand(),
        product.price());
  }

  public Product toDomain(ProductEntity productEntity) {
  return new Product(
    UUID.fromString(productEntity.getId()),
    productEntity.getName(),
    productEntity.getDescription(),
    productEntity.getBrand(),
    productEntity.getPrice(),
    productEntity.getStock(),
    Category.valueOf(productEntity.getCategory()),
      productEntity
        .getReviews()
        .parallelStream()
        .map(UUID::fromString)
        .collect(ArrayList::new, ArrayList::add, ArrayList::addAll)
  );
  }

  public ProductEntity toEntity(Product product) {
  return new ProductEntity()
    .setId(product.id().toString())
    .setName(product.name())
    .setDescription(product.description())
    .setBrand(product.brand())
    .setPrice(product.price())
    .setStock(product.stock())
    .setCategory(product.category().name())
    .setReviews(
      product
        .reviews()
        .parallelStream()
        .map(UUID::toString)
        .toList()
    );
  }

  public Product toDomain(ProductDocument productDocument) {
    return new Product(
        UUID.fromString(productDocument.getId()),
        productDocument.getName(),
        productDocument.getDescription(),
        productDocument.getBrand(),
        productDocument.getPrice(),
        productDocument.getStock(),
        Category.valueOf(productDocument.getCategory()),
        new ArrayList<>()
    );
  }

  public ProductDocument toDocument(Product product) {
    return new ProductDocument()
        .setId(product.id().toString())
        .setName(product.name())
        .setDescription(product.description())
        .setBrand(product.brand())
        .setPrice(product.price())
        .setStock(product.stock())
        .setCategory(product.category().name());
  }

  public ProductSearchView toProductSearchView(Product product, double rating) {
    return new ProductSearchView(
        product.id().toString(),
        product.name(),
        product.brand(),
        product.price(),
        rating,
        product.countReviews());
  }
}
