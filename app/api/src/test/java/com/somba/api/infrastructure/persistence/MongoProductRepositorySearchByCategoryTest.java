package com.somba.api.infrastructure.persistence;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertAll;
import static org.junit.jupiter.api.Assertions.assertThrows;

import java.util.List;
import java.util.stream.IntStream;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.data.mongo.DataMongoTest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.testcontainers.containers.MongoDBContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

import com.somba.api.infrastructure.persistence.entities.ProductEntity;

@DataMongoTest
@Testcontainers
class MongoProductRepositorySearchByCategoryTest {

    private static final String CATEGORY_ONE = "category-one";
    private static final String CATEGORY_TWO = "category-two";
    private static final String CATEGORY_SPORTS = "sports";

    @Container
    static MongoDBContainer mongoDBContainer = new MongoDBContainer("mongo:latest");

    @Autowired
    private MdbProductRepository mdbProductRepository;

    @DynamicPropertySource
    static void mongoProperties(DynamicPropertyRegistry registry) {
        registry.add("spring.data.mongodb.uri", mongoDBContainer::getReplicaSetUrl);
    }

    @BeforeEach
    void setUp() {
        mdbProductRepository.deleteAll();
        preloadTestData(10, CATEGORY_ONE);
    }

    /**
     * Helper method to create and save a list of mock products.
     *
     * @param count    The number of products to create.
     * @param category The category to assign to each product.
     */
    private void preloadTestData(int count, String category) {
        List<ProductEntity> products = IntStream.range(0, count)
            .mapToObj(i -> new ProductEntity()
                .setName("Product " + i)
                .setDescription("Description " + i)
                .setBrand("Brand " + i)
                .setCategory(category)
                .setPrice(i * 100)
                .setStock(i * 10))
            .toList();
        mdbProductRepository.saveAll(products);
    }

    @Nested
    @DisplayName("1. Functional Tests")
    class FunctionalTests {

        @Test
        @DisplayName("1.1. Valid category with valid pagination")
        void testValidCategoryWithValidPagination() {
            // Arrange
            String category = CATEGORY_ONE;
            int pageNumber = 0; // 0-based index
            int pageSize = 5;

            // Act
            Page<ProductEntity> page = mdbProductRepository.findByCategory(category, PageRequest.of(pageNumber, pageSize));

            // Assert
            assertAll("Valid category with valid pagination",
                () -> assertThat(page).isNotNull(),
                () -> assertThat(page.getContent()).hasSize(5),
                () -> assertThat(page.getTotalElements()).isEqualTo(10),
                () -> assertThat(page.getTotalPages()).isEqualTo(2),
                () -> assertThat(page.getContent().get(0).getName()).isEqualTo("Product 0")
            );
        }

        @Test
        @DisplayName("1.2. Middle page retrieval")
        void testMiddlePageRetrieval() {
            // Arrange
            String category = CATEGORY_ONE;
            int pageNumber = 1; // Second page
            int pageSize = 3;

            // Act
            Page<ProductEntity> page = mdbProductRepository.findByCategory(category, PageRequest.of(pageNumber, pageSize));

            // Assert
            assertAll("Middle page retrieval",
                () -> assertThat(page).isNotNull(),
                () -> assertThat(page.getContent()).hasSize(3),
                () -> assertThat(page.getTotalElements()).isEqualTo(10),
                () -> assertThat(page.getTotalPages()).isEqualTo(4),
                () -> assertThat(page.getContent().get(0).getName()).isEqualTo("Product 3")
            );
        }

        @Test
        @DisplayName("1.3. Last page with fewer items")
        void testLastPageWithFewerItems() {
            // Arrange
            String category = CATEGORY_ONE;
            int pageNumber = 3; // Fourth page
            int pageSize = 3;

            // Act
            Page<ProductEntity> page = mdbProductRepository.findByCategory(category, PageRequest.of(pageNumber, pageSize));

            // Assert
            assertAll("Last page with fewer items",
                () -> assertThat(page).isNotNull(),
                () -> assertThat(page.getContent()).hasSize(1),
                () -> assertThat(page.getTotalElements()).isEqualTo(10),
                () -> assertThat(page.getTotalPages()).isEqualTo(4),
                () -> assertThat(page.getContent().get(0).getName()).isEqualTo("Product 9")
            );
        }

        @Test
        @DisplayName("1.4. Page size equal to total items")
        void testPageSizeEqualToTotalItems() {
            // Arrange
            String category = CATEGORY_ONE;
            int pageNumber = 0;
            int pageSize = 10;

            // Act
            Page<ProductEntity> page = mdbProductRepository.findByCategory(category, PageRequest.of(pageNumber, pageSize));

            // Assert
            assertAll("Page size equal to total items",
                () -> assertThat(page).isNotNull(),
                () -> assertThat(page.getContent()).hasSize(10),
                () -> assertThat(page.getTotalElements()).isEqualTo(10),
                () -> assertThat(page.getTotalPages()).isEqualTo(1),
                () -> assertThat(page.getContent().get(0).getName()).isEqualTo("Product 0")
            );
        }
    }

    @Nested
    @DisplayName("2. Boundary and Edge Cases")
    class BoundaryAndEdgeCases {

        @Test
        @DisplayName("2.1. Negative page number")
        void testNegativePageNumber() {
            // Arrange
            String category = CATEGORY_ONE;
            int pageNumber = -1; // Invalid page number
            int pageSize = 5;

            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> 
                mdbProductRepository.findByCategory(category, PageRequest.of(pageNumber, pageSize))
            , "Expected IllegalArgumentException for negative page number");
        }

        @Test
        @DisplayName("2.2. Zero page size")
        void testZeroPageSize() {
            // Arrange
            String category = CATEGORY_ONE;
            int pageNumber = 0;
            int pageSize = 0; // Invalid page size

            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> 
                mdbProductRepository.findByCategory(category, PageRequest.of(pageNumber, pageSize))
            , "Expected IllegalArgumentException for zero page size");
        }

        @Test
        @DisplayName("2.3. Negative page size")
        void testNegativePageSize() {
            // Arrange
            String category = CATEGORY_ONE;
            int pageNumber = 0;
            int pageSize = -5; // Invalid page size

            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> 
                mdbProductRepository.findByCategory(category, PageRequest.of(pageNumber, pageSize))
            , "Expected IllegalArgumentException for negative page size");
        }

        @Test
        @DisplayName("2.4. Page number beyond last page")
        void testPageNumberBeyondLastPage() {
            // Arrange
            String category = CATEGORY_ONE;
            int pageNumber = 5; // Only 2 pages exist (0 and 1)
            int pageSize = 5;

            // Act
            Page<ProductEntity> page = mdbProductRepository.findByCategory(category, PageRequest.of(pageNumber, pageSize));

            // Assert
            assertAll("Page number beyond last page",
                () -> assertThat(page).isNotNull(),
                () -> assertThat(page.getContent()).isEmpty(),
                () -> assertThat(page.getTotalElements()).isEqualTo(10),
                () -> assertThat(page.getTotalPages()).isEqualTo(2)
            );
        }

        @Test
        @DisplayName("2.5. Very large page number")
        void testVeryLargePageNumber() {
            // Arrange
            String category = CATEGORY_ONE;
            int pageNumber = 1000;
            int pageSize = 5;

            // Act
            Page<ProductEntity> page = mdbProductRepository.findByCategory(category, PageRequest.of(pageNumber, pageSize));

            // Assert
            assertAll("Very large page number",
                () -> assertThat(page).isNotNull(),
                () -> assertThat(page.getContent()).isEmpty(),
                () -> assertThat(page.getTotalElements()).isEqualTo(10),
                () -> assertThat(page.getTotalPages()).isEqualTo(2)
            );
        }

        @Test
        @DisplayName("2.6. Very large page size")
        void testVeryLargePageSize() {
            // Arrange
            String category = CATEGORY_ONE;
            int pageNumber = 0;
            int pageSize = 1000; // Larger than total items

            // Act
            Page<ProductEntity> page = mdbProductRepository.findByCategory(category, PageRequest.of(pageNumber, pageSize));

            // Assert
            assertAll("Very large page size",
                () -> assertThat(page).isNotNull(),
                () -> assertThat(page.getContent()).hasSize(10),
                () -> assertThat(page.getTotalElements()).isEqualTo(10),
                () -> assertThat(page.getTotalPages()).isEqualTo(1)
            );
        }
    }

    @Nested
    @DisplayName("3. Validation and Error Handling")
    class ValidationAndErrorHandling {

        @Test
        @DisplayName("3.1. Non-existent category")
        void testNonExistentCategory() {
            // Arrange
            String category = "non-existent-category";
            int pageNumber = 0;
            int pageSize = 5;

            // Act
            Page<ProductEntity> page = mdbProductRepository.findByCategory(category, PageRequest.of(pageNumber, pageSize));

            // Assert
            assertAll("Non-existent category",
                () -> assertThat(page).isNotNull(),
                () -> assertThat(page.getContent()).isEmpty(),
                () -> assertThat(page.getTotalElements()).isZero(),
                () -> assertThat(page.getTotalPages()).isZero()
            );
        }
    }

    @Nested
    @DisplayName("4. Data-Related Tests")
    class DataRelatedTests {

        @Test
        @DisplayName("4.1. Category with no items")
        void testCategoryWithNoItems() {
            // Arrange
            String category = CATEGORY_SPORTS;
            int pageNumber = 0;
            int pageSize = 5;

            // Act
            Page<ProductEntity> page = mdbProductRepository.findByCategory(category, PageRequest.of(pageNumber, pageSize));

            // Assert
            assertAll("Category with no items",
                () -> assertThat(page).isNotNull(),
                () -> assertThat(page.getContent()).isEmpty(),
                () -> assertThat(page.getTotalElements()).isZero(),
                () -> assertThat(page.getTotalPages()).isZero()
            );
        }

        @Test
        @DisplayName("4.2. Category with fewer items than page size")
        void testCategoryWithFewerItemsThanPageSize() {
            // Arrange
            preloadTestData(3, CATEGORY_TWO);

            String category = CATEGORY_TWO;
            int pageNumber = 0;
            int pageSize = 5;

            // Act
            Page<ProductEntity> page = mdbProductRepository.findByCategory(category, PageRequest.of(pageNumber, pageSize));

            // Assert
            assertAll("Category with fewer items than page size",
                () -> assertThat(page).isNotNull(),
                () -> assertThat(page.getContent()).hasSize(3),
                () -> assertThat(page.getTotalElements()).isEqualTo(3),
                () -> assertThat(page.getTotalPages()).isEqualTo(1),
                () -> assertThat(page.getContent().get(0).getName()).isEqualTo("Product 0")
            );
        }

        @Test
        @DisplayName("4.3. Exact multiple of page size")
        void testExactMultipleOfPageSize() {
            // Arrange
            preloadTestData(10, CATEGORY_TWO);

            String category = CATEGORY_TWO;
            int pageNumber = 1;
            int pageSize = 5;

            // Act
            Page<ProductEntity> page = mdbProductRepository.findByCategory(category, PageRequest.of(pageNumber, pageSize));

            // Assert
            assertAll("Exact multiple of page size",
                () -> assertThat(page).isNotNull(),
                () -> assertThat(page.getContent()).hasSize(5),
                () -> assertThat(page.getTotalElements()).isEqualTo(10),
                () -> assertThat(page.getTotalPages()).isEqualTo(2),
                () -> assertThat(page.getContent().get(0).getName()).isEqualTo("Product 5")
            );
        }

        @Test
        @DisplayName("4.4. Non-exact multiple of page size")
        void testNonExactMultipleOfPageSize() {
            // Arrange
            preloadTestData(7, CATEGORY_TWO);

            String category = CATEGORY_TWO;
            int pageNumber = 1;
            int pageSize = 5;

            // Act
            Page<ProductEntity> page = mdbProductRepository.findByCategory(category, PageRequest.of(pageNumber, pageSize));

            // Assert
            assertAll("Non-exact multiple of page size",
                () -> assertThat(page).isNotNull(),
                () -> assertThat(page.getContent()).hasSize(2),
                () -> assertThat(page.getTotalElements()).isEqualTo(7),
                () -> assertThat(page.getTotalPages()).isEqualTo(2),
                () -> assertThat(page.getContent().get(0).getName()).isEqualTo("Product 5")
            );
        }
    }
}
