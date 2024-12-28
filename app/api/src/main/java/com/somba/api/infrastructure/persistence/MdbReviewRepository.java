package com.somba.api.infrastructure.persistence;

import org.springframework.data.mongodb.repository.MongoRepository;

import com.somba.api.infrastructure.persistence.entities.ReviewEntity;

public interface MdbReviewRepository extends MongoRepository<ReviewEntity, String> {
  double averageRating(String productId);
}
