# Implementation Tasks: Docker Infrastructure Setup

## 1. Docker Configuration

- [x] 1.1 Create Dockerfile with Bun runtime (multi-stage build for production)
- [x] 1.2 Create Dockerfile.dev with Bun runtime (simpler, optimized for dev)
- [x] 1.3 Create .dockerignore file (ignore node_modules, .next, generated/, .git, .env)
- [x] 1.4 Ensure Prisma generated files are ignored (will be generated in container)
- [x] 1.5 Create docker-compose.dev.yml for development (hot reload, source mounts)
- [x] 1.6 Create docker-compose.yml for production (optimized, no source mounts)
- [x] 1.7 Configure volume mounts for database persistence in both files
- [x] 1.8 Set up environment variable handling for containers
- [x] 1.9 Ensure Prisma generate runs during Docker build process

## 2. Makefile Creation

- [x] 2.1 Create Makefile with help target
- [x] 2.2 Add development commands (dev, build, start)
- [x] 2.3 Add testing commands (test, test-watch, test-coverage)
- [x] 2.4 Add database commands (db-init, db-push, db-migrate, db-studio, db-seed, db-reset)
- [x] 2.5 Add Docker development commands (docker-dev-build, docker-dev-up, docker-dev-down, docker-dev-logs, docker-dev-logs-follow)
- [x] 2.6 Add Docker production commands (docker-build, docker-up, docker-down, docker-logs, docker-logs-follow, docker-restart)
- [x] 2.7 Add code quality commands (lint, lint-fix, format, typecheck, check)
- [x] 2.8 Add utility commands (clean, install)
- [x] 2.9 Add git hooks command (hooks-install) for setting up pre-commit hooks

## 2.5. Pre-commit Hooks Setup

- [x] 2.5.1 Create .husky directory structure
- [x] 2.5.2 Create pre-commit hook script that runs typecheck and lint
- [x] 2.5.3 Add husky to package.json devDependencies
- [x] 2.5.4 Add lint-staged to package.json devDependencies
- [x] 2.5.5 Configure lint-staged in package.json for TypeScript files (excludes generated/ Prisma client)
- [x] 2.5.6 Add prepare script to package.json for husky installation
- [ ] 2.5.7 Test pre-commit hook blocks commits with type errors
- [ ] 2.5.8 Test pre-commit hook blocks commits with lint errors

## 3. Local Testing

- [x] 3.1 Test `make install` - verify dependencies install with Bun
- [x] 3.2 Test `make docker-dev-build` - verify dev images build successfully
- [x] 3.3 Test `make docker-dev-up` - verify dev containers start with hot reload in background
- [ ] 3.4 Test hot reload works - change a file and verify auto-reload
- [x] 3.5 Test `make docker-build` - verify production images build successfully
- [x] 3.6 Test `make docker-up` - verify production containers start
- [ ] 3.7 Test `make db-push` - verify Prisma migrations work
- [x] 3.8 Verify app accessible at http://localhost:6666
- [x] 3.9 Verify database accessible at localhost:6670 for debugging
- [ ] 3.10 Test container restart preserves database data

## 4. OAuth Configuration Verification

- [ ] 4.1 Verify Google OAuth callback URLs include both localhost:6666 and yoshitomo.rxx.jp
- [ ] 4.2 Verify Discord OAuth callback URLs include both localhost:6666 and yoshitomo.rxx.jp
- [ ] 4.3 Test Google OAuth login flow locally (http://localhost:6666)
- [ ] 4.4 Test Discord OAuth login flow locally (http://localhost:6666)

## 5. Cloudflare Tunnel Verification

- [ ] 5.1 Verify Cloudflare Tunnel is installed and running
- [ ] 5.2 Confirm tunnel routes yoshitomo.rxx.jp → localhost:6666
- [ ] 5.3 Test HTTPS access at https://yoshitomo.rxx.jp
- [ ] 5.4 Verify SSL certificate works correctly
- [ ] 5.5 Document tunnel status and configuration

## 6. Production OAuth Testing

- [ ] 6.1 Update NEXTAUTH_URL to https://yoshitomo.rxx.jp in .env
- [ ] 6.2 Test Google OAuth login via yoshitomo.rxx.jp
- [ ] 6.3 Test Discord OAuth login via yoshitomo.rxx.jp
- [ ] 6.4 Verify session persistence works

## 7. Documentation

- [ ] 7.1 Update README with Docker setup instructions
- [ ] 7.2 Document Makefile commands
- [ ] 7.3 Document Cloudflare Tunnel setup process
- [ ] 7.4 Add troubleshooting section for common issues

## 8. Final Validation

- [ ] 8.1 Run through validation checklist in design.md
- [ ] 8.2 Verify all OAuth providers work in both environments
- [ ] 8.3 Verify database migrations complete successfully
- [ ] 8.4 Test full deployment flow from clean state
- [x] 8.5 Confirm no application code was modified (infrastructure only)

## Dependencies

- Tasks 1.x must complete before 3.x (need Docker files to build)
- Task 3.3 must complete before 3.4 (containers must be running)
- Tasks 3.x must complete before 4.x (need local app running)
- Tasks 4.x should complete before 5.x (verify OAuth locally first)
- Tasks 5.x must complete before 6.x (need tunnel for production URLs)

## Parallelizable Work

- Tasks 1.x and 2.x can be done in parallel
- Tasks 4.1 and 4.2 can be done in parallel (different providers)
- Tasks 6.2 and 6.3 can be done in parallel (different providers)
