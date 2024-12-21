package com.somba.api.core.exceptions;

public class InvalidPaginationParameterException extends RuntimeException {
    public InvalidPaginationParameterException(int page, int size) {
        super("Invalid pagination parameters provided: " +
                "page=" + page + "(must be greater or equal to 0) and " +
                "size=" + size + "(must be greater than 0)");
    }
}
