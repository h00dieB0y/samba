package com.somba.api.infrastructure.persistence;

import java.util.List;
import org.springframework.data.domain.PageRequest;
import com.somba.api.core.entities.Product;
import com.somba.api.adapters.repositories.ProductRepository;

public class MdbProductRepositoryImpl implements ProductRepository {

  private final MdbProductRepository mdbProductRepository;

  public MdbProductRepositoryImpl(MdbProductRepository mdbProductRepository) {
    this.mdbProductRepository = mdbProductRepository;
  }

  @Override
  public List<Product> getProducts(int page, int size) {
    return mdbProductRepository.findAll(PageRequest.of(page, size)).toList();
  }
}
