package com.somba.api.adapter.controllers;

import com.somba.api.adapter.presenters.ErrorDetails;
import com.somba.api.core.exceptions.InvalidCategoryException;
import com.somba.api.core.exceptions.InvalidPaginationParameterException;
import com.somba.api.core.exceptions.InvalidRatingException;
import com.somba.api.core.exceptions.NullCategoryException;
import com.somba.api.core.exceptions.ResourceNotFoundException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.WebRequest;

import jakarta.validation.ConstraintViolationException;

import java.time.LocalDateTime;
import java.util.List;

@RestControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    /**
     * Handle all uncaught exceptions.
     */
    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public ErrorDetails handleAllExceptions(Exception ex, WebRequest request) {
        logger.error("An unexpected error occurred: {}", ex.getMessage(), ex);
        return new ErrorDetails(
                HttpStatus.INTERNAL_SERVER_ERROR.value(),
                HttpStatus.INTERNAL_SERVER_ERROR.getReasonPhrase(),
                "An unexpected error occurred. Please try again later.",
                request.getDescription(false).replace("uri=", "")
        );
    }

    /**
     * Handle validation exceptions for @Validated controller method parameters.
     */
    @ExceptionHandler(ConstraintViolationException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ErrorDetails handleConstraintViolationException(ConstraintViolationException ex, WebRequest request) {
        logger.warn("Constraint violation: {}", ex.getMessage());
        List<String> errors = ex.getConstraintViolations()
                .stream()
                .map(violation -> {
                    String field = violation.getPropertyPath().toString().split("\\.")[1];
                    String message = violation.getMessage();
                    return field + ": " + message;
                })
                .toList();

        return new ErrorDetails(
                HttpStatus.BAD_REQUEST.value(),
                HttpStatus.BAD_REQUEST.getReasonPhrase(),
                "Validation failed for one or more fields.",
                errors,
                request.getDescription(false).replace("uri=", ""),
                LocalDateTime.now()
        );
    }

    /**
     * Handle validation exceptions for @Valid annotated request bodies.
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ErrorDetails handleMethodArgumentNotValidException(MethodArgumentNotValidException ex, WebRequest request) {
        logger.warn("Method argument not valid: {}", ex.getMessage());

        List<String> errors = ex.getBindingResult()
                .getFieldErrors()
                .stream()
                .map(FieldError::getDefaultMessage)
                .toList();

        return new ErrorDetails(
                HttpStatus.BAD_REQUEST.value(),
                HttpStatus.BAD_REQUEST.getReasonPhrase(),
                "Validation failed for one or more fields.",
                errors,
                request.getDescription(false).replace("uri=", ""),
                LocalDateTime.now()
        );
    }

    /**
     * Handle exceptions where the request body is not readable (e.g., malformed JSON).
     */
    @ExceptionHandler(HttpMessageNotReadableException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ErrorDetails handleHttpMessageNotReadableException(HttpMessageNotReadableException ex, WebRequest request) {
        logger.warn("HTTP message not readable: {}", ex.getMessage());
        return new ErrorDetails(
                HttpStatus.BAD_REQUEST.value(),
                HttpStatus.BAD_REQUEST.getReasonPhrase(),
                "Malformed JSON request.",
                request.getDescription(false).replace("uri=", "")
        );
    }

    @ExceptionHandler(InvalidCategoryException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ErrorDetails handleInvalidCategoryException(InvalidCategoryException ex, WebRequest request) {
        logger.warn("Invalid category: {}", ex.getMessage());
        return new ErrorDetails(
                HttpStatus.BAD_REQUEST.value(),
                HttpStatus.BAD_REQUEST.getReasonPhrase(),
                ex.getMessage(),
                request.getDescription(false).replace("uri=", "")
        );
    }


    /**
     * Handle InvalidPaginationParameterException.
     */
    @ExceptionHandler(InvalidPaginationParameterException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ErrorDetails handleInvalidPaginationParameterException(InvalidPaginationParameterException ex, WebRequest request) {
        logger.warn("Invalid pagination parameters: {}", ex.getMessage());

        return new ErrorDetails(
                HttpStatus.BAD_REQUEST.value(),
                HttpStatus.BAD_REQUEST.getReasonPhrase(),
                ex.getMessage(),
                request.getDescription(false).replace("uri=", "")
        );
    }

    /**
     * Handle NullCategoryException.
     */
    @ExceptionHandler(NullCategoryException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ErrorDetails handleNullCategoryException(NullCategoryException ex, WebRequest request) {
        logger.warn("Null category provided: {}", ex.getMessage());

        return new ErrorDetails(
                HttpStatus.BAD_REQUEST.value(),
                HttpStatus.BAD_REQUEST.getReasonPhrase(),
                ex.getMessage(),
                request.getDescription(false).replace("uri=", "")
        );
    }

    /**
     * Handle InvalidRatingException.
     */
    @ExceptionHandler(InvalidRatingException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ErrorDetails handleInvalidRatingException(InvalidRatingException ex, WebRequest request) {
        logger.warn("Invalid rating provided: {}", ex.getMessage());

        return new ErrorDetails(
                HttpStatus.BAD_REQUEST.value(),
                HttpStatus.BAD_REQUEST.getReasonPhrase(),
                ex.getMessage(),
                request.getDescription(false).replace("uri=", "")
        );
    }

    /**
     * Handle ResourceNotFoundException.
     */
    @ExceptionHandler(ResourceNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public ErrorDetails handleResourceNotFoundException(ResourceNotFoundException ex, WebRequest request) {
        logger.warn("Resource not found: {}", ex.getMessage());

        return new ErrorDetails(
                HttpStatus.NOT_FOUND.value(),
                HttpStatus.NOT_FOUND.getReasonPhrase(),
                ex.getMessage(),
                request.getDescription(false).replace("uri=", "")
        );
    }
}
