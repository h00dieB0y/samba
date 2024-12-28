package com.somba.api.core.usecases;

import java.util.UUID;

import com.somba.api.core.entities.Product;
import com.somba.api.core.entities.Review;
import com.somba.api.core.exceptions.InvalidRatingException;
import com.somba.api.core.exceptions.ResourceNotFoundException;
import com.somba.api.core.ports.ProductRepository;
import com.somba.api.core.ports.ReviewRepository;

public class CreateReviewUseCase {

  private final ReviewRepository reviewRepository;

  private final ProductRepository productRepository;

  public CreateReviewUseCase(ProductRepository productRepository, ReviewRepository reviewRepository) {
    this.productRepository = productRepository;
    this.reviewRepository = reviewRepository;
  }

  public Review execute(String productId, int rating) {
    if (!Review.isValidRating(rating)) {
      throw new InvalidRatingException(rating);
    }

    UUID id;
    try {
      id = UUID.fromString(productId);
    } catch (IllegalArgumentException | NullPointerException e) {
      throw new ResourceNotFoundException(productId, Product.class);
    } 

    Product product = productRepository.getProductById(id)
      .orElseThrow(() -> new ResourceNotFoundException(productId, Product.class));

    Review review = new Review(product.id(), rating);

    reviewRepository.save(review);

    product.addReview(review.id());

    productRepository.save(product);

    return review;
  }
}
