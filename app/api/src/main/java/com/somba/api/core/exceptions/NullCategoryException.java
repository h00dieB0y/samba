package com.somba.api.core.exceptions;

public class NullCategoryException extends RuntimeException {
    public NullCategoryException() {
        super("Category cannot be null");
    }
}
