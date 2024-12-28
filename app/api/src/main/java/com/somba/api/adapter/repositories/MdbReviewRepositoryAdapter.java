package com.somba.api.adapter.repositories;

import org.springframework.stereotype.Repository;

import com.somba.api.adapter.mappers.ReviewMapper;
import com.somba.api.core.entities.Review;
import com.somba.api.core.ports.ReviewRepository;
import com.somba.api.infrastructure.persistence.MdbReviewRepository;

@Repository
public class MdbReviewRepositoryAdapter implements ReviewRepository {

  private final MdbReviewRepository mdbReviewRepository;

  private final ReviewMapper reviewMapper;

  public MdbReviewRepositoryAdapter(MdbReviewRepository mdbReviewRepository, ReviewMapper reviewMapper) {
    this.mdbReviewRepository = mdbReviewRepository;
    this.reviewMapper = reviewMapper;
  }

  @Override
  public Review save(Review review) {
    return this.reviewMapper.toDomain(
      this.mdbReviewRepository.save(
        this.reviewMapper.toEntity(review)
      )
    );
  }

  @Override
  public double averageRating(String productId) {
    Double averageRating = this.mdbReviewRepository.averageRating(productId);
    return averageRating != null ? averageRating : 0;
  }
  
}
