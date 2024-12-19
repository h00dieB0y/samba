package com.somba.api.adapter.controllers;

import com.somba.api.adapter.mappers.ProductMapper;
import com.somba.api.core.entities.Product;
import com.somba.api.core.usecases.ListProductsUseCase;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;


import java.util.List;
import java.util.UUID;

import static org.hamcrest.Matchers.*;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;


/**
 * Integration tests for ProductController.
 */
@WebMvcTest({ProductController.class, ProductMapper.class})
class ProductControllerIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private ListProductsUseCase listProductsUseCase;

    @BeforeEach
    public void setUp() {
        // Setup mock data
        Product product1 = new Product(UUID.randomUUID(), "Product 1", "Description 1", "Brand 1", 100, 10);
        Product product2 = new Product(UUID.randomUUID(), "Product 2", "Description 2", "Brand 2", 200, 20);

        // Mock the ListProductsUseCase
        when(listProductsUseCase.execute(anyInt(), anyInt())).thenReturn(List.of(product1, product2));
    }
    
    @Test
    void testListProductsDefaultPagination() throws Exception {
        mockMvc.perform(get("/api/v1/products")
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value(200))
                .andExpect(jsonPath("$.message").value("Successfully retrieved the list of products"))
                .andExpect(jsonPath("$.data", hasSize(2)))
                .andExpect(jsonPath("$.path").value("/api/v1/products"))
                .andExpect(jsonPath("$.timestamp").exists());
    }
    
    @Test
    void testListProductsWithPagination() throws Exception {
        mockMvc.perform(get("/api/v1/products")
                .param("page", "1")
                .param("size", "5")
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value(200))
                .andExpect(jsonPath("$.message").value("Successfully retrieved the list of products"))
                .andExpect(jsonPath("$.data", hasSize(2))) // Adjust size based on mocked data
                .andExpect(jsonPath("$.path").value("/api/v1/products"))
                .andExpect(jsonPath("$.timestamp").exists());
    }

    @Test
    void testListProductsInvalidPageParameters() throws Exception {
        mockMvc.perform(get("/api/v1/products")
                .param("page", "-1")
                .param("size", "-10")
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.status").value(400))
                .andExpect(jsonPath("$.message").exists())
                .andExpect(jsonPath("$.data").doesNotExist())
                .andExpect(jsonPath("$.path").value("/api/v1/products"))
                .andExpect(jsonPath("$.timestamp").exists());
    }

    @Test
    void testListProductsEmptyResult() throws Exception {
        // Mock empty list
        when(listProductsUseCase.execute(anyInt(), anyInt())).thenReturn(List.of());

        mockMvc.perform(get("/api/v1/products")
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value(200))
                .andExpect(jsonPath("$.message").value("Successfully retrieved the list of products"))
                .andExpect(jsonPath("$.data", hasSize(0)))
                .andExpect(jsonPath("$.path").value("/api/v1/products"))
                .andExpect(jsonPath("$.timestamp").exists());
    }
}