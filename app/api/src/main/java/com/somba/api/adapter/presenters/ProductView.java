package com.somba.api.adapter.presenters;

public record ProductView(
    String id,
    String name,
    String brand,
    int price
) {
}
