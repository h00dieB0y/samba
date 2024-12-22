package com.somba.api.e2e;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertAll;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.testcontainers.containers.MongoDBContainer;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.somba.api.adapter.presenters.ErrorDetails;
import com.somba.api.adapter.presenters.ProductView;
import com.somba.api.adapter.presenters.Response;
import com.somba.api.core.entities.Product;
import com.somba.api.core.enums.Category;
import com.somba.api.core.ports.ProductRepository;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT, properties = {
    "spring.profiles.active=test" })
@Testcontainers
class SearchByCategoryE2ETest {

  @Container
  static final PostgreSQLContainer<?> postgreSQLContainer = new PostgreSQLContainer<>("postgres:latest");

  @Container
  static final MongoDBContainer mongoDBContainer = new MongoDBContainer("mongo:latest");

  @DynamicPropertySource
  static void configureProperties(DynamicPropertyRegistry registry) {
    registry.add("spring.datasource.url", postgreSQLContainer::getJdbcUrl);
    registry.add("spring.data.mongodb.uri", mongoDBContainer::getReplicaSetUrl);

  }

  @LocalServerPort
  private int port;

  @Autowired
  private TestRestTemplate restTemplate;

  @Autowired
  private ProductRepository productRepository;

  @Autowired
  private ObjectMapper objectMapper;

  private String baseUrl;

  @BeforeEach
  public void setUp() {
    baseUrl = "http://localhost:" + port + "/api/v1/products";

    // Clear existing data
    productRepository.deleteAll();

    // Initialize test data
    List<Product> products = new ArrayList<>();
    for (int i = 0; i < 10; i++) {
      for (Category category : Category.values()) {
        products.add(new Product(UUID.randomUUID(), "Product " + i, "Description " + i, "Brand " + i, 100 * i, 10 * i,
            category));
      }
    }
    productRepository.saveAll(products);
  }

  @Test
  void testSearchByCategory() {
    // Given
    String category = "electronics";
    String url = baseUrl + "/search?category=" + category;

    // When
    var response = restTemplate.getForEntity(url, String.class);

    // Then
    assertThat(response.getStatusCode().is2xxSuccessful()).isTrue();

    try {
      Response<List<ProductView>> products = objectMapper.readValue(
          response.getBody(),
          objectMapper.getTypeFactory().constructParametricType(Response.class,
              objectMapper.getTypeFactory().constructCollectionType(List.class, ProductView.class)));
      assertAll("products",
          () -> assertThat(products.status()).isEqualTo(200),
          () -> assertThat(products.message()).isEqualTo("Successfully retrieved the list of products of category: " + category),
          () -> assertThat(products.data()).hasSize(10),
          () -> assertThat(products.path())
              .isEqualTo("/api/v1/products/search?category=" + category + "&page=0&size=10"),
          () -> assertThat(products.timestamp()).isNotNull());
    } catch (Exception e) {
      e.printStackTrace();
      Assertions.fail("Parsing failed", e); // Fail the test if parsing fails
    }
  }

  @Test
  void testSearchByCategoryWithPagination() {
    // Given
    String category = "electronics";
    String url = baseUrl + "/search?category=" + category + "&page=0&size=5";

    // When
    var response = restTemplate.getForEntity(url, String.class);

    // Then
    assertThat(response.getStatusCode().is2xxSuccessful()).isTrue();

    try {
      Response<List<ProductView>> products = objectMapper.readValue(
          response.getBody(),
          objectMapper.getTypeFactory().constructParametricType(Response.class,
              objectMapper.getTypeFactory().constructCollectionType(List.class, ProductView.class)));
      assertAll("products",
          () -> assertThat(products.status()).isEqualTo(200),
          () -> assertThat(products.message()).isEqualTo("Successfully retrieved the list of products of category: " + category),
          () -> assertThat(products.data()).hasSize(5),
          () -> assertThat(products.path())
              .isEqualTo("/api/v1/products/search?category=" + category + "&page=0&size=5"),
          () -> assertThat(products.timestamp()).isNotNull());
    } catch (Exception e) {
      e.printStackTrace();
      Assertions.fail("Parsing failed", e); // Fail the test if parsing fails
    }
  }

  @Test
  void testSearchByCategoryWithInvalidCategory() {
    // Given
    String category = "invalid";
    String url = baseUrl + "/search?category=" + category;

    // When
    var response = restTemplate.getForEntity(url, String.class);

    // Then
    assertThat(response.getStatusCode().is4xxClientError()).isTrue();

    try {
      ErrorDetails errorDetails = objectMapper.readValue(response.getBody(), ErrorDetails.class);

      assertAll("errorDetails",
          () -> assertThat(errorDetails.status()).isEqualTo(400),
          () -> assertThat(errorDetails.message()).isEqualTo("Invalid category provided: '" + category + "'. Valid categories are: " +
                Arrays.stream(Category.values())
                      .map(Enum::name)
                      .collect(Collectors.joining(", "))
          ),
          () -> assertThat(errorDetails.path()).isEqualTo("/api/v1/products/search"),
          () -> assertThat(errorDetails.timestamp()).isNotNull());

    } catch (Exception e) {
      e.printStackTrace();
      Assertions.fail("Parsing failed", e); // Fail the test if parsing fails
    }
  }

  @Test
  void testSearchByCategoryWithInvalidPageParameter() {
    // Given
    String category = "electronics";
    String url = baseUrl + "/search?category=" + category + "&page=-1&size=10";

    // When
    var response = restTemplate.getForEntity(url, String.class);

    // Then
    assertThat(response.getStatusCode().is4xxClientError()).isTrue();

    try {
      ErrorDetails errorDetails = objectMapper.readValue(response.getBody(), ErrorDetails.class);

      assertAll("errorDetails",
          () -> assertThat(errorDetails.status()).isEqualTo(400),
          () -> assertThat(errorDetails.message()).isEqualTo("Validation failed for one or more fields."),
          () -> assertThat(errorDetails.details()).isNotNull().isNotEmpty(),
          () -> assertThat(errorDetails.details()).contains("page: Page number must be greater than or equal to 0"),
          () -> assertThat(errorDetails.path()).isEqualTo("/api/v1/products/search"),
          () -> assertThat(errorDetails.timestamp()).isNotNull());

    } catch (Exception e) {
      e.printStackTrace();
      Assertions.fail("Parsing failed", e); // Fail the test if parsing fails
    }
  }

  @Test
  void testSearchByCategoryWithInvalidSizeParameter() {
    // Given
    String category = "electronics";
    String url = baseUrl + "/search?category=" + category + "&page=1&size=0";

    // When
    var response = restTemplate.getForEntity(url, String.class);

    // Then
    assertThat(response.getStatusCode().is4xxClientError()).isTrue();

    try {
      ErrorDetails errorDetails = objectMapper.readValue(response.getBody(), ErrorDetails.class);

      assertAll("errorDetails",
          () -> assertThat(errorDetails.status()).isEqualTo(400),
          () -> assertThat(errorDetails.message()).isEqualTo("Validation failed for one or more fields."),
          () -> assertThat(errorDetails.details()).isNotNull().isNotEmpty(),
          () -> assertThat(errorDetails.details()).contains("size: Page size must be greater than or equal to 1"),
          () -> assertThat(errorDetails.path()).isEqualTo("/api/v1/products/search"),
          () -> assertThat(errorDetails.timestamp()).isNotNull());

    } catch (Exception e) {
      e.printStackTrace();
      Assertions.fail("Parsing failed", e); // Fail the test if parsing fails
    }
  }

  @Test
  void testSearchByCategoryWithInvalidPageAndSizeParameters() {
    // Given
    String category = "electronics";
    String url = baseUrl + "/search?category=" + category + "&page=-1&size=0";

    // When
    var response = restTemplate.getForEntity(url, String.class);

    // Then
    assertThat(response.getStatusCode().is4xxClientError()).isTrue();

    try {
      ErrorDetails errorDetails = objectMapper.readValue(response.getBody(), ErrorDetails.class);

      assertAll("errorDetails",
          () -> assertThat(errorDetails.status()).isEqualTo(400),
          () -> assertThat(errorDetails.message()).isEqualTo("Validation failed for one or more fields."),
          () -> assertThat(errorDetails.details()).isNotNull().isNotEmpty(),
          () -> assertThat(errorDetails.details()).contains(
              "page: Page number must be greater than or equal to 0",
              "size: Page size must be greater than or equal to 1"
          ),
          () -> assertThat(errorDetails.path()).isEqualTo("/api/v1/products/search"),
          () -> assertThat(errorDetails.timestamp()).isNotNull());

    } catch (Exception e) {
      e.printStackTrace();
      Assertions.fail("Parsing failed", e); // Fail the test if parsing fails
    }
  }  
}
