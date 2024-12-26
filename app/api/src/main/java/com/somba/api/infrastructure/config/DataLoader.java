package com.somba.api.infrastructure.config;

import org.springframework.context.annotation.Configuration;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;

import com.somba.api.core.entities.Product;
import com.somba.api.core.enums.Category;
import com.somba.api.core.ports.ProductRepository;
import com.somba.api.infrastructure.persistence.MdbProductRepository;
import com.somba.api.infrastructure.persistence.entities.ProductEntity;

@Configuration
public class DataLoader {


  @Bean
  public CommandLineRunner initDatabase(ProductRepository repository) {
    return args -> {
      repository.deleteAll();
      List<Product> products = new ArrayList<>();
      for (int i = 0; i < 10; i++) {
        for (Category category : Category.values()) {
          products.add(
            new Product(
              UUID.randomUUID(),
              "Product " + i,
              "Description " + i,
              "Brand " + i,
              100 * i,
              10 * i,
              category
            )
          );
        }
      }
      repository.saveAll(products);
    };
  }
}
