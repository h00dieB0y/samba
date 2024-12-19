package com.somba.api.adapter.controllers;

import java.util.List;

import com.somba.api.adapter.mappers.ProductMapper;
import com.somba.api.adapter.presenters.ProductView;
import com.somba.api.adapter.presenters.Response;
import com.somba.api.core.usecases.ListProductsUseCase;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.validation.annotation.Validated;

import jakarta.validation.constraints.Min;

@RestController
@RequestMapping("/api/v1/products")
@Validated
public class ProductController {

  private final ListProductsUseCase listProductsUseCase;
  private final ProductMapper productMapper;

  public ProductController(ListProductsUseCase listProductsUseCase, ProductMapper productMapper) {
    this.listProductsUseCase = listProductsUseCase;
    this.productMapper = productMapper;
  }

  @GetMapping(produces = { "application/json" })
  public Response<List<ProductView>> listProducts(
      @RequestParam(defaultValue = "0") @Min(value = 0, message = "Page number must be greater than or equal to 0") int page,
      @RequestParam(defaultValue = "10") @Min(value = 1, message = "Page size must be greater than or equal to 1") int size
  ) {
    return new Response<>(
      200,
      "Successfully retrieved the list of products",
      listProductsUseCase.execute(page, size).parallelStream().map(productMapper::toProductView).toList(),
      "/api/v1/products",
      java.time.LocalDateTime.now()
    );
  }
}
