package com.somba.api.core.usecases;

import org.springframework.stereotype.Service;

import com.somba.api.core.entities.Product;
import com.somba.api.core.entities.Review;
import com.somba.api.core.exceptions.InvalidRatingException;
import com.somba.api.core.ports.ProductRepository;
import com.somba.api.core.ports.ReviewRepository;

@Service
public class CreateReviewUseCase {

  private final ReviewRepository reviewRepository;

  private final GetProductByIdUseCase getProductByIdUseCase;

  private final ProductRepository productRepository;
  public CreateReviewUseCase(ReviewRepository reviewRepository, GetProductByIdUseCase getProductByIdUseCase, ProductRepository productRepository) {
    this.reviewRepository = reviewRepository;
    this.getProductByIdUseCase = getProductByIdUseCase;
    this.productRepository = productRepository;
  }

  public Review execute(String productId, int rating) {
    if (!Review.isValidRating(rating)) {
      throw new InvalidRatingException(rating);
    }

    Product product = getProductByIdUseCase.execute(productId);

    Review review = new Review(product.id(), rating);

    reviewRepository.save(review);

    product.addReview(review.id());

    productRepository.save(product);

    return review;
  }
}
