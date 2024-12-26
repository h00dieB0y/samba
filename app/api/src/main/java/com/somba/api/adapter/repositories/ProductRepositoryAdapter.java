package com.somba.api.adapter.repositories;

import java.util.List;
import org.springframework.data.domain.PageRequest;

import com.somba.api.adapter.mappers.ProductMapper;
import com.somba.api.core.entities.Product;
import com.somba.api.core.enums.Category;
import com.somba.api.core.ports.ProductRepository;
import com.somba.api.core.ports.ProductSearchRepository;
import com.somba.api.infrastructure.persistence.MdbProductRepository;

import org.springframework.stereotype.Component;

@Component
public class ProductRepositoryAdapter implements ProductRepository, ProductSearchRepository {

  private final MdbProductRepository mdbProductRepository;

  private final ProductMapper productMapper;

  public ProductRepositoryAdapter(MdbProductRepository mdbProductRepository, ProductMapper productMapper) {
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

  @Override
  public void saveAll(List<Product> products) {
    this.mdbProductRepository
      .saveAll(
        products
          .stream()
          .map(productMapper::toEntity)
          .toList()
      );
  }

  @Override
  public void deleteAll() {
    this.mdbProductRepository.deleteAll();
  }

  @Override
  public List<Product> getProductsByCategory(Category category, int page, int size) {
    return this.mdbProductRepository
      .findByCategory(category.name(), PageRequest.of(page, size))
      .map(productMapper::toDomain)
      .toList();
  }

  @Override
  public void index(Product product) {
    // TODO Auto-generated method stub
    throw new UnsupportedOperationException("Unimplemented method 'index'");
  }

  @Override
  public List<Product> search(String query) {
    // TODO Auto-generated method stub
    throw new UnsupportedOperationException("Unimplemented method 'search'");
  }
}