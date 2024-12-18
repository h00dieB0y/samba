package com.somba.api.adapters.controllers;

import java.util.List;
import com.somba.api.core.usecases.ListProductsUseCase;
import com.somba.api.adapters.mappers.ProductMapper;
import com.somba.api.adapters.presenters.ProductView;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;

@RestController
@RequestMapping("/api/v1/products")
public class ProductController {

  private final ListProductsUseCase listProductsUseCase;
  private final ProductMapper productMapper;

  public ProductController(ListProductsUseCase listProductsUseCase, ProductMapper productMapper) {
    this.listProductsUseCase = listProductsUseCase;
    this.productMapper = productMapper;
  }

  @GetMapping(produces = "application/json")
  public List<ProductView> listProducts(
      @RequestParam(defaultValue = "0") int page,
      @RequestParam(defaultValue = "10") int size) {
    return listProductsUseCase.execute(page, size).stream()
        .map(productMapper::toProductView)
        .toList();
  }
}
