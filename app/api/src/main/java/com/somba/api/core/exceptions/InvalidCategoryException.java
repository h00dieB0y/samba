package com.somba.api.core.exceptions;

import java.util.Locale.Category;

public class InvalidCategoryException extends RuntimeException {
    public InvalidCategoryException(String category) {
        super("Invalid category provided: " + category + ". Valid categories are: " +
                Category.values());
    }
}
