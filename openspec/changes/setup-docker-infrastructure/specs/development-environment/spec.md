# Development Environment Capability Specification

## ADDED Requirements

### Requirement: Makefile Task Automation

The system SHALL provide a Makefile with standardized commands for common development tasks.

#### Scenario: Help command

- **WHEN** developer runs `make help`
- **THEN** all available commands are listed with descriptions
- **AND** commands are organized by category
- **AND** usage examples are provided

#### Scenario: Development server

- **WHEN** developer runs `make dev`
- **THEN** Next.js development server starts
- **AND** hot reload is enabled
- **AND** server listens on port 6666

#### Scenario: Production build

- **WHEN** developer runs `make build`
- **THEN** Next.js production build is created
- **AND** build outputs to .next directory
- **AND** build errors are clearly displayed

### Requirement: Database Management Commands

The system SHALL provide Makefile commands for database operations using Prisma.

#### Scenario: Database initialization

- **WHEN** developer runs `make db-init`
- **THEN** Prisma generates client
- **AND** database schema is pushed to PostgreSQL
- **AND** database is ready for use

#### Scenario: Database migrations

- **WHEN** developer runs `make db-migrate`
- **THEN** Prisma migrations are created and applied
- **AND** migration history is tracked
- **AND** migrations are reversible

#### Scenario: Database studio

- **WHEN** developer runs `make db-studio`
- **THEN** Prisma Studio launches in browser
- **AND** developer can view and edit data
- **AND** changes are reflected in database

#### Scenario: Database reset

- **WHEN** developer runs `make db-reset`
- **THEN** database is dropped
- **AND** migrations are reapplied
- **AND** seed data is loaded

### Requirement: Separate Development and Production Docker Configurations

The system SHALL provide separate Docker Compose configurations for development and production environments.

#### Scenario: Development environment with hot reload in background

- **WHEN** developer runs `make docker-dev-up`
- **THEN** containers start in detached mode (background) using docker-compose.dev.yml
- **AND** source code is mounted as volume for hot reload
- **AND** file changes trigger automatic restart while running in background
- **AND** Bun runs in watch mode
- **AND** developer can view logs with `make docker-dev-logs-follow`

#### Scenario: Production environment optimized

- **WHEN** developer runs `make docker-up`
- **THEN** containers start using docker-compose.yml
- **AND** application runs from built/compiled code
- **AND** no source code volumes are mounted
- **AND** multi-stage Docker build is used for smaller images

### Requirement: Docker Development Commands

The system SHALL provide Makefile commands for Docker container management in development mode.

#### Scenario: Build development Docker images

- **WHEN** developer runs `make docker-dev-build`
- **THEN** Docker images are built using Dockerfile.dev
- **AND** images are optimized for fast iteration
- **AND** build failures are reported clearly

#### Scenario: Build production Docker images

- **WHEN** developer runs `make docker-build`
- **THEN** Docker images are built using multi-stage Dockerfile
- **AND** images are optimized for size and performance
- **AND** build cache is utilized for speed
- **AND** build failures are reported clearly

#### Scenario: Start development containers

- **WHEN** developer runs `make docker-dev-up`
- **THEN** development containers start in detached mode
- **AND** source code is mounted for hot reload
- **AND** startup order is managed with depends_on

#### Scenario: Start production containers

- **WHEN** developer runs `make docker-up`
- **THEN** production containers start in detached mode
- **AND** containers restart on failure
- **AND** startup order is managed with depends_on

#### Scenario: Stop development containers

- **WHEN** developer runs `make docker-dev-down`
- **THEN** development containers are stopped
- **AND** containers are removed
- **AND** volumes are preserved unless explicitly removed

#### Scenario: Stop production containers

- **WHEN** developer runs `make docker-down`
- **THEN** production containers are stopped
- **AND** containers are removed
- **AND** volumes are preserved unless explicitly removed

#### Scenario: View development logs (snapshot)

- **WHEN** developer runs `make docker-dev-logs`
- **THEN** recent logs from development containers are displayed
- **AND** logs are color-coded by container
- **AND** command exits after showing logs

#### Scenario: Follow development logs (real-time)

- **WHEN** developer runs `make docker-dev-logs-follow`
- **THEN** logs from development containers stream in real-time
- **AND** new log entries appear as they occur
- **AND** logs are color-coded by container
- **AND** developer sees hot reload events

#### Scenario: View production logs (snapshot)

- **WHEN** developer runs `make docker-logs`
- **THEN** recent logs from production containers are displayed
- **AND** logs are color-coded by container
- **AND** command exits after showing logs

#### Scenario: Follow production logs (real-time)

- **WHEN** developer runs `make docker-logs-follow`
- **THEN** logs from production containers stream in real-time
- **AND** new log entries appear as they occur
- **AND** logs are color-coded by container

#### Scenario: Restart production containers

- **WHEN** developer runs `make docker-restart`
- **THEN** production containers are stopped and restarted
- **AND** new changes are picked up
- **AND** data persists through restart

### Requirement: Code Quality Commands

The system SHALL provide Makefile commands for code quality checks.

#### Scenario: Linting

- **WHEN** developer runs `make lint`
- **THEN** ESLint checks all TypeScript files
- **AND** errors and warnings are reported
- **AND** exit code reflects pass/fail status

#### Scenario: Lint fixing

- **WHEN** developer runs `make lint-fix`
- **THEN** ESLint auto-fixes issues
- **AND** unfixable issues are reported
- **AND** files are updated in-place

#### Scenario: Code formatting

- **WHEN** developer runs `make format`
- **THEN** Prettier formats all code files
- **AND** formatting matches project style
- **AND** files are updated in-place

#### Scenario: Type checking

- **WHEN** developer runs `make typecheck`
- **THEN** TypeScript type checker runs in no-emit mode
- **AND** type errors are displayed
- **AND** exit code reflects pass/fail status

#### Scenario: Comprehensive check

- **WHEN** developer runs `make check`
- **THEN** linting, type checking, and tests all run
- **AND** all checks must pass for success
- **AND** failures from any check are reported

### Requirement: Testing Commands

The system SHALL provide Makefile commands for running tests with Bun.

#### Scenario: Run all tests

- **WHEN** developer runs `make test`
- **THEN** Bun test runner executes all tests
- **AND** test results are displayed
- **AND** exit code reflects pass/fail status

#### Scenario: Watch mode

- **WHEN** developer runs `make test-watch`
- **THEN** tests run in watch mode
- **AND** tests rerun on file changes
- **AND** only affected tests rerun

#### Scenario: Coverage report

- **WHEN** developer runs `make test-coverage`
- **THEN** tests run with coverage collection
- **AND** coverage report is generated
- **AND** uncovered lines are highlighted

### Requirement: Dependency Management

The system SHALL provide Makefile commands for dependency installation with Bun.

#### Scenario: Install dependencies

- **WHEN** developer runs `make install`
- **THEN** Bun installs all dependencies from package.json
- **AND** lockfile is updated if needed
- **AND** post-install scripts run (e.g., Prisma generate)

#### Scenario: Clean build artifacts

- **WHEN** developer runs `make clean`
- **THEN** .next directory is removed
- **AND** node_modules is removed
- **AND** build cache is cleared
- **AND** developer can start fresh

### Requirement: Pre-commit Hooks for Code Quality

The system SHALL enforce code quality standards using pre-commit hooks that run type checking and linting.

#### Scenario: Pre-commit hook installation

- **WHEN** developer runs `make install` or `make hooks-install`
- **THEN** husky pre-commit hooks are installed
- **AND** hooks are configured in .husky/pre-commit
- **AND** lint-staged is configured in package.json

#### Scenario: Pre-commit hook prevents type errors

- **WHEN** developer attempts to commit code with TypeScript type errors
- **THEN** pre-commit hook runs type checking
- **AND** commit is blocked with error message
- **AND** developer must fix type errors before committing

#### Scenario: Pre-commit hook prevents lint errors

- **WHEN** developer attempts to commit code with ESLint errors
- **THEN** pre-commit hook runs linting
- **AND** commit is blocked with error message
- **AND** developer must fix lint errors before committing

#### Scenario: Pre-commit hook allows clean code

- **WHEN** developer commits code with no type errors or lint errors
- **THEN** pre-commit hook runs successfully
- **AND** commit proceeds normally
- **AND** code quality is maintained

#### Scenario: Lint-staged only checks staged files

- **WHEN** developer stages files for commit
- **THEN** pre-commit hook only checks staged files
- **AND** unstaged files are not checked
- **AND** commit process is fast

### Requirement: Bun Runtime

The system SHALL use Bun as the JavaScript/TypeScript runtime instead of Node.js.

#### Scenario: Development with Bun

- **WHEN** developer runs development commands
- **THEN** Bun executes JavaScript/TypeScript
- **AND** native TypeScript support is used
- **AND** performance is faster than Node.js

#### Scenario: Testing with Bun

- **WHEN** developer runs tests
- **THEN** Bun's built-in test runner is used
- **AND** Jest-compatible API works
- **AND** tests run faster than Node.js equivalents
