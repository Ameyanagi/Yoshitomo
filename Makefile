.PHONY: help install clean dev build start test test-watch test-coverage \
	db-init db-push db-migrate db-studio db-seed db-reset \
	docker-dev-build docker-dev-up docker-dev-down docker-dev-logs docker-dev-logs-follow docker-dev-restart \
	docker-build docker-up docker-down docker-logs docker-logs-follow docker-restart \
	lint lint-fix format typecheck check \
	hooks-install

# Default target
.DEFAULT_GOAL := help

##@ General

help: ## Display this help message
	@echo "Yoshi! - Makefile Commands"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

install: ## Install dependencies with Bun
	bun install
	@echo "✓ Dependencies installed"

clean: ## Clean build artifacts and dependencies
	rm -rf .next
	rm -rf node_modules
	rm -rf dist
	rm -rf build
	@echo "✓ Cleaned build artifacts"

##@ Development

dev: ## Start development server (port 6666)
	bun run dev

build: ## Build Next.js application for production
	bun run build

start: ## Start production server
	bun run start

##@ Testing

test: ## Run all tests
	bun test

test-watch: ## Run tests in watch mode
	bun test --watch

test-coverage: ## Run tests with coverage report
	bun test --coverage

##@ Database

db-init: ## Initialize database (generate client + push schema)
	bunx prisma generate
	bunx prisma db push
	@echo "✓ Database initialized"

db-push: ## Push Prisma schema to database
	bunx prisma db push

db-migrate: ## Create and apply Prisma migrations
	bunx prisma migrate dev

db-studio: ## Open Prisma Studio (database GUI)
	bunx prisma studio

db-seed: ## Seed database with initial data
	bunx prisma db seed

db-reset: ## Reset database (drop, migrate, seed)
	bunx prisma migrate reset

##@ Docker Development

docker-dev-build: ## Build development Docker images
	docker compose -f docker-compose.dev.yml build

docker-dev-up: ## Start development containers (with hot reload)
	docker compose -f docker-compose.dev.yml up -d
	@echo "✓ Development containers started"
	@echo "  App: http://localhost:6666"
	@echo "  DB: localhost:6670"

docker-dev-down: ## Stop development containers
	docker compose -f docker-compose.dev.yml down

docker-dev-logs: ## View development container logs (snapshot)
	docker compose -f docker-compose.dev.yml logs

docker-dev-logs-follow: ## Follow development container logs (real-time)
	docker compose -f docker-compose.dev.yml logs -f

docker-dev-restart: ## Restart development containers
	docker compose -f docker-compose.dev.yml restart

##@ Docker Production

docker-build: ## Build production Docker images
	docker compose build

docker-up: ## Start production containers
	docker compose up -d
	@echo "✓ Production containers started"
	@echo "  App: http://localhost:6666"
	@echo "  DB: localhost:6670"

docker-down: ## Stop production containers
	docker compose down

docker-logs: ## View production container logs (snapshot)
	docker compose logs

docker-logs-follow: ## Follow production container logs (real-time)
	docker compose logs -f

docker-restart: ## Restart production containers
	docker compose restart

##@ Code Quality

lint: ## Run ESLint
	bun run lint

lint-fix: ## Run ESLint with auto-fix
	bun run lint:fix

format: ## Format code with Prettier
	bun run format:write

typecheck: ## Run TypeScript type checking
	bun run typecheck

check: ## Run all checks (lint + typecheck + tests)
	bun run check
	bun test

##@ Git Hooks

hooks-install: ## Install pre-commit hooks (husky + lint-staged)
	bun add -D husky lint-staged
	bunx husky init
	@echo "✓ Git hooks installed"
