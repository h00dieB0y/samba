package com.somba.api.infrastructure.persistence.entities;

import java.time.LocalDateTime;
import java.util.Objects;

import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.mongodb.core.mapping.Document;

import jakarta.persistence.Id;

@Document(collection = "products")
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
    this.createdAt = LocalDateTime.now();
    this.updatedAt = LocalDateTime.now();
  }

  public String getId() {
      return this.id;
  }

  public void setId(String id) {
      this.id = id;
  }

  public String getName() {
      return this.name;
  }

  public void setName(String name) {
      this.name = name;
  }

  public String getDescription() {
      return description;
  }

  public void setDescription(String description) {
      this.description = description;
  }

  public String getBrand() {
      return this.brand;
  }

  public void setBrand(String brand) {
      this.brand = brand;
  }

  public int getPrice() {
      return this.price;
  }

  public void setPrice(int price) {
      this.price = price;
  }

  public int getStock() {
      return this.stock;
  }

  public void setStock(int stock) {
      this.stock = stock;
  }

  public LocalDateTime getCreatedAt() {
      return createdAt;
  }

  public void setCreatedAt(LocalDateTime createdAt) {
      this.createdAt = createdAt;
  }

  public LocalDateTime getUpdatedAt() {
      return updatedAt;
  }

  public void setUpdatedAt(LocalDateTime updatedAt) {
      this.updatedAt = updatedAt;
  }

  @Override
  public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;
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
