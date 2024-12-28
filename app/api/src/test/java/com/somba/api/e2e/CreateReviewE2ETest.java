package com.somba.api.e2e;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertAll;

import java.util.Map;
import java.util.Optional;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;

import com.somba.api.core.entities.Product;
import com.somba.api.core.enums.Category;
import com.somba.api.adapter.presenters.Response;
import com.somba.api.adapter.presenters.ReviewView;
import com.somba.api.adapter.presenters.ErrorDetails;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT, properties = {
    "spring.profiles.active=test" })
class CreateReviewE2ETest extends BaseE2ETest {

  private static final MediaType CONTENT_TYPE_JSON = MediaType.APPLICATION_JSON;
  
  @BeforeEach
  public void setUp() {
    super.setUpBase();
    baseUrl = "http://localhost:" + port + "/api/v1/products";
  }

  /**
   * Helper method to create HTTP headers with JSON content type.
   */
  private HttpHeaders createJsonHeaders() {
    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(CONTENT_TYPE_JSON);
    return headers;
  }

  /**
   * Helper method to create a review request entity.
   *
   * @param rating the rating value
   * @return HttpEntity containing the review data and headers
   */
  private HttpEntity<Map<String, Object>> createReviewRequest(int rating) {
    return new HttpEntity<>(Map.of("rating", rating), createJsonHeaders());
  }

  /**
   * Helper method to parse the response body into a specified class.
   *
   * @param <T>          the type of the response data
   * @param responseBody the JSON response as a string
   * @param clazz        the class to deserialize into
   * @return deserialized object of type T
   * @throws Exception if parsing fails
   */
  private <T> T parseResponse(String responseBody, Class<T> clazz) throws Exception {
    return objectMapper.readValue(responseBody, clazz);
  }

  /**
   * Helper method to parse generic responses with data.
   *
   * @param <T>          the type of the response data
   * @param responseBody the JSON response as a string
   * @param dataClass    the class of the data field
   * @return deserialized Response object
   * @throws Exception if parsing fails
   */
  private <T> Response<T> parseGenericResponse(String responseBody, Class<T> dataClass) throws Exception {
    return objectMapper.readValue(responseBody,
        objectMapper.getTypeFactory().constructParametricType(Response.class, dataClass));
  }

  @Nested
  class GivenAValidProductId {

    private Product product;

    @BeforeEach
    void setUpValidProduct() {
      product = new Product(
          "Product 1",
          "Description 1",
          "Brand 1",
          100,
          10,
          Category.ELECTRONICS);
      productRepository.save(product);
    }

    @Nested
    class WhenCreatingAReview {

      @Nested
      class WithValidRating {

        private ResponseEntity<String> response;

        @BeforeEach
        void createValidReview() {
          HttpEntity<Map<String, Object>> request = createReviewRequest(5);
          response = restTemplate.postForEntity(
              baseUrl + "/" + product.id() + "/reviews",
              request,
              String.class);
        }

        @Test
        void shouldReturnSuccessfulResponse() {
          assertAll("Verify successful response",
              () -> assertThat(response.getStatusCode().is2xxSuccessful()).isTrue(),
              () -> assertThat(response.getBody()).isNotNull());
        }

        @Test
        void shouldReturnReviewDetails() {
          try {
            Response<ReviewView> responseBody = parseGenericResponse(response.getBody(), ReviewView.class);

            assertAll("Verify response body",
                () -> assertThat(responseBody.status()).isEqualTo(201),
                () -> assertThat(responseBody.message())
                    .isEqualTo("Successfully added review to product with ID: " + product.id()),
                () -> assertThat(responseBody.data()).isNotNull(),
                () -> assertThat(responseBody.path())
                    .isEqualTo("/api/v1/products/" + product.id() + "/reviews"),
                () -> assertThat(responseBody.timestamp()).isNotNull());
          } catch (Exception e) {
            Assertions.fail("Failed to parse response body", e);
          }
        }

        @Test
        void shouldPersistReviewInProduct() {
          Optional<Product> updatedProductOpt = productRepository.getProductById(product.id());
          Assertions.assertTrue(updatedProductOpt.isPresent(), "Product should exist");

          Product updatedProduct = updatedProductOpt.get();
          assertThat(updatedProduct.reviews()).hasSize(1);
        }
      }

      @Nested
      class WithInvalidRating {

        private static final int INVALID_RATING = 6;

        private ResponseEntity<String> response;

        @BeforeEach
        void createInvalidReview() {
          HttpEntity<Map<String, Object>> request = createReviewRequest(INVALID_RATING);
          response = restTemplate.postForEntity(
              baseUrl + "/" + product.id() + "/reviews",
              request,
              String.class);
        }

        @Test
        void shouldReturnClientError() {
          assertThat(response.getStatusCode().is4xxClientError()).isTrue();
        }

        @Test
        void shouldReturnErrorDetails() {
          try {
            ErrorDetails errorDetails = parseResponse(response.getBody(), ErrorDetails.class);

            assertAll("Verify error details",
                () -> assertThat(errorDetails.status()).isEqualTo(400),
                () -> assertThat(errorDetails.message())
                    .isEqualTo("Invalid rating: " + INVALID_RATING + ". Rating must be between 1 and 5"),
                () -> assertThat(errorDetails.path())
                    .isEqualTo("/api/v1/products/" + product.id() + "/reviews"),
                () -> assertThat(errorDetails.timestamp()).isNotNull(),
                () -> assertThat(errorDetails.details()).isEmpty());
          } catch (Exception e) {
            Assertions.fail("Failed to parse error details", e);
          }
        }
      }
    }
  }

  @Nested
  class GivenAnInvalidProductId {

    private static final String INVALID_PRODUCT_ID = "invalid";

    @Nested
    class WhenCreatingAReview {

      private ResponseEntity<String> response;

      @BeforeEach
      void createReviewForInvalidProduct() {
        HttpEntity<Map<String, Object>> request = createReviewRequest(5);
        response = restTemplate.postForEntity(
            baseUrl + "/" + INVALID_PRODUCT_ID + "/reviews",
            request,
            String.class);
      }

      @Test
      void shouldReturnNotFoundError() {
        assertThat(response.getStatusCode().is4xxClientError()).isTrue();
      }

      @Test
      void shouldReturnErrorDetails() {
        try {
          ErrorDetails errorDetails = parseResponse(response.getBody(), ErrorDetails.class);

          assertAll("Verify error details for invalid product ID",
              () -> assertThat(errorDetails.status()).isEqualTo(404),
              () -> assertThat(errorDetails.message())
                  .isEqualTo("Resource of type Product with id <<" + INVALID_PRODUCT_ID + ">> not found"),
              () -> assertThat(errorDetails.details()).isEmpty(),
              () -> assertThat(errorDetails.path())
                  .isEqualTo("/api/v1/products/" + INVALID_PRODUCT_ID + "/reviews"),
              () -> assertThat(errorDetails.timestamp()).isNotNull());
        } catch (Exception e) {
          Assertions.fail("Failed to parse error details", e);
        }
      }
    }
  }
}
