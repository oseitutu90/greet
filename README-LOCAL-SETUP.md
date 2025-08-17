# Greet Application - Local Development Setup

This document explains different ways to run the Greet application locally with minimal external dependencies.

## 🎯 Overview

The Greet application has the following dependencies:
- **MongoDB** - Database (configured but not actively used in current code)
- **Unleash** - Feature flag service
- **Spring Boot Actuator** - Health checks and monitoring

## 🚀 Running Options

### Option 1: Fully Containerized (Recommended)

Run everything in Docker containers - no local setup required.

```bash
# Make scripts executable
chmod +x docker-run.sh

# Start everything
./docker-run.sh up

# View logs
./docker-run.sh logs-app

# Stop everything
./docker-run.sh down
```

**Access Points:**
- Application: http://localhost:8080
- Health Check: http://localhost:8080/actuator/health
- Greet Endpoint: http://localhost:8080/greet
- Unleash UI: http://localhost:4242 (admin/unleash)

### Option 2: Dependencies in Docker, App Local

Run MongoDB and Unleash in Docker, but run the Spring Boot app locally for easier debugging.

```bash
# Make scripts executable
chmod +x run-deps.sh

# Start dependencies only
./run-deps.sh up

# In another terminal, run the app locally
export SPRING_PROFILES_ACTIVE=dev
export MONGO_URI=mongodb://localhost:27017/demo
export UNLEASH_API_URL=http://localhost:4242/api
./mvnw spring-boot:run
```

### Option 3: Fully Local (No External Dependencies)

Run with mocked dependencies - no external services needed.

```bash
# Make scripts executable
chmod +x run-local.sh

# Run with local profile (mocked dependencies)
./run-local.sh
```

This mode:
- ✅ Uses mock Unleash (no external service)
- ✅ Disables MongoDB auto-configuration
- ✅ No external dependencies required

## 🔧 Configuration Profiles

### `local` Profile
- Mock Unleash implementation
- MongoDB auto-configuration disabled
- No external dependencies

### `dev` Profile
- Real Unleash connection required
- MongoDB connection required
- For development with real services

### `docker` Profile
- Designed for Docker Compose environment
- Uses container service names for connections
- All services containerized

## 📝 Scripts Reference

### docker-run.sh
```bash
./docker-run.sh up        # Start all services
./docker-run.sh down      # Stop all services
./docker-run.sh logs      # View all logs
./docker-run.sh logs-app  # View app logs only
./docker-run.sh status    # Show service status
./docker-run.sh clean     # Clean everything including volumes
./docker-run.sh restart   # Restart all services
```

### run-deps.sh
```bash
./run-deps.sh up      # Start MongoDB + Unleash only
./run-deps.sh down    # Stop dependencies
./run-deps.sh logs    # View dependency logs
./run-deps.sh status  # Show dependency status
./run-deps.sh clean   # Clean dependencies
```

### run-local.sh
```bash
./run-local.sh        # Run with no external dependencies
```

## 🧪 Testing the Application

### Manual Testing
Once running, test the endpoints:

```bash
# Health check
curl http://localhost:8080/actuator/health

# Greet endpoint (will show different messages based on feature flags)
curl http://localhost:8080/greet
```

### Automated Testing

Use the test runner script for comprehensive testing:

```bash
# Make script executable
chmod +x run-tests.sh

# Run unit tests only (fast, no external dependencies)
./run-tests.sh unit

# Run integration tests (requires running application)
./run-tests.sh integration

# Run all tests
./run-tests.sh all

# Run with coverage report
./run-tests.sh coverage
```

**Test Commands:**

```bash
# Unit tests only (uses local profile with mocks)
./mvnw test -Dspring.profiles.active=local

# Integration tests only (requires app running on localhost:8080)
./mvnw test -Dtest=KarateTestRunner

# All tests
./mvnw test

# Tests with coverage
./mvnw clean test jacoco:report
```

## 🚩 Feature Flags

The application uses Unleash for feature flags:

- **Feature**: `new-greeting`
- **When enabled**: Returns "🚀 Hello from the new feature!"
- **When disabled**: Returns "👋 Hello from the classic endpoint."

### In Local Mode
The mock Unleash always returns `true` for `new-greeting` feature.

### In Docker/Dev Mode
You can control the feature flag via Unleash UI at http://localhost:4242

## 🐛 Troubleshooting

### Build Issues
```bash
# Clean and rebuild
./mvnw clean compile

# If Docker build fails
docker-compose down
docker-compose build --no-cache
```

### Port Conflicts
If ports are already in use, modify the port mappings in `docker-compose.yml`:
- MongoDB: Change `27017:27017` to `27018:27017`
- Unleash: Change `4242:4242` to `4243:4242`
- App: Change `8080:8080` to `8081:8080`

### Logs
```bash
# View all service logs
./docker-run.sh logs

# View only application logs
./docker-run.sh logs-app

# View dependency logs
./run-deps.sh logs
```

## 🔄 Development Workflow

1. **Start with Option 1** (fully containerized) to verify everything works
2. **Switch to Option 2** for active development (dependencies in Docker, app local)
3. **Use Option 3** for quick testing without any external services

This setup gives you maximum flexibility for local development while minimizing external dependencies!
