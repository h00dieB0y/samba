package com.somba.api.core.entities;

import java.util.UUID;

public record Product(
    UUID id,
    String name,
    String description,
    String brand,
    int price,
    int stock
) {
}
