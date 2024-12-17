package com.somba.api.core.entities;

import java.util.UUID;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.annotation.Id;

@Document(collection = "products")
public class Product {
  
  @Id
  private final UUID id;

  private String name;

  private String description;

  private String brand;

  /*
   * Price in cents
   */
  private int price;

  private int stock;

  public Product(UUID id, String name, String description, String brand, int price, int stock) {
    this.id = id;
    this.name = name;
    this.description = description;
    this.brand = brand;
    this.price = price;
    this.stock = stock;
  }

  public UUID getId() {
    return this.id;
  }

  public String getName() {
    return this.name;
  }

  public String getDescription(){
    return this.description;
  }

  public String getBrand() {
    return this.brand;
  }

  public int getPrice() {
    return this.price;
  }

  public int getStock() {
    return this.stock;
  }

  @Override
  public String toString() {
    return "Product{" +
        "id=" + id +
        ", name='" + name + '\'' +
        ", description='" + description + '\'' +
        ", brand='" + brand + '\'' +
        ", price=" + price +
        ", stock=" + stock +
        '}';
  }

}
