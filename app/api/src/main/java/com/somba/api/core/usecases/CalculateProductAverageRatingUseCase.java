package com.somba.api.core.usecases;

import org.springframework.stereotype.Service;

import com.somba.api.core.ports.ReviewRepository;

@Service
public class CalculateProductAverageRatingUseCase {
  private final ReviewRepository reviewRepository;
  private final GetProductByIdUseCase getProductByIdUseCase;

  public CalculateProductAverageRatingUseCase(ReviewRepository reviewRepository, GetProductByIdUseCase getProductByIdUseCase) {
    this.reviewRepository = reviewRepository;
    this.getProductByIdUseCase = getProductByIdUseCase;
  }

  public double execute(String productId) {
    getProductByIdUseCase.execute(productId);
    return reviewRepository.getAverageRatingByProductId(productId);
  }
}
