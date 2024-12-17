package com.somba.api.adapters.presenters;

import java.time.LocalDateTime;

public record ErrorDetails(
  LocalDateTime timestamp,
  int status,
  String error,
  String message,
  String path
) {

  public ErrorDetails(int status, String error, String message, String path) {
    this(LocalDateTime.now(), status, error, message, path);
  }
}
