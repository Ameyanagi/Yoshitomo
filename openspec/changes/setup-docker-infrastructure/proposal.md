# Change: Setup Docker Infrastructure and Deployment Pipeline

## Why

The project requires a production-ready deployment infrastructure accessible at https://yoshitomo.rxx.jp/ with fully functional authentication (Google OAuth, Discord OAuth) and database connectivity. Currently, there is no containerization, no Makefile automation, and no deployment configuration.

## What Changes

- Create Docker containerization for the Next.js application with Bun runtime
  - **Dockerfile** for production (multi-stage build, optimized)
  - **Dockerfile.dev** for development (hot reload, faster iteration)
- Setup PostgreSQL database container with persistent storage
- Create separate Docker Compose configurations:
  - **docker-compose.dev.yml** for development (hot reload, source mounts)
  - **docker-compose.yml** for production (optimized, no source mounts)
- Implement comprehensive Makefile for task automation
  - Development: `dev`, `build`, `start`
  - Testing: `test`, `test-watch`, `test-coverage`
  - Database: `db-init`, `db-push`, `db-migrate`, `db-studio`, `db-seed`, `db-reset`
  - Docker dev: `docker-dev-build`, `docker-dev-up`, `docker-dev-down`, `docker-dev-logs`, `docker-dev-logs-follow`
  - Docker prod: `docker-build`, `docker-up`, `docker-down`, `docker-logs`, `docker-logs-follow`, `docker-restart`
  - Code quality: `lint`, `lint-fix`, `format`, `typecheck`, `check`
  - Git hooks: `hooks-install`
- Setup pre-commit hooks for code quality enforcement
  - Husky for git hook management
  - Lint-staged for running checks on staged files only
  - Pre-commit hook runs typecheck and linting
  - Blocks commits with type errors or lint errors
- Verify Cloudflare Tunnel configuration (yoshitomo.rxx.jp already configured)
- Verify OAuth providers (Google, Discord) work in deployed environment
- Ensure database connectivity and migrations work correctly
- Use Bun as the runtime (not Node.js/npm/pnpm)
- Configure ports: App on 6666, DB external debug port on 6670

## Impact

- Affected specs: `deployment`, `development-environment` (new capabilities)
- Affected code: Root-level infrastructure files (Dockerfile, docker-compose.yml, Makefile)
- No application code changes - pure infrastructure setup
- Enables local development, testing, and production deployment workflows
