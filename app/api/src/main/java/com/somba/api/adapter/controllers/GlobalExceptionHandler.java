package com.somba.api.adapter.controllers;

import org.springframework.http.HttpStatus;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import com.somba.api.adapter.presenters.ErrorDetails;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@ControllerAdvice
public class GlobalExceptionHandler {

  private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

  @ExceptionHandler(Exception.class)
  @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
  public ErrorDetails handleAllExceptions(Exception ex) {
    logger.error("An unexpected error occurred", ex);
    return new ErrorDetails(
      HttpStatus.INTERNAL_SERVER_ERROR.value(),
      "Internal Server Error",
      "An unexpected error occurred. Please try again later.",
      ServletUriComponentsBuilder.fromCurrentRequest().toUriString()
    );
  }
}
