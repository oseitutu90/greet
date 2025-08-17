#!/bin/bash

# Script to run only the external dependencies (MongoDB + Unleash) in Docker
# Use this when you want to run your Spring Boot app locally but with containerized dependencies

set -e

COMPOSE_FILE="docker-compose.deps-only.yml"

show_help() {
    echo "🐳 Dependencies-Only Docker Script"
    echo ""
    echo "This script runs only MongoDB and Unleash in Docker containers."
    echo "Use this when you want to run your Spring Boot app locally with './mvnw spring-boot:run'"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  up      Start MongoDB and Unleash services"
    echo "  down    Stop and remove services"
    echo "  logs    Show logs from services"
    echo "  status  Show status of services"
    echo "  clean   Stop services and remove volumes"
    echo "  help    Show this help message"
    echo ""
    echo "After starting dependencies, run your app with:"
    echo "  export SPRING_PROFILES_ACTIVE=dev"
    echo "  export MONGO_URI=mongodb://localhost:27017/demo"
    echo "  export UNLEASH_API_URL=http://localhost:4242/api"
    echo "  ./mvnw spring-boot:run"
}

check_docker() {
    if ! command -v docker &> /dev/null; then
        echo "❌ Docker is not installed or not in PATH"
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        echo "❌ Docker Compose is not installed or not in PATH"
        exit 1
    fi
}

start_deps() {
    echo "🚀 Starting external dependencies..."
    echo "📝 This will start:"
    echo "   - MongoDB (port 27017)"
    echo "   - PostgreSQL for Unleash (internal)"
    echo "   - Unleash Server (port 4242)"
    echo ""
    
    docker-compose -f $COMPOSE_FILE up -d
    
    echo ""
    echo "✅ Dependencies started!"
    echo "🗄️  MongoDB: mongodb://localhost:27017/demo"
    echo "🚩 Unleash UI: http://localhost:4242 (admin/unleash)"
    echo ""
    echo "Now you can run your Spring Boot app locally:"
    echo "  export SPRING_PROFILES_ACTIVE=dev"
    echo "  export MONGO_URI=mongodb://localhost:27017/demo"
    echo "  export UNLEASH_API_URL=http://localhost:4242/api"
    echo "  ./mvnw spring-boot:run"
}

stop_deps() {
    echo "🛑 Stopping dependencies..."
    docker-compose -f $COMPOSE_FILE down
    echo "✅ Dependencies stopped!"
}

show_logs() {
    echo "📋 Showing logs from dependencies (Ctrl+C to exit)..."
    docker-compose -f $COMPOSE_FILE logs -f
}

show_status() {
    echo "📊 Dependencies Status:"
    docker-compose -f $COMPOSE_FILE ps
}

clean_deps() {
    echo "🧹 Cleaning up dependencies (including volumes)..."
    docker-compose -f $COMPOSE_FILE down -v
    echo "✅ Cleanup complete!"
}

# Main script logic
check_docker

case "${1:-help}" in
    up)
        start_deps
        ;;
    down)
        stop_deps
        ;;
    logs)
        show_logs
        ;;
    status)
        show_status
        ;;
    clean)
        clean_deps
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
