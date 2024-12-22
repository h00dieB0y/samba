package com.somba.api.core.exceptions;

import java.util.Arrays;
import java.util.stream.Collectors;

import com.somba.api.core.enums.Category;

public class InvalidCategoryException extends RuntimeException {
    public InvalidCategoryException(String category) {
        super("Invalid category provided: '" + category + "'. Valid categories are: " +
                Arrays.stream(Category.values())
                      .map(Enum::name)
                      .collect(Collectors.joining(", ")));
    }
}
