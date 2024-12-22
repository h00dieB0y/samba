package com.somba.api.core.exceptions;

public class InvalidPaginationParameterException extends RuntimeException {
    public InvalidPaginationParameterException(int page, int size) {
        super(constructMessage(page, size));
    }

    private static String constructMessage(int page, int size) {
        String message = "Invalid pagination parameters provided: ";
        String pageMessage = "page=" + page + " (must be >= 0)";
        String sizeMessage = "size=" + size + " (must be > 0)";

        if (page < 0 && size < 1) {
            return message + pageMessage + " and " + sizeMessage + ".";
        } else if (page < 0) {
            return message + pageMessage + ".";
        } else {
            return message + sizeMessage + ".";
        }
    }
}
