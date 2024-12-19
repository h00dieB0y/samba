# Somba E-commerce API

[![Build Status](https://github.com/h00dieB0y/somba/actions/workflows/api-ci.yml/badge.svg)](https://github.com/h00dieB0y/somba-api/actions)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=com.somba%3Aapi&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=com.somba%3Aapi)
[![Bugs](https://sonarcloud.io/api/project_badges/measure?project=com.somba%3Aapi&metric=bugs)](https://sonarcloud.io/summary/new_code?id=com.somba%3Aapi)
[![Code Smells](https://sonarcloud.io/api/project_badges/measure?project=com.somba%3Aapi&metric=code_smells)](https://sonarcloud.io/summary/new_code?id=com.somba%3Aapi)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=com.somba%3Aapi&metric=coverage)](https://sonarcloud.io/summary/new_code?id=com.somba%3Aapi)
[![Duplicated Lines (%)](https://sonarcloud.io/api/project_badges/measure?project=com.somba%3Aapi&metric=duplicated_lines_density)](https://sonarcloud.io/summary/new_code?id=com.somba%3Aapi)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Somba E-commerce API is a robust RESTful service built with Spring Boot, designed to manage products within an e-commerce platform efficiently.

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
  - Create, read, update, and delete products.*(Coming Soon)*
  - Search products by name, category, and other attributes.*(Coming Soon)*
  - Pagination support for product listings.

## Getting Started

Follow these instructions to set up and run the project locally for development and testing purposes.

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

2. Configure environment variables:
    ```sh
    cp .env.example .env
    ```

3. Build the project using Maven:
    ```sh
    ./mvnw clean install
    ```

## Running the Application

1. Start services with Docker Compose:
    ```sh
    docker-compose up -d
    ```

2. Launch the Spring Boot application:
    ```sh
    ./mvnw spring-boot:run
    ```

Access the application at [http://localhost:8081](http://localhost:8081).

## Running Tests

Execute the tests with:
```sh
./mvnw test
```

## API Documentation

Access the API documentation at [http://localhost:8081/swagger-ui.html](http://localhost:8081/swagger-ui.html).

## Project Structure

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

Contributions are welcome! Please open an issue or submit a pull request for any enhancements or bug fixes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
