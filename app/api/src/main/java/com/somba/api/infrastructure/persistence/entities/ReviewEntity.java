package com.somba.api.infrastructure.persistence.entities;

import java.time.LocalDateTime;
import java.util.Objects;


import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;
import com.somba.api.infrastructure.persistence.listeners.ReviewEntityListener;
import jakarta.persistence.EntityListeners;
import jakarta.persistence.Id;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;

@Document(collection = "reviews")
@EntityListeners(ReviewEntityListener.class)
public class ReviewEntity {
  
  @Id
  private String id;

  @DBRef
  private ProductEntity product;

  private int rating;

  @CreatedDate
  private LocalDateTime createdAt;

  @LastModifiedDate
  private LocalDateTime updatedAt;

  public ReviewEntity() {
    // Empty constructor needed by Spring Data
  }

  public String getId() {
    return this.id;
  }

  public ReviewEntity setId(String id) {
    this.id = id;

    return this;
  }

  public ProductEntity getProduct() {
    return this.product;
  }

  public ReviewEntity setProduct(ProductEntity product) {
    this.product = product;

    return this;
  }

  public int getRating() {
    return this.rating;
  }

  public ReviewEntity setRating(int rating) {
    this.rating = rating;

    return this;
  }

  public LocalDateTime getCreatedAt() {
    return this.createdAt;
  }

  public ReviewEntity setCreatedAt(LocalDateTime createdAt) {
    this.createdAt = createdAt;

    return this;
  }

  public LocalDateTime getUpdatedAt() {
    return this.updatedAt;
  }

  public ReviewEntity setUpdatedAt(LocalDateTime updatedAt) {
    this.updatedAt = updatedAt;

    return this;
  }

  @Override
  public String toString() {
    return "ReviewEntity{" +
      "id='" + id + '\'' +
      ", product=" + product +
      ", rating=" + rating +
      ", createdAt=" + createdAt +
      ", updatedAt=" + updatedAt +
      '}';
  }

  @Override
  public boolean equals(Object o) {
    if (this == o)
      return true;
    if (o == null || getClass() != o.getClass())
      return false;
    
    ReviewEntity that = (ReviewEntity) o;

    return rating == that.rating &&
      Objects.equals(id, that.id) &&
      Objects.equals(product, that.product) &&
      Objects.equals(createdAt, that.createdAt) &&
      Objects.equals(updatedAt, that.updatedAt);
  }

  @Override
  public int hashCode() {
    return Objects.hash(id, product, rating, createdAt, updatedAt);
  }

}
