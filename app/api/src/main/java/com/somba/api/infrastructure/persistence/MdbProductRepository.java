package com.somba.api.infrastructure.persistence;

import org.springframework.data.mongodb.repository.MongoRepository;

import com.somba.api.infrastructure.persistence.entities.ProductEntity;

public interface MdbProductRepository extends MongoRepository<ProductEntity, String> {
}