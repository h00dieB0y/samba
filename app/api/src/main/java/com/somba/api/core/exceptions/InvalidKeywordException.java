package com.somba.api.core.exceptions;

public class InvalidKeywordException extends RuntimeException {
    public InvalidKeywordException(String keyword) {
        super("Search keyword is invalid: " + keyword + ". Keyword must have at least 3 characters.");
    }
}
