package com.somba.api.infrastructure.persistence;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;

import com.somba.api.infrastructure.persistence.entities.ProductEntity;

public interface MdbProductRepository extends MongoRepository<ProductEntity, String> {
  Page<ProductEntity> findByCategory(String category, Pageable pageable);
}
