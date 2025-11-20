# Project Context

## Purpose
**Yoshi!（ヨシ友、ヨシッ！）** - 現場の「よし！」を、最強の安全装置に変える

A next-generation industrial safety management system that digitizes Japan's "指差呼称" (pointing and calling) safety practice. The system uses multimodal AI to verify that workers follow Standard Operating Procedures (SOPs) in real-time, preventing incidents before they occur.

### Core Goals
1. **Prevent workplace accidents** by enforcing proper safety confirmation procedures
2. **Digitize traditional safety practices** ("Yoshi!" verbal confirmations) with AI-powered verification
3. **Provide real-time feedback** to workers during procedures using voice and vision AI
4. **Automate safety logging** to eliminate manual reporting burden
5. **Make safety visible** to management through data-driven insights

### Key Value Proposition
According to Heinrich's Law (1:29:300), behind every serious accident lie 29 minor accidents and 300 near-misses. Yoshi! targets the elimination of these 300 near-misses by:
- Transforming passive "pointing and calling" into an active AI trigger
- Providing instant feedback when procedures are skipped or incorrect
- Creating an automated safety audit trail

## Tech Stack

### Frontend
- **Framework**: Next.js 14+ (App Router) - T3 Stack
- **Language**: TypeScript
- **UI Library**: React 18+
- **Styling**: Tailwind CSS
- **Component Library**: shadcn/ui
- **State Management**: React Query (TanStack Query), Zustand (if needed)
- **Forms**: React Hook Form + Zod validation

### Backend
- **Runtime**: Bun (fast TypeScript/JavaScript runtime)
- **API**: tRPC (type-safe API layer from T3 Stack)
- **Architecture**: Domain-Driven Design (DDD) principles
- **Database ORM**: Prisma
- **Database**: PostgreSQL (recommended for production)
- **Authentication**: NextAuth.js v5
  - Providers: Credentials (email/password), Google OAuth, Discord OAuth

### AI/ML Integration
- **LLM**: SambaNova (fast inference for multimodal analysis)
  - Vision + text analysis for SOP verification
  - Support for various open-source models (Llama, Qwen, etc.)
- **Speech-to-Text**: Browser Web Speech API or local Whisper
- **Text-to-Speech**: Hume AI (empathic voice synthesis)
  - Emotionally intelligent voice feedback
  - Appropriate tone for safety contexts (calm guidance vs. urgent warnings)
  - Natural-sounding Japanese language support
- **Voice Activity Detection**: On-device or lightweight keyword spotting for "Yoshi!" trigger

### Infrastructure
- **Containerization**: Docker + Docker Compose
- **Deployment**: Cloudflare Tunnel to yoshitomo.rxx.jp/
- **Port Configuration**: Random port defined in `.env` file
- **Environment Variables**: `.env` for secrets and configuration

### Development Tools
- **Package Manager & Runtime**: Bun
- **Testing**: Bun's built-in test runner (Jest-compatible API)
- **Linting**: ESLint
- **Formatting**: Prettier
- **Type Checking**: TypeScript strict mode

## Project Conventions

### Code Style
- **Language**: TypeScript with strict mode enabled
- **Naming Conventions**:
  - Files: kebab-case (`user-profile.tsx`, `api-client.ts`)
  - Components: PascalCase (`UserProfile.tsx`, `SafetyCheckButton.tsx`)
  - Functions/Variables: camelCase (`getUserData`, `isCheckComplete`)
  - Constants: UPPER_SNAKE_CASE (`MAX_RETRY_COUNT`, `API_BASE_URL`)
  - Types/Interfaces: PascalCase with descriptive names (`UserProfile`, `SafetyCheckResult`)
- **Formatting**: Prettier with default settings
- **Imports**: Absolute imports using `@/` prefix for src directory
- **Component Structure**: Use functional components with hooks
- **Props**: Define explicit TypeScript interfaces for all component props

### Architecture Patterns

#### Next.js App Structure
```
src/
├── app/                    # Next.js App Router pages
│   ├── (auth)/            # Auth-protected routes
│   ├── (public)/          # Public routes
│   ├── api/               # API routes (if needed beyond tRPC)
│   └── layout.tsx         # Root layout
├── components/            # React components
│   ├── ui/               # shadcn/ui components
│   └── features/         # Feature-specific components
├── server/               # Server-side code (T3 Stack convention)
│   ├── api/              # tRPC routers (Application layer)
│   ├── domain/           # Domain layer (DDD)
│   │   ├── sop/         # SOP aggregate
│   │   │   ├── entities/
│   │   │   ├── value-objects/
│   │   │   ├── repositories/
│   │   │   └── services/
│   │   ├── safety-check/
│   │   └── user/
│   ├── infrastructure/   # Infrastructure layer
│   │   ├── prisma/      # Database implementations
│   │   ├── sambanova/   # SambaNova LLM service adapters
│   │   ├── hume/        # Hume AI TTS service adapters
│   │   └── storage/     # File storage
│   ├── application/     # Application services (use cases)
│   │   ├── sop/
│   │   └── safety-check/
│   ├── auth.ts          # NextAuth configuration
│   └── db.ts            # Prisma client
├── lib/                  # Utility functions
├── hooks/                # Custom React hooks
├── types/                # TypeScript type definitions
└── styles/               # Global styles
```

#### Domain-Driven Design (DDD) Structure

The backend follows DDD principles with clear layer separation:

**Domain Layer** (`server/domain/`)
- **Entities**: Core business objects with identity (e.g., `SOP`, `SafetyCheck`, `User`)
  - Rich domain models with business logic
  - Immutable where possible, mutations through methods
  - Example: `SOP` entity with methods like `addStep()`, `validate()`
- **Value Objects**: Immutable objects without identity (e.g., `StepNumber`, `DangerLevel`)
  - Compare by value, not reference
  - Encapsulate validation logic
  - Example: `DangerLevel` with validation ensuring 1-5 range
- **Repositories**: Interfaces for data access (implementation in infrastructure)
  - Example: `ISOPRepository` interface
- **Domain Services**: Business logic that doesn't fit in entities
  - Example: `SOPStructuringService` for AI-powered SOP parsing

**Application Layer** (`server/application/`)
- **Use Cases**: Orchestrate domain objects to fulfill requests
  - Example: `StructureSOPUseCase`, `VerifySafetyCheckUseCase`
  - Coordinate repositories, domain services, and external services
  - Transaction boundaries
- Keep thin - delegate to domain layer

**Infrastructure Layer** (`server/infrastructure/`)
- **Concrete Implementations**: Database, external APIs, file systems
  - Example: `PrismaSOPRepository` implements `ISOPRepository`
  - SambaNova service adapters for multimodal LLM operations
  - Hume AI service adapters for empathic TTS
- **Adapters**: Convert between domain models and external formats

**Presentation Layer** (`server/api/`)
- **tRPC Routers**: Expose use cases as API endpoints
  - Thin layer - call application services
  - Handle input validation (Zod schemas)
  - Map domain exceptions to API errors

**Key DDD Principles**:
- **Ubiquitous Language**: Use domain terms (SOP, 指差呼称, KY) in code
- **Bounded Contexts**: Separate contexts for SOP management, Safety Checks, User management
- **Aggregates**: SOP is an aggregate root containing Steps and Danger Points
- **Repository Pattern**: Abstract data access behind interfaces
- **Domain Events**: Emit events for important occurrences (e.g., `SafetyCheckFailed`)
- **Separation of Concerns**: UI → API → Application → Domain → Infrastructure

#### Key Patterns
- **API Layer**: Use tRPC for type-safe client-server communication
- **Data Fetching**: React Query (via tRPC) for server state management
- **Authentication**: NextAuth.js middleware for route protection
- **Error Handling**: Centralized error boundaries and toast notifications
- **AI Integration**:
  - Structured prompts stored as constants/templates
  - Multimodal input handling (audio + image + structured SOP data)
  - Response parsing with Zod schemas for type safety

#### SOP (Standard Operating Procedure) Flow
1. **Upload Phase**: User uploads SOP document (image/PDF/text)
2. **Structuring Phase**: LLM parses into structured JSON with steps and danger points
3. **Verification Phase**: User reviews and corrects AI interpretation
4. **Execution Phase**: Real-time monitoring with "Yoshi!" voice triggers
5. **Logging Phase**: Automatic recording of compliance data

### Testing Strategy

**Unit Testing with Bun** (Primary Focus)
- **Test Runner**: Bun's built-in test runner (Jest-compatible API)
- **Command**: `bun test` - fast, native TypeScript support
- **Domain Layer Tests**: Test entities, value objects, and domain services in isolation
  - Example: `sop.entity.test.ts` - test SOP validation, step addition logic
  - Example: `danger-level.vo.test.ts` - test value object validation
  - Pure business logic, no dependencies, very fast
- **Application Layer Tests**: Test use cases with mocked repositories
  - Example: `structure-sop.usecase.test.ts` with mock `ISOPRepository`
  - Verify orchestration logic without hitting real database/APIs
- **Repository Tests**: Test repository implementations with test database
  - Example: `prisma-sop.repository.test.ts` with SQLite in-memory DB
- **Utility Functions**: Test pure functions in `lib/`

**Component & Integration Tests**
- **Component Tests**: React Testing Library for UI components
- **Integration Tests**: Test tRPC routers with mocked application layer
- **API Tests**: Test full tRPC procedures with test database

**E2E Tests**
- **Tool**: Playwright for critical user flows
  - SOP upload and structuring flow
  - Safety check execution flow
  - Authentication flows (password, Google, Discord)

**Testing Guidelines**
- **Coverage Target**: >80% for domain and application layers (safety-critical)
- **Test Structure**: Arrange-Act-Assert pattern
- **Mocking**: Use dependency injection for testability
  - Repositories are interfaces, easily mocked
  - AI services behind adapters, mocked in tests
- **Fast Feedback**: Unit tests should run in <1 second
- **CI/CD**: Run `bun test` on pull requests before merge

**DDD Benefits for Testing**
- **Isolation**: Domain entities tested without database/external deps
- **Clear Boundaries**: Each layer tested independently
- **Dependency Injection**: Easy to mock infrastructure in application tests
- **Fast Tests**: Pure domain logic tests are extremely fast
- **Confidence**: High test coverage on business-critical logic

### Build & Task Automation

**Makefile Structure**
- All common tasks are automated via `Makefile`
- Commands are organized into logical groups:
  - Development: `dev`, `build`, `start`
  - Testing: `test`, `test-watch`, `test-coverage`
  - Database: `db-*` commands for Prisma operations
  - Docker: `docker-*` commands for container management
  - Quality: `lint`, `format`, `typecheck`, `check`
  - Utilities: `clean`, `help`
- Run `make help` to see all available commands
- Use `make` for consistency across development and CI/CD

**Why Make?**
- **Consistency**: Same commands work locally and in CI
- **Simplicity**: No need to remember complex Bun/Docker commands
- **Documentation**: Makefile serves as executable documentation
- **Composability**: Complex workflows built from simple targets
- **Cross-platform**: Works on Linux, macOS, and Windows (with WSL/Git Bash)

### Git Workflow
- **Branching Strategy**: GitHub Flow
  - `main`: Production-ready code
  - `feature/*`: New features
  - `fix/*`: Bug fixes
  - `chore/*`: Maintenance tasks
- **Commit Conventions**: Conventional Commits
  - `feat:` New features
  - `fix:` Bug fixes
  - `docs:` Documentation changes
  - `chore:` Tooling/config changes
  - `refactor:` Code refactoring
  - `test:` Test additions/changes
- **PR Process**: Require code review before merging to main

## Domain Context

### Manufacturing Safety Terminology
- **指差呼称 (Shisa Kosho / Pointing and Calling)**: Japanese safety practice where workers point at equipment and verbally confirm status ("Valve closed, Yoshi!")
- **SOP (Standard Operating Procedure)**: Step-by-step instructions for completing tasks safely
- **KY (危険予知 / Kiken Yochi / Hazard Prediction)**: Risk assessment document identifying potential dangers
- **Heinrich's Law (1:29:300)**: For every major accident, there are 29 minor accidents and 300 near-misses
- **Yoshi (よし!)**: "Good!" or "Check!" - the verbal confirmation used in pointing and calling

### User Personas
1. **Field Workers**: Perform procedures, need hands-free guidance and safety net
2. **Safety Managers**: Monitor compliance, analyze incident patterns, generate reports
3. **New Employees**: Learning procedures, need step-by-step guidance
4. **Veteran Workers**: May skip steps due to overconfidence, need gentle reminders

### Safety Requirements
- **Real-time feedback**: Must provide immediate correction if procedure is incorrect
- **Offline capability**: Should work in areas with poor connectivity (cache SOPs locally)
- **Non-intrusive**: Must not interfere with actual work (hands-free, voice-driven)
- **Audit trail**: Every "Yoshi!" check must be logged with timestamp, user, image, and result
- **Privacy**: Worker monitoring must comply with labor laws, no unnecessary recording

## Important Constraints

### Technical Constraints
- **Deployment**: Must run through Cloudflare Tunnel (no direct public IP)
- **Port**: Application port must be configurable via `.env` (not hardcoded)
- **Mobile Support**: UI must work on smartphones (workers use phones in the field)
- **Hands-free Operation**: Core functionality should work without touching the device
- **Response Time**: AI feedback must be < 3 seconds for good UX

### Business Constraints
- **Hackathon MVP Scope**:
  - SOP upload and structuring (image → JSON via SambaNova LLM)
  - Manual "Yoshi!" button (voice trigger nice-to-have)
  - Single-image capture and AI verification
  - TTS feedback with OK/NG + next step guidance (Hume AI)
  - Basic logging (no advanced analytics yet)
- **Budget**: Use SambaNova and Hume AI APIs efficiently (optimize prompt tokens, cache when possible)

### Regulatory Constraints
- **Data Privacy**: Worker activity logs may contain personal data (GDPR/privacy law compliance)
- **Safety Liability**: System is assistive, not replacement for human judgment
- **Audit Requirements**: Logs must be immutable and traceable for incident investigations

## External Dependencies

### APIs and Services
- **SambaNova API**:
  - Fast inference for multimodal analysis (vision + text)
  - Open-source model support (Llama, Qwen, etc.)
  - SOP structuring and safety verification
- **Hume AI API**:
  - Empathic text-to-speech for voice feedback
  - Emotionally appropriate safety guidance
  - Japanese language support
- **NextAuth Providers**:
  - Google OAuth (needs client ID/secret)
  - Discord OAuth (needs client ID/secret)
- **Cloudflare Tunnel**: For secure deployment without public IP

### Environment Variables Required
```bash
# Database
DATABASE_URL="postgresql://..."

# NextAuth
NEXTAUTH_SECRET="..."
NEXTAUTH_URL="https://yoshitomo.rxx.jp"

# OAuth Providers
GOOGLE_CLIENT_ID="..."
GOOGLE_CLIENT_SECRET="..."
DISCORD_CLIENT_ID="..."
DISCORD_CLIENT_SECRET="..."

# AI Services
SAMBANOVA_API_KEY="..."      # SambaNova API for LLM
HUME_AI_API_KEY="..."        # Hume AI for empathic TTS

# Application
APP_PORT="<random-port>"  # e.g., 3847
NODE_ENV="production"
```

### Infrastructure Dependencies
- **Make**: Task automation (Makefile-based commands)
- **Bun**: Runtime and package manager
- **Docker**: Required for containerization
- **Docker Compose**: For orchestrating services (app + database)
- **Cloudflare Tunnel (cloudflared)**: For deployment
- **PostgreSQL**: Primary database

## Development Setup Notes

### Initial Setup
```bash
# Install dependencies
make install

# Set up environment variables
cp .env.example .env
# Edit .env with your secrets

# Initialize database
make db-init

# Run development server
make dev
```

### Common Make Commands
```bash
# Development
make dev              # Start development server
make build            # Build for production
make start            # Start production server
make test             # Run all tests
make test-watch       # Run tests in watch mode
make test-coverage    # Run tests with coverage report

# Database
make db-init          # Initialize database (generate + push)
make db-generate      # Generate Prisma client
make db-push          # Push schema to database
make db-migrate       # Create and run migrations
make db-studio        # Open Prisma Studio
make db-seed          # Seed database with test data
make db-reset         # Reset database (drop + migrate + seed)

# Docker
make docker-build     # Build Docker images
make docker-up        # Start containers in background
make docker-down      # Stop and remove containers
make docker-logs      # View container logs
make docker-restart   # Restart containers

# Code Quality
make lint             # Run ESLint
make lint-fix         # Fix ESLint issues
make format           # Format code with Prettier
make typecheck        # Run TypeScript type checking
make check            # Run lint + typecheck + test

# Utilities
make clean            # Clean build artifacts and cache
make help             # Show all available commands
```

### Docker Deployment
```bash
# Build and start containers
make docker-up

# View logs
make docker-logs

# Stop containers
make docker-down

# Full rebuild
make docker-build && make docker-up
```

### Cloudflare Tunnel Deployment
- Configure tunnel to route yoshitomo.rxx.jp/ to localhost:$APP_PORT
- Ensure APP_PORT matches the port exposed in docker-compose.yml

## AI Assistant Guidelines

When working on this project:
1. **Safety First**: Any changes to safety-critical logic (AI verification, SOP parsing) require extra scrutiny
2. **Type Safety**: Always use TypeScript types, never use `any`
3. **Use Make Commands**: Always prefer `make` commands over direct Bun/Docker commands
   - Example: Use `make test` instead of `bun test`
   - Example: Use `make docker-up` instead of `docker-compose up -d`
   - Run `make help` to see all available commands
4. **Follow DDD Principles**: Respect layer boundaries (Domain → Application → Infrastructure)
   - Keep domain logic pure (no database/API dependencies)
   - Use repository interfaces, implement in infrastructure layer
   - Business logic belongs in entities/domain services, not tRPC routers
5. **Write Unit Tests**: Always write unit tests for new domain logic
   - Test entities and value objects in isolation
   - Mock repositories in application layer tests
   - Use Bun's built-in test runner (`make test`)
6. **User Context**: Remember workers may be wearing gloves, in noisy environments, or unable to look at screen
7. **Japanese Language**: UI should support Japanese (workers' primary language)
8. **Prompt Engineering**: SOP verification prompts are critical - changes should be tested thoroughly
9. **Logging**: All safety checks must be logged (timestamp, user, step, result, image)
10. **Error Handling**: Never fail silently - workers need to know if verification failed

## Future Roadmap (Post-MVP)
- Voice trigger with "Yoshi!" keyword detection
- Wearable camera support (chest-mounted for better POV)
- Advanced analytics dashboard for safety managers
- Multi-company/multi-site support
- Offline-first architecture with sync
- Gamification (badges for consistent safe behavior)
- Integration with existing ERP/MES systems
