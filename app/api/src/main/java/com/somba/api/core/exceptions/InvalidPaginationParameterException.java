package com.somba.api.core.exceptions;

public class InvalidPaginationParameterException extends RuntimeException {
    public InvalidPaginationParameterException(String message) {
        super(message);
    }

    public InvalidPaginationParameterException(String message, Throwable cause) {
        super(message, cause);
    }
}
