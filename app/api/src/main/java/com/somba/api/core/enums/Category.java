package com.somba.api.core.enums;

import com.somba.api.core.exceptions.InvalidCategoryException;
import com.somba.api.core.exceptions.NullCategoryException;

public enum Category {
    ELECTRONICS,
    CLOTHES,
    SHOES,
    HOME,
    BEAUTY,
    SPORTS,
    OTHERS;



    public static Category fromValue(String value) {
      if (value == null) {
          throw new NullCategoryException();
      }
        for (Category category : Category.values()) {
            if (category.name().equalsIgnoreCase(value)) {
                return category;
            }
        }
        throw new InvalidCategoryException(value);
    }
}
