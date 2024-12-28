package com.somba.api.e2e;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.somba.api.core.ports.ProductRepository;
import org.junit.jupiter.api.BeforeEach;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.testcontainers.containers.MongoDBContainer;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.elasticsearch.ElasticsearchContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;
import org.testcontainers.utility.DockerImageName;

@SpringBootTest(
    webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT,
    properties = {"spring.profiles.active=test"}
)
@Testcontainers
public abstract class BaseE2ETest {

    // Define Docker images as constants
    private static final String POSTGRES_IMAGE = "postgres:latest";
    private static final String MONGO_IMAGE = "mongo:latest";
    private static final String ELASTICSEARCH_IMAGE = "docker.elastic.co/elasticsearch/elasticsearch:8.17.0";

    // Initialize PostgreSQL Container
    @Container
    protected static final PostgreSQLContainer<?> postgreSQLContainer = new PostgreSQLContainer<>(POSTGRES_IMAGE);

    // Initialize MongoDB Container
    @Container
    protected static final MongoDBContainer mongoDBContainer = new MongoDBContainer(MONGO_IMAGE);

    @Container
    public static ElasticsearchContainer elasticsearchContainer = new ElasticsearchContainer(
            DockerImageName.parse(ELASTICSEARCH_IMAGE))
            .withEnv("discovery.type", "single-node")
                .withEnv("xpack.security.enabled", "false"); // Disable security


    @DynamicPropertySource
    static void configureProperties(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", postgreSQLContainer::getJdbcUrl);
        registry.add("spring.data.mongodb.uri", mongoDBContainer::getReplicaSetUrl);
        registry.add("spring.elasticsearch.uris", elasticsearchContainer::getHttpHostAddress);
    }

    // Injected beans
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

    // Common helper methods can be added here
}
