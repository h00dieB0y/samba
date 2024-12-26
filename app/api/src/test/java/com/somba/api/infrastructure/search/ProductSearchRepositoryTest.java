package com.somba.api.infrastructure.search;

import com.somba.api.core.enums.Category;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.data.elasticsearch.DataElasticsearchTest;
import org.springframework.data.elasticsearch.core.ElasticsearchOperations;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.testcontainers.elasticsearch.ElasticsearchContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;
import org.testcontainers.utility.DockerImageName;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@Testcontainers
@DataElasticsearchTest
class ProductSearchRepositoryTest {

    @Autowired
    private ElasticsearchProductSearchRepository productSearchRepository;

    @Autowired
    private ElasticsearchOperations elasticsearchOperations; // For index refresh

    // Define the Docker image for Elasticsearch
    private static final String ELASTICSEARCH_DOCKER_IMAGE = "docker.elastic.co/elasticsearch/elasticsearch:8.16.2";

    // Initialize the Elasticsearch TestContainer
    @Container
    public static ElasticsearchContainer elasticsearchContainer = new ElasticsearchContainer(DockerImageName.parse(ELASTICSEARCH_DOCKER_IMAGE))
                .withEnv("discovery.type", "single-node")
                .withEnv("xpack.security.enabled", "false") // Disable security
                .withExposedPorts(9200, 9300) // Ensure ports are exposed
                .waitingFor(org.testcontainers.containers.wait.strategy.Wait.forHttp("/").forStatusCode(200)); // Wait until Elasticsearch is up

    @DynamicPropertySource
    static void setElasticsearchProperties(DynamicPropertyRegistry registry) {
        registry.add("spring.elasticsearch.uris", elasticsearchContainer::getHttpHostAddress);
        // Removed username and password since security is disabled
    }

    @BeforeEach
    void setUp() {
        productSearchRepository.deleteAll();

        // Indexing sample products
        ProductDocument doc1 = new ProductDocument();
        doc1.setId("1");
        doc1.setName("Gaming Laptop");
        doc1.setDescription("High performance laptop for gaming");
        doc1.setBrand("Alienware");
        doc1.setCategory(Category.ELECTRONICS.name());
        doc1.setPrice(1500);
        productSearchRepository.save(doc1);

        ProductDocument doc2 = new ProductDocument();
        doc2.setId("2");
        doc2.setName("Business Laptop");
        doc2.setDescription("Efficient and reliable for business use");
        doc2.setBrand("Dell");
        doc2.setCategory(Category.ELECTRONICS.name());
        doc2.setPrice(1000);
        productSearchRepository.save(doc2);

        ProductDocument doc3 = new ProductDocument();
        doc3.setId("3");
        doc3.setName("Wireless Mouse");
        doc3.setDescription("Ergonomic wireless mouse");
        doc3.setBrand("Logitech");
        doc3.setCategory(Category.CLOTHES.name());
        doc3.setPrice(50);
        productSearchRepository.save(doc3);

        // Refresh the index to make sure all documents are searchable
        elasticsearchOperations.indexOps(ProductDocument.class).refresh();
    }

    @ParameterizedTest
    @CsvSource({
        "'Gaming Laptop', '', '', 1, '1', 'Gaming Laptop', 'ELECTRONICS', 1500",
        "'', 'Ergonomic wireless mouse', '', 1, '3', 'Wireless Mouse', 'CLOTHES', 50",
        "'', '', 'Dell', 1, '2', 'Business Laptop', 'ELECTRONICS', 1000"
    })
    void shouldReturnMatchingProducts_WhenSearchByNameDescriptionAndBrand(
            String nameKeyword, String descriptionKeyword, String brandKeyword,
            int expectedSize, String expectedId, String expectedName,
            String expectedCategory, int expectedPrice) {
        
        List<ProductDocument> results = productSearchRepository.findByNameOrDescriptionOrBrand(nameKeyword, descriptionKeyword, brandKeyword);
        
        assertThat(results).hasSize(expectedSize);
        assertThat(results.get(0).getId()).isEqualTo(expectedId);
        assertThat(results.get(0).getName()).isEqualTo(expectedName);
        assertThat(results.get(0).getCategory()).isEqualTo(expectedCategory);
        assertThat(results.get(0).getPrice()).isEqualTo(expectedPrice);
    }

    @ParameterizedTest
    @CsvSource({
        "'Laptop', 'Ergonomic wireless mouse', '', 3, '1,2,3'",
        "'Mouse', 'reliable', 'Alienware', 3, '1,2,3'",
        "'Smartphone', 'Waterproof', 'Samsung', 0, ''"
    })
    void shouldReturnCorrectProducts_WhenSearchWithVariousKeywordCombinations(
            String nameKeyword, String descriptionKeyword, String brandKeyword, int expectedSize, String expectedIds) {
        List<ProductDocument> results = productSearchRepository.findByNameOrDescriptionOrBrand(nameKeyword, descriptionKeyword, brandKeyword);
        
        assertThat(results).hasSize(expectedSize);
        if (expectedSize > 0) {
            List<String> expectedIdList = List.of(expectedIds.split(","));
            assertThat(results).extracting(ProductDocument::getId).containsExactlyInAnyOrderElementsOf(expectedIdList);
        }
    }

    @Test
    void shouldFindProductsIgnoringCase_WhenSearchKeywordsHaveDifferentCasing() {
        String nameKeyword = "gaming laptop"; // lowercase
        String descriptionKeyword = "HIGH PERFORMANCE"; // uppercase
        String brandKeyword = "alienware"; // lowercase

        List<ProductDocument> results = productSearchRepository.findByNameOrDescriptionOrBrand(nameKeyword, descriptionKeyword, brandKeyword);

        assertThat(results).hasSize(1);
        assertThat(results.get(0).getId()).isEqualTo("1");
    }

    @Test
    void shouldHandleSpecialCharactersGracefully_WhenSearchKeywordsContainSpecialChars() {
        String nameKeyword = "Gaming@Laptop#"; // Special characters
        String descriptionKeyword = "High-performance!"; // Special characters
        String brandKeyword = "Alienware$"; // Special characters

        List<ProductDocument> results = productSearchRepository.findByNameOrDescriptionOrBrand(nameKeyword, descriptionKeyword, brandKeyword);

        assertThat(results).hasSize(1);
        assertThat(results.get(0).getId()).isEqualTo("1");
    }

    @Test
    void shouldReturnNoProducts_WhenSearchKeywordsAreEmpty() {
        String nameKeyword = "";
        String descriptionKeyword = "";
        String brandKeyword = "";

        List<ProductDocument> results = productSearchRepository.findByNameOrDescriptionOrBrand(nameKeyword, descriptionKeyword, brandKeyword);

        assertThat(results).isEmpty();
    }
}
