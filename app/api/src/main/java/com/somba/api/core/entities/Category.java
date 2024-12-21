package com.somba.api.core.entities;

import com.somba.api.core.exceptions.InvalidCategoryException;
import com.somba.api.core.exceptions.NullCategoryException;

public enum Category {
    ELECTRONICS("electronics"),
    CLOTHES("clothes"),
    SHOES("shoes"),
    OTHER("other");

    private final String value;

    Category(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }

    public static Category fromValue(String value) {
      if (value == null) {
          throw new NullCategoryException("Category cannot be null");
      }
        for (Category category : Category.values()) {
            if (category.value.equals(value.toLowerCase())) {
                return category;
            }
        }
        throw new InvalidCategoryException("Invalid category: " + value);
    }

    @Override
    public String toString() {
        return value;
    }
}
