package com.somba.api.core.exceptions;

public class InvalidRatingException extends RuntimeException {
  public InvalidRatingException(int rating) {
    super(
        String.format(
            "Invalid rating: %d. Rating must be between 1 and 5", rating));

  }

}
