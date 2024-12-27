package com.somba.api.core.usecases;

import java.util.UUID;

import com.somba.api.core.entities.Product;
import com.somba.api.core.entities.Review;
import com.somba.api.core.exceptions.InvalidRatingException;
import com.somba.api.core.exceptions.ResourceNotFoundException;
import com.somba.api.core.ports.ProductRepository;

public class CreateReviewUseCase {
  private final ProductRepository productRepository;

  public CreateReviewUseCase(ProductRepository productRepository) {
    this.productRepository = productRepository;
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

    Review review = new Review(product, rating);

    product.addReview(review);

    productRepository.save(product);

    return review;
  }
}
