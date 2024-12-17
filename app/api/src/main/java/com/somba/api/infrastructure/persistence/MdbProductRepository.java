package com.somba.api.infrastructure.persistence;

import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.UUID;

import com.somba.api.core.entities.Product;

public interface MdbProductRepository extends MongoRepository<Product, UUID> {
}