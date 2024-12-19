# Somba E-commerce API

This is the Somba E-commerce API built with Spring Boot. It provides a RESTful API for managing products in an e-commerce platform.

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Running the Application](#running-the-application)
- [Running Tests](#running-tests)
- [API Documentation](#api-documentation)
- [Project Structure](#project-structure)
- [Contributing](#contributing)
- [License](#license)

## Features

- **Product Management**: 
  - Create, read, update, and delete products.*(Coming soon)*
  - Search products by name, category, and other attributes.*(Coming soon)*
  - Pagination support for product listings.

## Getting Started

These instructions will help you set up and run the project on your local machine for development and testing purposes.

## Prerequisites

- Java 21
- Maven
- Docker
- Docker Compose

## Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/yourusername/somba-api.git
    cd somba-api
    ```

2. Copy the example environment file and configure it:
    ```sh
    cp .env.example .env
    ```

3. Build the project using Maven:
    ```sh
    ./mvnw clean install
    ```

## Running the Application

1. Start the required services using Docker Compose:
    ```sh
    docker-compose up -d
    ```

2. Run the Spring Boot application:
    ```sh
    ./mvnw spring-boot:run
    ```

The application will be available at [http://localhost:8081](http://localhost:8081).

## Running Tests

To run the tests, use the following command:
```sh
./mvnw test
```

## API Documentation

The API documentation is available at [http://localhost:8081/swagger-ui.html](http://localhost:8081/swagger-ui.html).

## Project Structure

The project structure is as follows:

```
src/
├── main/
│   ├── java/
│   │   └── com/
│   │       └── somba/
│   │           ├── adapter/
│   │           │   ├── controllers/
│   │           │   ├── mappers/
│   │           │   ├── presenters/
│   │           │   └── repositories/
│   │           ├── core/
│   │           │   ├── entities/
│   │           │   ├── ports/
│   │           │   └── usecases/
│   │           ├── infrastructure/
│   │           │   ├── config/
│   │           │   ├── persistence/
│   │           │   │   ├── entities/
│   │           │   │   └── listeners/
│   │           │   └── search/
│   │           └── ApiApplication.java
│   └── resources/
│       ├── application.yml
│       ├── static/
│       └── templates/
└── test/
    ├── java/
    │   └── com/
    │       └── somba/
    │           ├── core/
    │           │   └── usecases/
    │           ├── e2e/
    │           └── infrastructure/
    │               └── persistence/
    └── resources/
        └── application.yml
```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any changes.

# License
This project is licensed under the MIT License - see the LICENSE file for details.

