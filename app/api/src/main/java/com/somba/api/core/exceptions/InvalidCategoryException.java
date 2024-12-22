package com.somba.api.core.exceptions;

import com.somba.api.core.entities.Category;

public class InvalidCategoryException extends RuntimeException {
    public InvalidCategoryException(String category) {
        super("Invalid category provided: " + category + ". Valid categories are: " +
                Category.values());
    }
}
