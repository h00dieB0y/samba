package com.somba.api.adapter.presenters;

import java.time.LocalDateTime;

public record Response<T>(int status, String message, T data, String path, LocalDateTime timestamp) {
    public Response {
        if (status < 100 || status > 599) {
            throw new IllegalArgumentException("Invalid status code: " + status);
        }
    }

    public Response(int status, String message, T data, String path) {
        this(status, message, data, path, LocalDateTime.now());
    }
}
