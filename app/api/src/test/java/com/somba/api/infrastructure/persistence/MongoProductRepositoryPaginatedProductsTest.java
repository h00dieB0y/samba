package com.somba.api.infrastructure.persistence;

import org.springframework.boot.test.autoconfigure.data.mongo.DataMongoTest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import static org.assertj.core.api.Assertions.assertThat;

import com.somba.api.infrastructure.persistence.entities.ProductEntity;

import java.util.stream.IntStream;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

@DataMongoTest
class MongoProductRepositoryPaginatedProductsTest {

  @Autowired
  private MdbProductRepository mdbProductRepository;

  @BeforeEach
  void setUp() {
    mdbProductRepository.deleteAll();
    preloadTestData(10);
  }

  private void preloadTestData(int count) {
    IntStream.range(0, count).forEach(i -> {
      ProductEntity productEntity = new ProductEntity()
          .setName("Product " + i)
          .setDescription("Description " + i)
          .setBrand("Brand " + i)
          .setPrice(i * 100)
          .setStock(i * 10);
      mdbProductRepository.save(productEntity);
    });
  }

  @Test
  void shouldReturnPaginatedProducts() {
    Page<ProductEntity> productEntities = mdbProductRepository.findAll(PageRequest.of(0, 5));

    assertThat(productEntities).isNotNull();
    assertThat(productEntities.getContent()).hasSize(5);
    assertThat(productEntities.getContent().get(0).getName()).isEqualTo("Product 0");
  }

  @Test
  void shouldReturnSecondPageOfProducts() {
    Page<ProductEntity> productEntities = mdbProductRepository.findAll(PageRequest.of(1, 5));

    assertThat(productEntities).isNotNull();
    assertThat(productEntities.getContent()).hasSize(5);
    assertThat(productEntities.getContent().get(0).getName()).isEqualTo("Product 5");
  }

  @Test
  void shouldReturnEmptyPageWhenPageIsOutOfBounds() {
    Page<ProductEntity> productEntities = mdbProductRepository.findAll(PageRequest.of(2, 5));

    assertThat(productEntities).isNotNull();
    assertThat(productEntities.getContent()).isEmpty();
  }

  @Test
  void shouldReturnEmptyPageWhenNoProducts() {
    mdbProductRepository.deleteAll();

    Page<ProductEntity> productEntities = mdbProductRepository.findAll(PageRequest.of(0, 5));

    assertThat(productEntities).isNotNull();
    assertThat(productEntities.getContent()).isEmpty();
  }

  @Test
  void shouldReturnProductsOnLastPage() {
    Page<ProductEntity> productEntities = mdbProductRepository.findAll(PageRequest.of(1, 7));

    assertThat(productEntities).isNotNull();
    assertThat(productEntities.getContent()).hasSize(3); // Remaining 3 products
    assertThat(productEntities.getContent().get(0).getName()).isEqualTo("Product 7");
  }

  @Test
  void shouldThrowExceptionForInvalidPageSize() {
    org.junit.jupiter.api.Assertions.assertThrows(
        IllegalArgumentException.class,
        this::findProductsWithInvalidPageSize);

  }

  private void findProductsWithInvalidPageSize() {
    mdbProductRepository.findAll(PageRequest.of(0, 0));
  }

}
