package com.somba.api.infrastructure.persistence.listeners;

import java.time.LocalDateTime;

import com.somba.api.infrastructure.persistence.entities.ProductEntity;

import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;

public class ProductEntityListener {

  @PrePersist
  public void prePersist(ProductEntity productEntity) {
    LocalDateTime now = LocalDateTime.now();

    productEntity.setCreatedAt(now);
    productEntity.setUpdatedAt(now);
  }

  @PreUpdate
  public void preUpdate(ProductEntity productEntity) {
    productEntity.setUpdatedAt(LocalDateTime.now());
  }
  
}
