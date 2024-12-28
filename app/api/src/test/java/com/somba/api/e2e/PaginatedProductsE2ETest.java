package com.somba.api.e2e;

import com.somba.api.adapter.presenters.ErrorDetails;
import com.somba.api.adapter.presenters.ProductView;
import com.somba.api.adapter.presenters.Response;
import com.somba.api.core.entities.Product;
import com.somba.api.core.enums.Category;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.*;

import java.util.List;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import org.junit.jupiter.api.Assertions;

@SpringBootTest(
    webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT,
    properties = {"spring.profiles.active=test"}
)
class PaginatedProductsE2ETest extends BaseE2ETest {

    @BeforeEach
    public void setUp() {
        super.setUpBase();
        baseUrl = "http://localhost:" + port + "/api/v1/products";

        // Initialize test data
        Product product1 = new Product(UUID.randomUUID(), "Product 1", "Description 1", "Brand 1", 100, 10, Category.ELECTRONICS);
        Product product2 = new Product(UUID.randomUUID(), "Product 2", "Description 2", "Brand 2", 200, 20, Category.ELECTRONICS);
        productRepository.saveAll(List.of(product1, product2));
    }

    @Test
    void testListProductsDefaultPagination() {
        // Act
        ResponseEntity<String> response = restTemplate.getForEntity(baseUrl, String.class);

        // Assert
        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);

        try {
            // Parse JSON response
            Response<List<ProductView>> responseBody = objectMapper.readValue(response.getBody(),
                    objectMapper.getTypeFactory().constructParametricType(Response.class,
                            objectMapper.getTypeFactory().constructCollectionType(List.class, ProductView.class)));

            assertThat(responseBody.status()).isEqualTo(200);
            assertThat(responseBody.message()).isEqualTo("Successfully retrieved the list of products");
            assertThat(responseBody.data()).hasSize(2);
            assertThat(responseBody.path()).isEqualTo("/api/v1/products");
            assertThat(responseBody.timestamp()).isNotNull();

            // Further assertions on ProductView objects
            ProductView view1 = responseBody.data().get(0);
            assertThat(view1.id()).isNotNull();
            assertThat(view1.name()).isEqualTo("Product 1");
            assertThat(view1.brand()).isEqualTo("Brand 1");
            assertThat(view1.price()).isEqualTo(100);

        } catch (Exception e) {
            e.printStackTrace();
            Assertions.fail("Parsing failed", e); // Fail the test if parsing fails
        }
    }

    @Test
    void testListProductsWithPagination() {
        // Arrange
        int page = 0;
        int size = 2;

        // Act
        String urlWithParams = baseUrl + "?page=" + page + "&size=" + size;
        ResponseEntity<String> response = restTemplate.getForEntity(urlWithParams, String.class);

        // Assert
        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);

        try {
            // Parse JSON response
            Response<List<ProductView>> responseBody = objectMapper.readValue(response.getBody(),
                    objectMapper.getTypeFactory().constructParametricType(Response.class,
                            objectMapper.getTypeFactory().constructCollectionType(List.class, ProductView.class)));

            assertThat(responseBody.status()).isEqualTo(200);
            assertThat(responseBody.message()).isEqualTo("Successfully retrieved the list of products");
            assertThat(responseBody.data()).hasSize(2);
            assertThat(responseBody.path()).isEqualTo("/api/v1/products");
            assertThat(responseBody.timestamp()).isNotNull();

            // Further assertions on ProductView objects
            ProductView view1 = responseBody.data().get(0);
            assertThat(view1.name()).isEqualTo("Product 1");
            // Add more assertions as needed

        } catch (Exception e) {
            e.printStackTrace();
            Assertions.fail("Parsing failed", e); // Fail the test if parsing fails
        }
    }

    @Test
    void testListProductsInvalidPageParameter() {
        // Arrange
        String urlWithInvalidPage = baseUrl + "?page=-1&size=10";

        // Act
        ResponseEntity<String> response = restTemplate.getForEntity(urlWithInvalidPage, String.class);

        // Assert
        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);

        try {
            // Parse JSON response
            ErrorDetails errorDetails = objectMapper.readValue(response.getBody(), ErrorDetails.class);

            assertThat(errorDetails.status()).isEqualTo(400);
            assertThat(errorDetails.message()).isEqualTo("Validation failed for one or more fields.");
            assertThat(errorDetails.details()).isNotNull().isNotEmpty();
            assertThat(errorDetails.path()).isEqualTo("/api/v1/products");
            assertThat(errorDetails.timestamp()).isNotNull();

            // Verify specific validation messages
            assertThat(errorDetails.details())
                    .contains("page: Page number must be greater than or equal to 0");
        } catch (Exception e) {
            e.printStackTrace();
            Assertions.fail("Parsing failed", e);
        }
    }

    @Test
    void testListProductsInvalidSizeParameter() {
        // Arrange
        String urlWithInvalidSize = baseUrl + "?page=1&size=0";

        // Act
        ResponseEntity<String> response = restTemplate.getForEntity(urlWithInvalidSize, String.class);

        // Assert
        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);

        try {
            // Parse JSON response
            ErrorDetails errorDetails = objectMapper.readValue(response.getBody(), ErrorDetails.class);

            assertThat(errorDetails.status()).isEqualTo(400);
            assertThat(errorDetails.message()).isEqualTo("Validation failed for one or more fields.");
            assertThat(errorDetails.details()).isNotNull().isNotEmpty();
            assertThat(errorDetails.path()).isEqualTo("/api/v1/products");
            assertThat(errorDetails.timestamp()).isNotNull();

            // Verify specific validation messages
            assertThat(errorDetails.details())
                    .contains("size: Page size must be greater than or equal to 1");
        } catch (Exception e) {
            e.printStackTrace();
            Assertions.fail("Parsing failed", e);
        }
    }

    @Test
    void testListProductsWithNoData() {
        // Arrange
        productRepository.deleteAll();

        // Act
        ResponseEntity<String> response = restTemplate.getForEntity(baseUrl, String.class);

        // Assert
        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);

        try {
            // Parse JSON response
            Response<List<ProductView>> responseBody = objectMapper.readValue(response.getBody(),
                    objectMapper.getTypeFactory().constructParametricType(Response.class,
                            objectMapper.getTypeFactory().constructCollectionType(List.class, ProductView.class)));

            assertThat(responseBody.status()).isEqualTo(200);
            assertThat(responseBody.message()).isEqualTo("Successfully retrieved the list of products");
            assertThat(responseBody.data()).isEmpty();
            assertThat(responseBody.path()).isEqualTo("/api/v1/products");
            assertThat(responseBody.timestamp()).isNotNull();
        } catch (Exception e) {
            e.printStackTrace();
            Assertions.fail("Parsing failed", e); // Fail the test if parsing fails
        }
    }
}
