package com.somba.api.core.exceptions;

public class ResourceNotFoundException extends RuntimeException {
  public ResourceNotFoundException(String id, Class<?> clazz) {
    super(String.format("Resource of type %s with id <<%s>> not found", clazz.getSimpleName(), id));
  }
  
}
