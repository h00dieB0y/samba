package com.somba.api.e2e;

import static org.assertj.core.api.Assertions.assertThat;
import org.junit.jupiter.api.Assertions;
import org.springframework.http.*;

import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.data.elasticsearch.core.ElasticsearchOperations;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.testcontainers.containers.MongoDBContainer;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.elasticsearch.ElasticsearchContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;
import org.testcontainers.utility.DockerImageName;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.somba.api.adapter.presenters.ProductSearchView;
import com.somba.api.adapter.presenters.Response;
import com.somba.api.core.entities.Product;
import com.somba.api.core.enums.Category;
import com.somba.api.core.ports.ProductRepository;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT, properties = {
    "spring.profiles.active=test" })
@Testcontainers
public class SearchProductsE2ETest {
  @Container
  static final PostgreSQLContainer<?> postgreSQLContainer = new PostgreSQLContainer<>("postgres:latest");

  @Container
  static final MongoDBContainer mongoDBContainer = new MongoDBContainer("mongo:latest");

  @Autowired
  private ElasticsearchOperations elasticsearchOperations;

  private static final String ELASTICSEARCH_DOCKER_IMAGE = "docker.elastic.co/elasticsearch/elasticsearch:8.16.2";

  @Container
  public static ElasticsearchContainer elasticsearchContainer = new ElasticsearchContainer(
      DockerImageName.parse(ELASTICSEARCH_DOCKER_IMAGE))
      .withEnv("discovery.type", "single-node")
      .withEnv("xpack.security.enabled", "false") // Disable security
      .withExposedPorts(9200, 9300) // Ensure ports are exposed
      .waitingFor(org.testcontainers.containers.wait.strategy.Wait.forHttp("/").forStatusCode(200)); // Wait until
                                                                                                     // Elasticsearch is
                                                                                                     // up

  @DynamicPropertySource
  static void configureProperties(DynamicPropertyRegistry registry) {
    registry.add("spring.datasource.url", postgreSQLContainer::getJdbcUrl);
    registry.add("spring.data.mongodb.uri", mongoDBContainer::getReplicaSetUrl);
    registry.add("spring.elasticsearch.uris", elasticsearchContainer::getHttpHostAddress);

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
  void setUp() {
    baseUrl = "http://localhost:" + port + "/api/v1/products/search";

    // Clear existing data
    productRepository.deleteAll();

    // Initialize test data
    Product product1 = new Product("Product 1", "Description 1", "Brand 1", 100, 10, Category.ELECTRONICS);
    Product product2 = new Product("Product 2", "Description 2", "Brand 2", 200, 20, Category.ELECTRONICS);
    productRepository.saveAll(List.of(product1, product2));
  }

  @Test
  void searchProducts_WithValidKeyword_ReturnsMatchingProducts() {
    // Given
    String keyword = "Product";

    // When
    ResponseEntity<String> response = restTemplate.getForEntity(baseUrl + "?q=" + keyword, String.class);

    // Then
    assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);

    try {
      Response<List<ProductSearchView>> responseBody = objectMapper.readValue(response.getBody(),
          objectMapper.getTypeFactory().constructParametricType(Response.class,
              objectMapper.getTypeFactory().constructCollectionType(List.class, ProductSearchView.class)));
      
      assertThat(responseBody.status()).isEqualTo(200);
      assertThat(responseBody.data()).hasSize(2);
      assertThat(responseBody.data().get(0).name()).isEqualTo("Product 1");
      assertThat(responseBody.data().get(1).name()).isEqualTo("Product 2");
      assertThat(responseBody.message()).isEqualTo("Successfully retrieved the list of products matching the keyword: " + keyword);
      assertThat(responseBody.path()).isEqualTo("/api/v1/products/search?q=" + keyword);
      assertThat(responseBody.timestamp()).isNotNull();
    } catch (Exception e) {
      e.printStackTrace();
      Assertions.fail("Failed to parse response body", e);
    }
  }

  @Test
  void searchProducts_WithSingleMatch_ReturnsSingleProduct() {
    // Given
    String keyword = "Product 1";

    // When
    ResponseEntity<String> response = restTemplate.getForEntity(baseUrl + "?q=" + keyword, String.class);

    // Then
    assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);

    try {
      Response<List<ProductSearchView>> responseBody = objectMapper.readValue(response.getBody(),
          objectMapper.getTypeFactory().constructParametricType(Response.class,
              objectMapper.getTypeFactory().constructCollectionType(List.class, ProductSearchView.class)));
      
      assertThat(responseBody.status()).isEqualTo(200);
      assertThat(responseBody.data()).hasSize(1);
      assertThat(responseBody.data().get(0).name()).isEqualTo("Product 1");
      assertThat(responseBody.message()).isEqualTo("Successfully retrieved the list of products matching the keyword: " + keyword);
      assertThat(responseBody.path()).isEqualTo("/api/v1/products/search?q=" + keyword);
      assertThat(responseBody.timestamp()).isNotNull();
    } catch (Exception e) {
      e.printStackTrace();
      Assertions.fail("Failed to parse response body", e);
    }
  }

  @Test
  void searchProducts_WithDifferentCaseKeyword_ReturnsMatchingProducts() throws Exception {
    // Given
    String keyword = "product";

    // When
    ResponseEntity<String> response = restTemplate.getForEntity(baseUrl + "?q=" + keyword, String.class);

    // Then
    assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);

    Response<List<ProductSearchView>> responseBody = objectMapper.readValue(response.getBody(),
        objectMapper.getTypeFactory().constructParametricType(Response.class,
            objectMapper.getTypeFactory().constructCollectionType(List.class, ProductSearchView.class)));

    assertThat(responseBody.status()).isEqualTo(200);
    assertThat(responseBody.data()).hasSize(2);
    assertThat(responseBody.data().get(0).name()).isEqualTo("Product 1");
    assertThat(responseBody.data().get(1).name()).isEqualTo("Product 2");
    assertThat(responseBody.message()).isEqualTo("Successfully retrieved the list of products matching the keyword: " + keyword);
    assertThat(responseBody.path()).isEqualTo("/api/v1/products/search?q=" + keyword);
    assertThat(responseBody.timestamp()).isNotNull();
  }

  @Test
  void searchProducts_MissingQParameter_ReturnsBadRequest() {
    // When
    ResponseEntity<String> response = restTemplate.getForEntity(baseUrl, String.class);

    // Then
    assertThat(response.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
  }

  @Test
  void searchProducts_EmptyQParameter_ReturnsBadRequest() {
    // When
    ResponseEntity<String> response = restTemplate.getForEntity(baseUrl + "?q=", String.class);

    // Then
    assertThat(response.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
  }

  @Test
  void searchProducts_QParameterWithOnlyWhitespace_ReturnsBadRequest() {
    // When
    ResponseEntity<String> response = restTemplate.getForEntity(baseUrl + "?q= ", String.class);

    // Then
    assertThat(response.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
  }

  @Test
  void searchProducts_WithNonExistentKeyword_ReturnsEmptyList() {
    // Given
    String keyword = "Non-existent product";

    // When
    ResponseEntity<String> response = restTemplate.getForEntity(baseUrl + "?q=" + keyword, String.class);

    // Then
    assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);

    try {
      Response<List<ProductSearchView>> responseBody = objectMapper.readValue(response.getBody(),
          objectMapper.getTypeFactory().constructParametricType(Response.class,
              objectMapper.getTypeFactory().constructCollectionType(List.class, ProductSearchView.class)));
      
      assertThat(responseBody.status()).isEqualTo(200);
      assertThat(responseBody.data()).isEmpty();
      assertThat(responseBody.message()).isEqualTo("No products found matching the keyword: " + keyword);
      assertThat(responseBody.path()).isEqualTo("/api/v1/products/search?q=" + keyword);
      assertThat(responseBody.timestamp()).isNotNull();
    } catch (Exception e) {
      e.printStackTrace();
      Assertions.fail("Failed to parse response body", e);
    }
  }

}
