package com.somba.api.core.entities;

import java.util.UUID;

public record Review(
    UUID id,
    UUID productId,
    int rating
) {
}
