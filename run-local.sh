#!/bin/bash

# Script to run the Spring Boot application locally with minimal dependencies
# This script sets up the local profile and runs the application without external dependencies

echo "🚀 Starting Greet Application in Local Development Mode"
echo "📝 This mode uses:"
echo "   - Mock Unleash (no external feature flag service needed)"
echo "   - Local MongoDB or embedded alternatives"
echo "   - All external dependencies mocked or disabled"
echo ""

# Set the Spring profile to 'local'
export SPRING_PROFILES_ACTIVE=local

# Optional: Set local MongoDB URI if you have MongoDB running locally
# export MONGO_URI=mongodb://localhost:27017/demo-local

# Optional: Override any other environment variables for local development
export UNLEASH_ENABLED=false

echo "🔧 Building the application..."
./mvnw clean compile

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo "🏃 Running the application with 'local' profile..."
    echo "📍 Application will be available at: http://localhost:8080"
    echo "🔍 Health check endpoint: http://localhost:8080/actuator/health"
    echo "👋 Greet endpoint: http://localhost:8080/greet"
    echo ""
    
    # Run the application
    ./mvnw spring-boot:run -Dspring-boot.run.profiles=local
else
    echo "❌ Build failed. Please check the errors above."
    exit 1
fi
