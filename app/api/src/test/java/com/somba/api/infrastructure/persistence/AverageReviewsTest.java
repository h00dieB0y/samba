package com.somba.api.infrastructure.persistence;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.data.mongo.DataMongoTest;
import com.somba.api.infrastructure.persistence.entities.ReviewEntity;

@DataMongoTest
class AverageReviewsTest {

  @Autowired
  private MdbReviewRepository mdbReviewRepository;

  @BeforeEach
  void setUp() {
    mdbReviewRepository.deleteAll();
  }

  @Nested
  class GivenReviews {
    @BeforeEach
    void setUp() {
      preloadTestData(10);
    }

    private void preloadTestData(int count) {
      for (int i = 0; i < count; i++) {
        ReviewEntity reviewEntity = new ReviewEntity()
            .setProductId("product-1")
            .setRating(i % 5 + 1);
        mdbReviewRepository.save(reviewEntity);
      }
    }

    @Nested
    class WhenCalculatingAverage {
      @BeforeEach
      void setUp() {
        preloadTestData(10);
      }

      @Test
      void shouldReturnAverageRating() {
        double averageRating = mdbReviewRepository.averageRating("product-1");

        assertThat(averageRating).isEqualTo(3.0);
      }
    }
  }

  @Nested
  class GivenNoReviews {
    @Test
    void shouldReturnZero() {
      Double averageRating = mdbReviewRepository.averageRating("product-1");

      assertThat(averageRating).isNull();
    }
  }
}
