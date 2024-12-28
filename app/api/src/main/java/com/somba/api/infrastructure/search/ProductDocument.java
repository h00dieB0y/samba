package com.somba.api.infrastructure.search;

import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;

@Document(indexName = "products")
public class ProductDocument {

  @Id
  private String id;

  private String name;

  private String description;

  private String brand;

  private String category;

  private int price;

  private int stock;

  public ProductDocument() {
    // Empty constructor needed by Spring Data
  }

  public String getId() {
    return this.id;
  }

  public ProductDocument setId(String id) {
    this.id = id;

    return this;
  }

  public String getName() {
    return this.name;
  }

  public ProductDocument setName(String name) {
    this.name = name;

    return this;
  }

  public String getDescription() {
    return this.description;
  }

  public ProductDocument setDescription(String description) {
    this.description = description;

    return this;
  }

  public String getBrand() {
    return this.brand;
  }

  public ProductDocument setBrand(String brand) {
    this.brand = brand;

    return this;
  }

  public String getCategory() {
    return this.category;
  }

  public ProductDocument setCategory(String category) {
    this.category = category;

    return this;
  }

  public int getPrice() {
    return this.price;
  }

  public ProductDocument setPrice(int price) {
    this.price = price;

    return this;
  }

  public int getStock() {
    return this.stock;
  }

  public ProductDocument setStock(int stock) {
    this.stock = stock;

    return this;
  }
}
