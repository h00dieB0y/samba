package com.somba.api.core.exceptions;

public class NullCategoryException extends RuntimeException {
    public NullCategoryException(String message) {
        super(message);
    }

    public NullCategoryException(String message, Throwable cause) {
        super(message, cause);
    }
}
