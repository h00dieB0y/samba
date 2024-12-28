package com.somba.api.core.ports;

import com.somba.api.core.entities.Review;

public interface ReviewRepository {
  Review save(Review review);
}
