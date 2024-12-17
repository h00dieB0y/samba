package com.somba.api.adapters.repositories;

import java.util.List;
import org.springframework.data.domain.PageRequest;

import com.somba.api.adapters.mappers.ProductMapper;
import com.somba.api.core.entities.Product;
import com.somba.api.core.ports.ProductRepository;
import com.somba.api.infrastructure.persistence.MdbProductRepository;

import org.springframework.stereotype.Component;

@Component
public class MdbProductRepositoryAdapter implements ProductRepository {

  private final MdbProductRepository mdbProductRepository;

  private final ProductMapper productMapper;

  public MdbProductRepositoryAdapter(MdbProductRepository mdbProductRepository, ProductMapper productMapper) {
    this.mdbProductRepository = mdbProductRepository;
    this.productMapper = productMapper;
  }

  @Override
  public List<Product> getProducts(int page, int size) {
    return this.mdbProductRepository
      .findAll(PageRequest.of(page, size))
      .map(productMapper::toDomain)
      .toList();
  }
}
