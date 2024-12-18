package com.somba.api.adapters.presenters;

public record ProductView(
    String id,
    String name,
    String brand,
    int price
) {
}
