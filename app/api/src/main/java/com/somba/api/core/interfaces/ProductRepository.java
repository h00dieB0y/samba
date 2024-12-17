package com.somba.api.core.interfaces;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.somba.api.core.entities.Product;

@Repository
public interface ProductRepository {

  List<Product> getProducts(int page, int size);
}
