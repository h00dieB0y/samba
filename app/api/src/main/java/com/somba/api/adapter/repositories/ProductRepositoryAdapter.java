package com.somba.api.adapter.repositories;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.domain.PageRequest;

import com.somba.api.adapter.mappers.ProductMapper;
import com.somba.api.core.entities.Product;
import com.somba.api.core.enums.Category;
import com.somba.api.core.ports.ProductRepository;
import com.somba.api.core.ports.ProductSearchRepository;
import com.somba.api.infrastructure.persistence.MdbProductRepository;
import com.somba.api.infrastructure.search.ElasticsearchProductSearchRepository;

import org.springframework.stereotype.Repository;

@Repository
public class ProductRepositoryAdapter implements ProductRepository, ProductSearchRepository {

  private final MdbProductRepository mdbProductRepository;

  private final ElasticsearchProductSearchRepository elasticsearchProductSearchRepository;

  private final ProductMapper productMapper;

  public ProductRepositoryAdapter(MdbProductRepository mdbProductRepository, ElasticsearchProductSearchRepository elasticsearchProductSearchRepository, ProductMapper productMapper) {
    this.mdbProductRepository = mdbProductRepository;
    this.elasticsearchProductSearchRepository = elasticsearchProductSearchRepository;
    this.productMapper = productMapper;
  }

  @Override
  public Optional<Product> getProductById(UUID id) {
    return this.mdbProductRepository
      .findById(id.toString())
      .map(productMapper::toDomain);
  }

  @Override
  public Product save(Product product) {
    Product savedProduct = this.productMapper.toDomain(
      this.mdbProductRepository.save(
        this.productMapper.toEntity(product)
      )
    );
    
    this.index(savedProduct);
    
    return savedProduct;
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

    products.forEach(this::index);
  }

  @Override
  public void deleteAll() {
    this.mdbProductRepository.deleteAll();
    this.elasticsearchProductSearchRepository.deleteAll();
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
    this.elasticsearchProductSearchRepository.save(productMapper.toDocument(product));
  }

  @Override
  public List<Product> search(String query) {
    // Here we assume that all prerequisites are met for the query
    return this.elasticsearchProductSearchRepository
      .findByNameOrDescriptionOrBrand(query, query, query)
      .stream()
      .map(productMapper::toDomain)
      .toList();
  }
}
