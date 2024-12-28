package com.somba.api.e2e;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertAll;
import org.junit.jupiter.api.Assertions;


import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.data.elasticsearch.core.ElasticsearchOperations;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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
import com.somba.api.infrastructure.search.ProductDocument;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT, properties = {
        "spring.profiles.active=test" })
@Testcontainers
class SearchProductsE2ETest {

    // Constants for Testcontainers
    private static final String POSTGRES_IMAGE = "postgres:latest";
    private static final String MONGO_IMAGE = "mongo:latest";
    private static final String ELASTICSEARCH_DOCKER_IMAGE = "docker.elastic.co/elasticsearch/elasticsearch:8.17.0";
    private static final String BASE_API_PATH = "/api/v1/products/search";

    @Container
    static final PostgreSQLContainer<?> postgreSQLContainer = new PostgreSQLContainer<>(POSTGRES_IMAGE);

    @Container
    static final MongoDBContainer mongoDBContainer = new MongoDBContainer(MONGO_IMAGE);

    @Container
    public static ElasticsearchContainer elasticsearchContainer = new ElasticsearchContainer(
            DockerImageName.parse(ELASTICSEARCH_DOCKER_IMAGE))
            .withEnv("discovery.type", "single-node")
                .withEnv("xpack.security.enabled", "false") // Disable security
                .withExposedPorts(9200, 9300) // Ensure ports are exposed
                .waitingFor(org.testcontainers.containers.wait.strategy.Wait.forHttp("/").forStatusCode(200)); // Wait until Elasticsearch is up

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

    @Autowired
    private ElasticsearchOperations elasticsearchOperations;

    private String baseUrl;

    @BeforeEach
    void initialize() {
        baseUrl = "http://localhost:" + port + BASE_API_PATH;

        // Clear existing data
        productRepository.deleteAll();

        // Initialize test data
        Product product1 = new Product("Product 1", "Description 1", "Brand 1", 100, 10, Category.ELECTRONICS);
        Product product2 = new Product("Product 2", "Description 2", "Brand 2", 200, 20, Category.ELECTRONICS);
        productRepository.saveAll(List.of(product1, product2));

        // Ensure Elasticsearch indexes are refreshed
        elasticsearchOperations.indexOps(ProductDocument.class).refresh();
    }

    /**
     * Helper method to build the search URL with the given query parameter.
     *
     * @param keyword the search keyword
     * @return the complete search URL
     */
    private String buildSearchUrl(String keyword) {
        return baseUrl + "?q=" + keyword;
    }

    /**
     * Helper method to parse the response body into a Response object containing a list of ProductSearchView.
     *
     * @param responseBody the JSON response as a string
     * @return the deserialized Response object
     * @throws Exception if parsing fails
     */
    private Response<List<ProductSearchView>> parseResponse(String responseBody) throws Exception {
        return objectMapper.readValue(responseBody,
                objectMapper.getTypeFactory().constructParametricType(Response.class,
                        objectMapper.getTypeFactory().constructCollectionType(List.class, ProductSearchView.class)));
    }

    /**
     * Helper method to perform a GET request with the given keyword.
     *
     * @param keyword the search keyword
     * @return the ResponseEntity containing the response body as a string
     */
    private ResponseEntity<String> performSearch(String keyword) {
        String url = buildSearchUrl(keyword);
        return restTemplate.getForEntity(url, String.class);
    }

    /**
     * Tests related to successful product searches.
     */
    @Nested
    @DisplayName("Given a valid search keyword")
    class GivenAValidSearchKeyword {

        @Nested
        @DisplayName("When searching for products")
        class WhenSearchingForProducts {

            @Test
            @DisplayName("Then it should return all matching products")
            void shouldReturnAllMatchingProducts() {
                // Given
                String keyword = "Product";

                // When
                ResponseEntity<String> response = performSearch(keyword);

                // Then
                assertAll("Verify successful search response",
                        () -> assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK),
                        () -> assertThat(response.getBody()).isNotNull()
                );

                try {
                    Response<List<ProductSearchView>> responseBody = parseResponse(response.getBody());

                    assertAll("Verify response body contents",
                            () -> assertThat(responseBody.status()).isEqualTo(200),
                            () -> assertThat(responseBody.data()).hasSize(2),
                            () -> assertThat(responseBody.data())
                                    .extracting(ProductSearchView::name)
                                    .containsExactlyInAnyOrder("Product 1", "Product 2"),
                            () -> assertThat(responseBody.message())
                                    .isEqualTo("Successfully retrieved the list of products matching the keyword: " + keyword),
                            () -> assertThat(responseBody.path())
                                    .isEqualTo("/api/v1/products/search?q=" + keyword),
                            () -> assertThat(responseBody.timestamp()).isNotNull()
                    );
                } catch (Exception e) {
                    e.printStackTrace();
                    Assertions.fail("Failed to parse response body", e);
                }
            }

            @Test
            @DisplayName("Then it should return a single matching product")
            void shouldReturnSingleMatchingProduct() {
                // Given
                String keyword = "Product 1";

                // When
                ResponseEntity<String> response = performSearch(keyword);

                // Then
                assertAll("Verify successful search response",
                        () -> assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK),
                        () -> assertThat(response.getBody()).isNotNull()
                );

                try {
                    Response<List<ProductSearchView>> responseBody = parseResponse(response.getBody());

                    assertAll("Verify response body contents",
                            () -> assertThat(responseBody.status()).isEqualTo(200),
                            () -> assertThat(responseBody.data()).hasSize(1),
                            () -> assertThat(responseBody.data().get(0).name()).isEqualTo("Product 1"),
                            () -> assertThat(responseBody.message())
                                    .isEqualTo("Successfully retrieved the list of products matching the keyword: " + keyword),
                            () -> assertThat(responseBody.path())
                                    .isEqualTo("/api/v1/products/search?q=" + keyword),
                            () -> assertThat(responseBody.timestamp()).isNotNull()
                    );
                } catch (Exception e) {
                    e.printStackTrace();
                    Assertions.fail("Failed to parse response body", e);
                }
            }

            @Test
            @DisplayName("Then it should return matching products regardless of case sensitivity")
            void shouldReturnMatchingProductsRegardlessOfCase() {
                // Given
                String keyword = "product";

                // When
                ResponseEntity<String> response = performSearch(keyword);

                // Then
                assertAll("Verify successful search response",
                        () -> assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK),
                        () -> assertThat(response.getBody()).isNotNull()
                );

                try {
                    Response<List<ProductSearchView>> responseBody = parseResponse(response.getBody());

                    assertAll("Verify response body contents",
                            () -> assertThat(responseBody.status()).isEqualTo(200),
                            () -> assertThat(responseBody.data()).hasSize(2),
                            () -> assertThat(responseBody.data())
                                    .extracting(ProductSearchView::name)
                                    .containsExactlyInAnyOrder("Product 1", "Product 2"),
                            () -> assertThat(responseBody.message())
                                    .isEqualTo("Successfully retrieved the list of products matching the keyword: " + keyword),
                            () -> assertThat(responseBody.path())
                                    .isEqualTo("/api/v1/products/search?q=" + keyword),
                            () -> assertThat(responseBody.timestamp()).isNotNull()
                    );
                } catch (Exception e) {
                    e.printStackTrace();
                    Assertions.fail("Failed to parse response body", e);
                }
            }
        }
    }

    /**
     * Tests related to invalid search keywords.
     */
    @Nested
    @DisplayName("Given an invalid search keyword")
    class GivenAnInvalidSearchKeyword {

        @Nested
        @DisplayName("When performing a search")
        class WhenPerformingASearch {

            @Test
            @DisplayName("Then it should return Bad Request when 'q' parameter is empty")
            void shouldReturnBadRequestWhenQParameterIsEmpty() {
                // When
                ResponseEntity<String> response = restTemplate.getForEntity(buildSearchUrl(""), String.class);

                // Then
                assertAll("Verify Bad Request response",
                        () -> assertThat(response.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST),
                        () -> assertThat(response.getBody()).isNotNull()
                );

                try {
                    Response<Object> responseBody = objectMapper.readValue(response.getBody(),
                            objectMapper.getTypeFactory().constructParametricType(Response.class, Object.class));

                    assertAll("Verify error response details",
                            () -> assertThat(responseBody.status()).isEqualTo(400),
                            () -> assertThat(responseBody.path()).isEqualTo("/api/v1/products/search"),
                            () -> assertThat(responseBody.timestamp()).isNotNull()
                    );
                } catch (Exception e) {
                    e.printStackTrace();
                    Assertions.fail("Failed to parse error response body", e);
                }
            }

            @Test
            @DisplayName("Then it should return Bad Request when 'q' parameter contains only whitespace")
            void shouldReturnBadRequestWhenQParameterContainsOnlyWhitespace() {
                // When
                ResponseEntity<String> response = restTemplate.getForEntity(buildSearchUrl("   "), String.class);

                // Then
                assertAll("Verify Bad Request response",
                        () -> assertThat(response.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST),
                        () -> assertThat(response.getBody()).isNotNull()
                );

                try {
                    Response<Object> responseBody = objectMapper.readValue(response.getBody(),
                            objectMapper.getTypeFactory().constructParametricType(Response.class, Object.class));

                    assertAll("Verify error response details",
                            () -> assertThat(responseBody.status()).isEqualTo(400),
                            () -> assertThat(responseBody.path()).isEqualTo("/api/v1/products/search"),
                            () -> assertThat(responseBody.timestamp()).isNotNull()
                    );
                } catch (Exception e) {
                    e.printStackTrace();
                    Assertions.fail("Failed to parse error response body", e);
                }
            }

            @Test
            @DisplayName("Then it should return Bad Request when keyword is too short")
            void shouldReturnBadRequestWhenKeywordIsTooShort() {
                // Given
                String keyword = "ab";

                // When
                ResponseEntity<String> response = performSearch(keyword);

                // Then
                assertAll("Verify Bad Request response",
                        () -> assertThat(response.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST),
                        () -> assertThat(response.getBody()).isNotNull()
                );

                try {
                    Response<Object> responseBody = objectMapper.readValue(response.getBody(),
                            objectMapper.getTypeFactory().constructParametricType(Response.class, Object.class));

                    assertAll("Verify error response details",
                            () -> assertThat(responseBody.status()).isEqualTo(400),
                            () -> assertThat(responseBody.path()).isEqualTo("/api/v1/products/search"),
                            () -> assertThat(responseBody.timestamp()).isNotNull()
                    );
                } catch (Exception e) {
                    e.printStackTrace();
                    Assertions.fail("Failed to parse error response body", e);
                }
            }
        }
    }

    /**
     * Tests related to searches yielding no results.
     */
    @Nested
    @DisplayName("Given a search keyword with no matching products")
    class GivenASearchKeywordWithNoMatchingProducts {

        @Nested
        @DisplayName("When performing a search")
        class WhenPerformingASearch {

            @Test
            @DisplayName("Then it should return an empty list")
            void shouldReturnEmptyList() {
                // Given
                String keyword = "Non-existent product";

                // When
                ResponseEntity<String> response = performSearch(keyword);

                // Then
                assertAll("Verify successful search response",
                        () -> assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK),
                        () -> assertThat(response.getBody()).isNotNull()
                );

                try {
                    Response<List<ProductSearchView>> responseBody = parseResponse(response.getBody());

                    assertAll("Verify response body contents",
                            () -> assertThat(responseBody.status()).isEqualTo(200),
                            () -> assertThat(responseBody.data()).isEmpty(),
                            () -> assertThat(responseBody.message())
                                    .isEqualTo("No products found matching the keyword: " + keyword),
                            () -> assertThat(responseBody.path())
                                    .isEqualTo("/api/v1/products/search?q=" + keyword),
                            () -> assertThat(responseBody.timestamp()).isNotNull()
                    );
                } catch (Exception e) {
                    e.printStackTrace();
                    Assertions.fail("Failed to parse response body", e);
                }
            }
        }
    }
}
