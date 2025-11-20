# Design: Docker Infrastructure and Deployment

## Context

Setting up containerized infrastructure for Yoshi! safety management system. The application is built with T3 Stack (Next.js, tRPC, Prisma, NextAuth) and must be accessible via Cloudflare Tunnel at yoshitomo.rxx.jp with ports 6666 (app) and 6670 (db debug).

Reference: https://create.t3.gg/en/deployment/docker

### Constraints

- Must use Bun runtime (not Node.js)
- OAuth callbacks must work with both localhost:6666 and yoshitomo.rxx.jp
- Database must persist data across container restarts
- No code changes - infrastructure only

### Stakeholders

- Developers: Need consistent local development environment
- DevOps: Need reproducible deployment process
- End users: Need reliable HTTPS access

## Goals / Non-Goals

### Goals

- Containerized application with Bun runtime
- PostgreSQL database with persistent storage
- Makefile automation for common tasks (dev, build, test, docker commands)
- Cloudflare Tunnel configuration for HTTPS access
- Verified OAuth functionality (Google, Discord)
- Database migrations working in containerized environment

### Non-Goals

- CI/CD pipeline automation (future work)
- Multi-stage Docker builds optimization (can add later)
- Health checks and monitoring (out of scope for MVP)
- Application code changes

## Decisions

### Decision: Use Multi-Container Docker Compose Setup with Separate Dev/Prod Configs

**Rationale:**

- Separate concerns: app container + db container
- Different configs for dev vs prod:
  - **Development (`docker-compose.dev.yml`)**: Hot reload, volume mounts for source code, faster iteration
  - **Production (`docker-compose.yml`)**: Optimized builds, no source mounts, production settings
- Easier local development (can run just DB for development)
- Standard pattern for T3 Stack applications
- Allows independent scaling in future

**Development vs Production Differences:**

- **Dev**: Bind mounts for source code, enables hot reload with Bun's watch mode
- **Dev**: Runs in detached mode (background) - use `make docker-dev-logs-follow` to view output
- **Dev**: Simpler build process, no optimization
- **Prod**: Multi-stage Docker build for smaller images
- **Prod**: No source code mounts, runs compiled/built code only
- **Prod**: Also runs in detached mode (background)
- **Both**: Share same database configuration and network setup
- **Both**: Containers run in background, logs accessible via `make docker-*-logs` commands

**Alternatives considered:**

- Single compose file with overrides: Rejected (less clear, harder to maintain)
- Single container with embedded DB: Rejected (not production-ready, harder to debug)
- External managed DB: Rejected (added complexity, costs for hackathon MVP)

### Decision: Use Bun-specific Dockerfile

**Rationale:**

- Project is configured to use Bun (see openspec/project.md)
- Faster builds and smaller images than Node
- Native TypeScript support

**Implementation:**

```dockerfile
FROM oven/bun:1 as base
# ... (following T3 Docker guide adapted for Bun)
```

### Decision: Makefile for Task Automation

**Rationale:**

- Cross-platform consistency (Linux, macOS, Windows WSL)
- Single source of truth for commands
- Easier onboarding (developers run `make help`)
- Matches project.md specification

**Commands structure:**

- Development: `dev`, `build`, `start`
- Testing: `test`, `test-watch`, `test-coverage`
- Database: `db-*` commands
- Docker: `docker-*` commands
- Quality: `lint`, `format`, `typecheck`, `check`

### Decision: Cloudflare Tunnel for Deployment

**Rationale:**

- No need for public IP or port forwarding
- Built-in HTTPS with Cloudflare certificate
- Easy setup for yoshitomo.rxx.jp domain
- Secure tunneling to localhost:6666

**Note:** yoshitomo.rxx.jp is already configured in Cloudflare. Only need to ensure tunnel routes to localhost:6666.

**Configuration:**

```yaml
# Tunnel config to route yoshitomo.rxx.jp → localhost:6666
# (Cloudflare DNS already configured - verify tunnel target only)
```

### Decision: Volume Mounts for Database Persistence

**Rationale:**

- Data survives container restarts
- Easy backup/restore
- Standard Docker pattern

**Implementation:**

```yaml
volumes:
  postgres-data:
    driver: local
```

## Technical Details

### Port Configuration

- **6666**: Application (internal container port 3000 mapped to host 6666)
- **6670**: PostgreSQL debug access (internal 5432 mapped to host 6670)
- **5432**: PostgreSQL internal (container-to-container communication)

### Environment Variables

All sensitive data in `.env` (gitignored):

- `DATABASE_URL=postgresql://postgres:password@db:5432/yoshi`
- `NEXTAUTH_URL=https://yoshitomo.rxx.jp` (production) or `http://localhost:6666` (dev)
- OAuth credentials (GOOGLE_CLIENT_ID, DISCORD_CLIENT_ID, etc.)
- AI API keys (SAMBANOVA_API_KEY, HUME_AI_API_KEY)

### Database Connection String Pattern

- **Local dev**: `postgresql://postgres:password@localhost:5432/yoshi`
- **Docker Compose**: `postgresql://postgres:password@db:5432/yoshi` (db is service name)
- **Prisma**: Auto-detects from `DATABASE_URL` environment variable

## Risks / Trade-offs

### Risk: OAuth Callback URL Mismatch

**Impact**: Authentication will fail if URLs don't match provider configuration
**Mitigation**:

- Document both localhost and production URLs in .env.example
- Verify both URLs are added to Google/Discord OAuth consoles
- Test authentication in both environments before marking complete

### Risk: Database Connection Issues

**Impact**: App fails to start if database not ready
**Mitigation**:

- Use `depends_on` in docker-compose (db must start before app)
- Add connection retry logic in Prisma (default behavior)
- Document `make docker-logs` for debugging

### Risk: Cloudflare Tunnel Configuration Complexity

**Impact**: Developer may struggle with tunnel setup
**Mitigation**:

- Provide clear documentation in README
- Include tunnel config example
- Test end-to-end before marking complete

## Migration Plan

### Initial Setup (Clean Installation)

1. Create Dockerfile (Bun-based)
2. Create docker-compose.yml (app + db services)
3. Create Makefile with all commands
4. Test locally: `make docker-up` → verify app starts
5. Run Prisma migrations: `make db-push`
6. Configure Cloudflare Tunnel
7. Test OAuth providers work
8. Document in README

### Rollback

N/A (no existing deployment to roll back from)

## Validation Checklist

- [ ] `make docker-up` starts both containers
- [ ] App accessible at http://localhost:6666
- [ ] Database accessible at localhost:6670 for debugging
- [ ] Prisma migrations run successfully
- [ ] Google OAuth login works
- [ ] Discord OAuth login works
- [ ] Cloudflare Tunnel routes yoshitomo.rxx.jp → localhost:6666
- [ ] HTTPS access works at yoshitomo.rxx.jp
- [ ] OAuth works with production URL (yoshitomo.rxx.jp)
- [ ] Database data persists across container restarts
- [ ] `make help` lists all available commands
- [ ] `make test` runs successfully

## Open Questions

None - all requirements are clear from user request and project.md specification.
