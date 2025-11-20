# Deployment Capability Specification

## ADDED Requirements

### Requirement: Docker Containerization

The system SHALL be containerized using Docker with Bun runtime for consistent deployment across environments.

#### Scenario: Application container builds successfully

- **WHEN** developer runs `make docker-build`
- **THEN** Docker image is created with Bun runtime
- **AND** all application dependencies are included
- **AND** build completes without errors

#### Scenario: Dockerignore configuration

- **WHEN** Docker build runs
- **THEN** .dockerignore file excludes node_modules, .next, .git, .env
- **AND** generated/ directory (Prisma client) is ignored
- **AND** Prisma client is generated fresh inside container during build
- **AND** build is faster due to ignored files

#### Scenario: Multi-container orchestration

- **WHEN** developer runs `make docker-up`
- **THEN** both application and database containers start
- **AND** containers can communicate over Docker network
- **AND** application waits for database readiness

### Requirement: PostgreSQL Database Container

The system SHALL provide a PostgreSQL database container with persistent storage.

#### Scenario: Database persistence

- **WHEN** containers are stopped and restarted
- **THEN** database data is preserved
- **AND** migrations remain applied
- **AND** no data loss occurs

#### Scenario: Debug access

- **WHEN** developer needs to inspect database
- **THEN** PostgreSQL is accessible on host port 6670
- **AND** connection uses standard PostgreSQL tools
- **AND** credentials match .env configuration

### Requirement: Cloudflare Tunnel Deployment

The system SHALL be accessible via HTTPS at yoshitomo.rxx.jp through Cloudflare Tunnel.

#### Scenario: HTTPS access

- **WHEN** user navigates to https://yoshitomo.rxx.jp
- **THEN** application loads successfully
- **AND** valid SSL certificate is presented
- **AND** requests are routed to localhost:6666

#### Scenario: Tunnel configuration

- **WHEN** Cloudflare Tunnel is configured
- **THEN** tunnel routes yoshitomo.rxx.jp to localhost:6666
- **AND** tunnel persists across restarts
- **AND** configuration is documented

### Requirement: OAuth Provider Integration

The system SHALL support OAuth authentication via Google and Discord in deployed environment.

#### Scenario: Google OAuth in production

- **WHEN** user clicks "Sign in with Google" at yoshitomo.rxx.jp
- **THEN** user is redirected to Google OAuth consent screen
- **AND** after consent, user is redirected back to yoshitomo.rxx.jp/api/auth/callback/google
- **AND** session is created successfully

#### Scenario: Discord OAuth in production

- **WHEN** user clicks "Sign in with Discord" at yoshitomo.rxx.jp
- **THEN** user is redirected to Discord OAuth consent screen
- **AND** after consent, user is redirected back to yoshitomo.rxx.jp/api/auth/callback/discord
- **AND** session is created successfully

#### Scenario: OAuth callbacks configured

- **WHEN** OAuth providers are configured
- **THEN** callback URLs include both localhost:6666 and yoshitomo.rxx.jp
- **AND** both environments work correctly
- **AND** no authentication errors occur

### Requirement: Environment Configuration

The system SHALL load configuration from environment variables for both local and production deployment.

#### Scenario: Environment variable loading

- **WHEN** application starts in Docker container
- **THEN** all required environment variables are loaded
- **AND** missing required variables cause startup failure with clear error
- **AND** .env file is not committed to version control

#### Scenario: Port configuration

- **WHEN** application starts
- **THEN** application listens on port 6666
- **AND** PostgreSQL exposes port 6670 for debugging
- **AND** internal container networking uses standard ports
