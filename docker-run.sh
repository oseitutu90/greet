#!/bin/bash

# Docker Compose management script for the Greet application
# This script helps you run the entire application stack with all dependencies

set -e

COMPOSE_FILE="docker-compose.yml"

show_help() {
    echo "🐳 Greet Application Docker Management Script"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  up          Start all services (build if needed)"
    echo "  down        Stop and remove all services"
    echo "  build       Build the application image"
    echo "  logs        Show logs from all services"
    echo "  logs-app    Show logs from the greet application only"
    echo "  status      Show status of all services"
    echo "  clean       Stop services and remove volumes (clean slate)"
    echo "  restart     Restart all services"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 up       # Start everything"
    echo "  $0 logs-app # Watch application logs"
    echo "  $0 down     # Stop everything"
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

build_app() {
    echo "🔨 Building the Spring Boot application..."
    ./mvnw clean package -DskipTests
    
    if [ $? -eq 0 ]; then
        echo "✅ Application built successfully!"
    else
        echo "❌ Application build failed!"
        exit 1
    fi
}

start_services() {
    echo "🚀 Starting all services with Docker Compose..."
    echo "📝 This will start:"
    echo "   - MongoDB (port 27017)"
    echo "   - PostgreSQL for Unleash (internal)"
    echo "   - Unleash Server (port 4242)"
    echo "   - Greet Application (port 8080)"
    echo ""
    
    build_app
    
    docker-compose -f $COMPOSE_FILE up -d
    
    echo ""
    echo "✅ Services started! Waiting for health checks..."
    echo "📍 Application: http://localhost:8080"
    echo "🔍 Health check: http://localhost:8080/actuator/health"
    echo "👋 Greet endpoint: http://localhost:8080/greet"
    echo "🚩 Unleash UI: http://localhost:4242 (admin/unleash)"
    echo ""
    echo "📊 Use '$0 logs' to see all logs or '$0 logs-app' for app logs only"
}

stop_services() {
    echo "🛑 Stopping all services..."
    docker-compose -f $COMPOSE_FILE down
    echo "✅ All services stopped!"
}

show_logs() {
    echo "📋 Showing logs from all services (Ctrl+C to exit)..."
    docker-compose -f $COMPOSE_FILE logs -f
}

show_app_logs() {
    echo "📋 Showing logs from greet application (Ctrl+C to exit)..."
    docker-compose -f $COMPOSE_FILE logs -f greet-app
}

show_status() {
    echo "📊 Service Status:"
    docker-compose -f $COMPOSE_FILE ps
}

clean_all() {
    echo "🧹 Cleaning up everything (including volumes)..."
    docker-compose -f $COMPOSE_FILE down -v
    docker-compose -f $COMPOSE_FILE down --rmi local 2>/dev/null || true
    echo "✅ Cleanup complete!"
}

restart_services() {
    echo "🔄 Restarting all services..."
    docker-compose -f $COMPOSE_FILE restart
    echo "✅ Services restarted!"
}

# Main script logic
check_docker

case "${1:-help}" in
    up)
        start_services
        ;;
    down)
        stop_services
        ;;
    build)
        build_app
        ;;
    logs)
        show_logs
        ;;
    logs-app)
        show_app_logs
        ;;
    status)
        show_status
        ;;
    clean)
        clean_all
        ;;
    restart)
        restart_services
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
