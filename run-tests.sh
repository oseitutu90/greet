#!/bin/bash

# Test runner script for the Greet application
# This script provides different ways to run tests

set -e

show_help() {
    echo "🧪 Greet Application Test Runner"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  unit            Run unit tests only (fast, no external dependencies)"
    echo "  integration     Run integration tests (requires running application)"
    echo "  all             Run all tests (unit + integration)"
    echo "  karate          Run Karate integration tests only"
    echo "  coverage        Run tests with coverage report"
    echo "  help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 unit         # Quick unit tests"
    echo "  $0 integration  # Integration tests (app must be running)"
    echo "  $0 all          # All tests"
}

run_unit_tests() {
    echo "🧪 Running unit tests..."
    echo "📝 These tests run with mocked dependencies (local profile)"
    echo ""
    
    ./mvnw test -Dspring.profiles.active=local
    
    if [ $? -eq 0 ]; then
        echo "✅ Unit tests passed!"
    else
        echo "❌ Unit tests failed!"
        exit 1
    fi
}

run_integration_tests() {
    echo "🧪 Running integration tests..."
    echo "📝 These tests require the application to be running on localhost:8080"
    echo ""
    
    # Check if application is running
    if ! curl -s http://localhost:8080/actuator/health > /dev/null; then
        echo "❌ Application is not running on localhost:8080"
        echo "Please start the application first:"
        echo "  ./run-local.sh"
        echo "  OR"
        echo "  ./run-deps.sh up && ./mvnw spring-boot:run"
        echo "  OR"
        echo "  ./docker-run.sh up"
        exit 1
    fi
    
    echo "✅ Application is running, proceeding with integration tests..."
    
    ./mvnw test -Dtest=KarateTestRunner
    
    if [ $? -eq 0 ]; then
        echo "✅ Integration tests passed!"
    else
        echo "❌ Integration tests failed!"
        exit 1
    fi
}

run_karate_tests() {
    echo "🥋 Running Karate tests..."
    echo "📝 These are API integration tests"
    echo ""
    
    # Check if application is running
    if ! curl -s http://localhost:8080/actuator/health > /dev/null; then
        echo "❌ Application is not running on localhost:8080"
        echo "Please start the application first:"
        echo "  ./run-local.sh"
        echo "  OR"
        echo "  ./run-deps.sh up && ./mvnw spring-boot:run"
        echo "  OR"
        echo "  ./docker-run.sh up"
        exit 1
    fi
    
    ./mvnw test -Dtest=KarateTestRunner
    
    if [ $? -eq 0 ]; then
        echo "✅ Karate tests passed!"
    else
        echo "❌ Karate tests failed!"
        exit 1
    fi
}

run_all_tests() {
    echo "🧪 Running all tests..."
    echo ""
    
    echo "1️⃣ Running unit tests first..."
    run_unit_tests
    
    echo ""
    echo "2️⃣ Running integration tests..."
    run_integration_tests
    
    echo ""
    echo "🎉 All tests completed successfully!"
}

run_coverage() {
    echo "📊 Running tests with coverage..."
    echo ""
    
    ./mvnw clean test jacoco:report -Dspring.profiles.active=local
    
    if [ $? -eq 0 ]; then
        echo "✅ Tests with coverage completed!"
        echo "📊 Coverage report available at: target/site/jacoco/index.html"
    else
        echo "❌ Tests with coverage failed!"
        exit 1
    fi
}

# Main script logic
case "${1:-help}" in
    unit)
        run_unit_tests
        ;;
    integration)
        run_integration_tests
        ;;
    karate)
        run_karate_tests
        ;;
    all)
        run_all_tests
        ;;
    coverage)
        run_coverage
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "❌ Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac
