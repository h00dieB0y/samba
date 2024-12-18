package com.somba.api.adapters.controllers;

import java.util.List;
import java.util.stream.Stream;

import com.somba.api.core.usecases.ListProductsUseCase;
import com.somba.api.adapters.mappers.ProductMapper;
import com.somba.api.adapters.presenters.ProductView;
import com.somba.api.adapters.presenters.Response;

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
  public Response<List<ProductView>> listProducts(
      @RequestParam(defaultValue = "0") int page,
      @RequestParam(defaultValue = "10") int size) {
    return new Response<>(
      200,
      "Successfully retrieved the list of products",
      listProductsUseCase.execute(page, size).parallelStream().map(productMapper::toProductView).toList(),
      "/api/v1/products",
      java.time.LocalDateTime.now()
    );
  }
}
