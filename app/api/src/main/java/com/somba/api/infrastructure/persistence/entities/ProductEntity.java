package com.somba.api.infrastructure.persistence.entities;

import java.time.LocalDateTime;
import java.util.Objects;

import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.mongodb.core.mapping.Document;

import com.somba.api.infrastructure.persistence.listeners.ProductEntityListener;

import jakarta.persistence.EntityListeners;
import jakarta.persistence.Id;

@Document(collection = "products")
@EntityListeners(ProductEntityListener.class)
public class ProductEntity {

  @Id
  private String id;

  private String name;

  private String description;

  private String brand;

  /**
   * Price of the product in cents
   */
  private int price;

  private int stock;

  @CreatedDate
  private LocalDateTime createdAt;

  @LastModifiedDate
  private LocalDateTime updatedAt;

  public ProductEntity() {
    // Empty constructor needed by Spring Data
  }

  public String getId() {
    return this.id;
  }

  public ProductEntity setId(String id) {
    this.id = id;

    return this;
  }

  public String getName() {
    return this.name;
  }

  public ProductEntity setName(String name) {
    this.name = name;

    return this;
  }

  public String getDescription() {
    return description;
  }

  public ProductEntity setDescription(String description) {
    this.description = description;

    return this;
  }

  public String getBrand() {
    return this.brand;
  }

  public ProductEntity setBrand(String brand) {
    this.brand = brand;

    return this;
  }

  public int getPrice() {
    return this.price;
  }

  public ProductEntity setPrice(int price) {
    this.price = price;

    return this;
  }

  public int getStock() {
    return this.stock;
  }

  public ProductEntity setStock(int stock) {
    this.stock = stock;

    return this;
  }

  public LocalDateTime getCreatedAt() {
    return createdAt;
  }

  public ProductEntity setCreatedAt(LocalDateTime createdAt) {
    this.createdAt = createdAt;

    return this;
  }

  public LocalDateTime getUpdatedAt() {
    return updatedAt;
  }

  public ProductEntity setUpdatedAt(LocalDateTime updatedAt) {
    this.updatedAt = updatedAt;

    return this;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o)
      return true;
    if (o == null || getClass() != o.getClass())
      return false;
    ProductEntity that = (ProductEntity) o;
    return price == that.price &&
        stock == that.stock &&
        Objects.equals(id, that.id) &&
        Objects.equals(name, that.name) &&
        Objects.equals(description, that.description) &&
        Objects.equals(brand, that.brand) &&
        Objects.equals(createdAt, that.createdAt) &&
        Objects.equals(updatedAt, that.updatedAt);
  }

  @Override
  public int hashCode() {
    return Objects.hash(id, name, description, brand, price, stock, createdAt, updatedAt);
  }

  @Override
  public String toString() {
    return "ProductEntity{" +
        "id='" + id + '\'' +
        ", name='" + name + '\'' +
        ", description='" + description + '\'' +
        ", brand='" + brand + '\'' +
        ", price=" + price +
        ", stock=" + stock +
        ", createdAt=" + createdAt +
        ", updatedAt=" + updatedAt +
        '}';
  }
}
