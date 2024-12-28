package com.somba.api.adapter.mappers;

import java.util.UUID;

import org.springframework.stereotype.Component;

import com.somba.api.adapter.presenters.ReviewView;
import com.somba.api.core.entities.Review;
import com.somba.api.infrastructure.persistence.entities.ReviewEntity;

@Component
public class ReviewMapper {

  public ReviewEntity toEntity(Review review) {
    return new ReviewEntity()
      .setId(review.id().toString())
      .setProductId(review.productId().toString())
      .setRating(review.rating());
  }


  public Review toDomain(ReviewEntity reviewEntity) {
    return new Review(
      UUID.fromString(reviewEntity.getId()),
      UUID.fromString(reviewEntity.getProductId()),
      reviewEntity.getRating()
    );
  }

  public ReviewView toReviewView(Review review) {
    return new ReviewView(
      review.id().toString(),
      review.productId().toString(),
      review.rating()
    );
  }
}
