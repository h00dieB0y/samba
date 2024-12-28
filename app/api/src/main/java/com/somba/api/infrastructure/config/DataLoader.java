package com.somba.api.infrastructure.config;

import org.springframework.context.annotation.Configuration;

import java.util.ArrayList;
import java.util.UUID;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;

import com.somba.api.core.enums.Category;
import com.somba.api.infrastructure.persistence.MdbProductRepository;
import com.somba.api.infrastructure.persistence.entities.ProductEntity;

@Configuration
public class DataLoader {


  @Bean
  public CommandLineRunner initDatabase(MdbProductRepository repository) {
    return args -> {
      repository.deleteAll();
      for (int i = 0; i < 10; i++) {
        for (Category category : Category.values()) {
          repository.save(
            new ProductEntity()
              .setId(UUID.randomUUID().toString())
              .setName("Product " + i + " " + category.name())
              .setDescription("Description " + i)
              .setBrand("Brand " + i)
              .setPrice(i * 10)
              .setStock(i * 100)
              .setCategory(category.name())
              .setReviews(new ArrayList<>())
          );
        }
      }
    };
  }
}
