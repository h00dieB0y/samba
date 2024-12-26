package com.somba.api.infrastructure.search;

import java.util.List;

import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;

public interface ElasticsearchProductSearchRepository extends ElasticsearchRepository<ProductDocument, String> {
  // Exact match and null values match all
  // With Pageable
  List<ProductDocument> findByNameOrDescriptionOrBrand(String name, String description, String brand);
}
