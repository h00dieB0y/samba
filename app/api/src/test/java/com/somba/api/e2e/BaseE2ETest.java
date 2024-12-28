package com.somba.api.e2e;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.somba.api.core.ports.ProductRepository;

import org.junit.jupiter.api.BeforeEach;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.test.web.server.LocalServerPort;

@SpringBootTest(
    webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT,
    properties = {"spring.profiles.active=test"}
)
public abstract class BaseE2ETest {

    @LocalServerPort
    protected int port;

    @Autowired
    protected TestRestTemplate restTemplate;

    @Autowired
    protected ProductRepository productRepository;

    @Autowired
    protected ObjectMapper objectMapper;

    // Base URL for API endpoints
    protected String baseUrl;

    @BeforeEach
    protected void setUpBase() {
        baseUrl = "http://localhost:" + port + "/api/v1/products";
        // Clear existing data before each test
        productRepository.deleteAll();
    }
}
