# Spring Boot User CRUD API

A robust **Spring Boot** RESTful CRUD application for managing users, featuring a multi-instance Docker deployment with MySQL persistence. Demonstrates best practices in containerization, health checks, service dependencies, and scalable microservice-style architecture.

![Java](https://img.shields.io/badge/Java-25-ED8B00?logo=openjdk&logoColor=white)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.x-6DB33F?logo=spring&logoColor=white)
![Maven](https://img.shields.io/badge/Maven-3.x-C71A36?logo=apache-maven&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-8.x-4479A1?logo=mysql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker%20Compose-2496ED?logo=docker&logoColor=white)

---

## ✨ Features

- Complete **CRUD** operations for User entity
- Multi-instance deployment (3 Spring Boot instances sharing one MySQL database)
- Database schema management with **Flyway** migrations
- Health monitoring via Spring Boot Actuator
- Dockerized environment with proper service dependencies and health checks
- Isolated Docker network for secure internal communication
- Persistent MySQL data volume

## 🛠 Tech Stack

- **Backend**: Spring Boot 3.x, Spring Data JPA, Spring Web
- **Database**: MySQL 8 with Flyway migrations
- **Build Tool**: Maven
- **Containerization**: Docker + Docker Compose
- **Monitoring**: Spring Boot Actuator

## 📁 Project Structure

```bash
springboot-user-crud/
├── pom.xml
├── README.md
├── Dockerfile
├── docker-compose.yml
├── .env
├── src/
│   └── main/
│       ├── java/com/example/demo/
│       │   ├── DemoApplication.java
│       │   ├── entity/
│       │   │   └── User.java
│       │   ├── repository/
│       │   │   └── UserRepository.java
│       │   ├── service/
│       │   │   └── UserService.java
│       │   └── controller/
│       │       └── UserController.java
│       └── resources/
│           ├── application.properties
│           └── db/migration/
│               └── V1__Create_Users_Table.sql
🚀 Quick Start
Prerequisites

Docker and Docker Compose installed
Java 17+ and Maven (optional, for local development)

Step-by-Step Setup
1. Clone the repository
Bashgit clone <repository-url>
cd springboot-user-crud
2. Build the JAR
Bash# Using Maven Wrapper (recommended)
./mvnw clean package -DskipTests

# Or using installed Maven
mvn clean package -DskipTests
3. Start all services
Bashdocker compose up --build -d
4. Verify services
Bash# Check running containers
docker compose ps

# View logs
docker compose logs -f
5. Access the application






























InstanceURLHealth CheckApp 1http://localhost:8081http://localhost:8081/actuator/healthApp 2http://localhost:8082http://localhost:8082/actuator/healthApp 3http://localhost:8083http://localhost:8083/actuator/healthMySQLlocalhost:3306docker compose exec mysql mysqladmin ping
📋 API Endpoints








































MethodEndpointDescriptionGET/api/usersGet all usersGET/api/users/{id}Get user by IDGET/api/users/status/{status}Get users by ACTIVE/INACTIVEPOST/api/usersCreate a new userPUT/api/users/{id}Update userDELETE/api/users/{id}Delete user
🏗 Architecture
textDocker Host
├── spring-app-1 (:8080 → host:8081)
├── spring-app-2 (:8080 → host:8082)
├── spring-app-3 (:8080 → host:8083)
└── mysql-db (:3306) + mysql_data volume

All apps connected via 'app-network' (bridge)
Components

























ComponentPurposeMySQL ContainerSingle source of truth database. Uses mysql_native_password authentication. Data persisted via named volume.App Instances (1-3)Three identical Spring Boot containers running the same JAR. Load-balanced style deployment on different host ports.Docker NetworkIsolated bridge network enabling service-to-service communication via names (mysql-db).Health ChecksMySQL: mysqladmin ping. Apps: Spring Boot Actuator /actuator/health.
Startup Sequence

MySQL starts and passes health checks (5 successful pings)
Docker starts the three Spring Boot instances only after MySQL is healthy
Each app performs its own health check via Actuator
All instances ready to serve traffic

🧹 Management Commands
Stop services
Bash# Graceful shutdown (volumes preserved)
docker compose down

# Full cleanup (removes volumes)
docker compose down -v
Restart specific service
Bashdocker compose restart app-1
Cleanup Docker
Bash# Remove dangling images
docker image prune -f

# Remove unused volumes
docker volume prune -f

# Full system cleanup
docker system prune -a --volumes -f
✅ Quick Start Checklist

 Add spring-boot-starter-actuator to pom.xml
 Place Dockerfile in project root
 Place docker-compose.yml and .env in project root
 Configure database properties under docker profile
 Build JAR with Maven
 Run docker compose up --build -d
 Verify health endpoints

🔧 Development
Local Development (without Docker)
Bash./mvnw spring-boot:run
Running Tests
Bash./mvnw test
📝 Notes

The application uses Flyway for database migrations.
All three application instances share the same database.
Ports 8081, 8082, and 8083 are mapped on the host.
