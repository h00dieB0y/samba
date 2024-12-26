package com.somba.api.adapter.controllers;

import java.util.List;

import com.somba.api.adapter.mappers.ProductMapper;
import com.somba.api.adapter.presenters.ProductView;
import com.somba.api.adapter.presenters.Response;
import com.somba.api.core.usecases.ListProductsUseCase;
import com.somba.api.core.usecases.ProductSearchUseCase;
import com.somba.api.core.usecases.ListProductsByCategoryUsecase;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.validation.annotation.Validated;

import jakarta.validation.constraints.Min;

@RestController
@RequestMapping("/products")
@Validated
public class ProductController {

  private final ListProductsUseCase listProductsUseCase;
  private final ListProductsByCategoryUsecase searchProductsByCategoryUsecase;
  private final ProductSearchUseCase searchProductsUseCase;
  private final ProductMapper productMapper;

  public ProductController(ListProductsUseCase listProductsUseCase,
      ListProductsByCategoryUsecase searchProductsByCategoryUsecase,
      ProductSearchUseCase searchProductsUseCase, ProductMapper productMapper) {
    this.listProductsUseCase = listProductsUseCase;
    this.searchProductsByCategoryUsecase = searchProductsByCategoryUsecase;
    this.productMapper = productMapper;
    this.searchProductsUseCase = searchProductsUseCase;
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

  @GetMapping(
    path = "/categories/{category}",
    produces = { "application/json" }
  )
  public Response<List<ProductView>> listProductsByCategory(
      @PathVariable String category,
      @RequestParam(defaultValue = "0") @Min(value = 0, message = "Page number must be greater than or equal to 0") int page,
      @RequestParam(defaultValue = "10") @Min(value = 1, message = "Page size must be greater than or equal to 1") int size,
      WebRequest request
  ){
    return new Response<>(
      200,
      "Successfully retrieved the list of products of category: " + category,
      searchProductsByCategoryUsecase.execute(category, page, size).parallelStream().map(productMapper::toProductView).toList(),
      request.getDescription(false).replace("uri=", "") + "?page=" + page + "&size=" + size,
      java.time.LocalDateTime.now()
    );
  }

  // Search products by keyword
  @GetMapping(
    path = "/search",
    produces = { "application/json" }
  )
  public Response<List<ProductView>> searchProducts(@RequestParam("q") String keyword) {
    return new Response<>(
      200,
      "Successfully retrieved the list of products matching the keyword: " + keyword,
      searchProductsUseCase.execute(keyword).parallelStream().map(productMapper::toProductView).toList(),
      "/api/v1/products/search?q=" + keyword,
      java.time.LocalDateTime.now()
    );
  }

}
