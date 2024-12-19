package com.somba.api.infrastructure.config;

import org.springframework.context.annotation.Configuration;

import java.util.UUID;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;

import com.somba.api.infrastructure.persistence.MdbProductRepository;
import com.somba.api.infrastructure.persistence.entities.ProductEntity;

@Configuration
public class DataLoader {


  @Bean
  public CommandLineRunner initDatabase(MdbProductRepository repository) {
    return args -> {
      repository.deleteAll();
      for (int i = 0; i < 10; i++) {
        ProductEntity product = new ProductEntity();
        product.setId(UUID.randomUUID().toString());
        product.setName("Product " + i);
        product.setDescription("Description " + i);
        product.setBrand("Brand " + i);
        // Price of the product in cents
        product.setPrice(1000 + i);
        product.setStock(10 + i);
        repository.save(product);
      }
    };
  }
}
