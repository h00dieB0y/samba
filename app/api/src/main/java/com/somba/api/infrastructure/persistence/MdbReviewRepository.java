package com.somba.api.infrastructure.persistence;

import org.springframework.data.mongodb.repository.Aggregation;
import org.springframework.data.mongodb.repository.MongoRepository;

import com.somba.api.infrastructure.persistence.entities.ReviewEntity;

public interface MdbReviewRepository extends MongoRepository<ReviewEntity, String> {
  @Aggregation(
    pipeline = {
      "{ $match: { productId: ?0 } }",
      "{ $group: { _id: null, averageRating: { $avg: '$rating' } } }"
    }
  )
  Double averageRating(String productId);
}
