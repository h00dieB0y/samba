package com.somba.api.adapters.presenters;


public record ProductResponse(
    String id,
    String name,
    String brand,
    int price
) {
}
