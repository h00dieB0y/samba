package com.somba.api.adapter.presenters;

import java.time.LocalDateTime;
import java.util.List;

public record ErrorDetails(
  int status,
  String errorType,
  String message,
  List<String> details,
  String path,
  LocalDateTime timestamp
) {

  public ErrorDetails(int status, String error, String message, List<String> details, String path) {
    this(status, error, message, details, path, LocalDateTime.now());
  }

  public ErrorDetails(int status, String error, String message, String path) {
    this(status, error, message, List.of(), path, LocalDateTime.now());
  }
}
