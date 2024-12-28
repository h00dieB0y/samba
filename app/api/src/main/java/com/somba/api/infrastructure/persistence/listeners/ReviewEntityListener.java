package com.somba.api.infrastructure.persistence.listeners;

import java.time.LocalDateTime;

import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;

import com.somba.api.infrastructure.persistence.entities.ReviewEntity;

public class ReviewEntityListener {
  
  @PrePersist
  public void prePersist(ReviewEntity reviewEntity) {
    LocalDateTime now = LocalDateTime.now();

    reviewEntity
      .setCreatedAt(now)
      .setUpdatedAt(now);
  }

  @PreUpdate
  public void preUpdate(ReviewEntity reviewEntity) {
    reviewEntity.setUpdatedAt(LocalDateTime.now());
  }
}
