# Yoshi!（ヨシ友、ヨシッ！）

現場の「よし！」を、最強の安全装置に変える

A next-generation industrial safety management system that digitizes Japan's "指差呼称" (pointing and calling) safety practice using multimodal AI.

Built with the [T3 Stack](https://create.t3.gg/) using Bun runtime.

## Quick Start

### Prerequisites

- [Bun](https://bun.sh/) (v1.1.42+)
- [Docker](https://www.docker.com/) and Docker Compose
- PostgreSQL 17 (or use Docker)

### Development Setup

1. **Install dependencies:**

   ```bash
   make install
   # or: bun install
   ```

2. **Configure environment:**

   ```bash
   cp .env.example .env
   # Edit .env with your credentials
   ```

3. **Run with Docker (Recommended):**

   ```bash
   # Development mode with hot reload
   make docker-dev-build
   make docker-dev-up

   # View logs
   make docker-dev-logs

   # Stop containers
   make docker-dev-down
   ```

4. **Or run locally:**

   ```bash
   # Start PostgreSQL first (or use Docker)
   make db-init      # Initialize database
   make dev          # Start dev server on port 6666
   ```

5. **Access the application:**
   - App: http://localhost:6666
   - Database (debug): localhost:6670

### Available Commands

Run `make help` to see all available commands. Key commands:

**Development:**

- `make dev` - Start development server
- `make build` - Build for production
- `make test` - Run tests
- `make typecheck` - Type checking

**Docker Development:**

- `make docker-dev-build` - Build dev containers
- `make docker-dev-up` - Start dev containers (hot reload)
- `make docker-dev-down` - Stop dev containers
- `make docker-dev-logs` - View container logs

**Docker Production:**

- `make docker-build` - Build production containers
- `make docker-up` - Start production containers
- `make docker-down` - Stop production containers

**Database:**

- `make db-init` - Initialize database
- `make db-push` - Push schema changes
- `make db-migrate` - Create migrations
- `make db-studio` - Open Prisma Studio

**Code Quality:**

- `make lint` - Run ESLint
- `make format` - Format with Prettier
- `make check` - Run all checks

### Pre-commit Hooks

The project uses Husky and lint-staged for pre-commit hooks. Hooks are automatically installed during `make install`. They will:

- Run ESLint and Prettier on staged files
- Run TypeScript type checking
- Block commits with type errors or lint errors

To manually install hooks:

```bash
make hooks-install
```

## Deployment

### Production Deployment

The application is deployed at https://yoshitomo.rxx.jp via Cloudflare Tunnel.

1. **Build and start production containers:**

   ```bash
   make docker-build
   make docker-up
   ```

2. **Configure Cloudflare Tunnel** to route yoshitomo.rxx.jp → localhost:6666

3. **Environment variables:** Ensure `.env` has production values:
   ```bash
   NEXTAUTH_URL=https://yoshitomo.rxx.jp
   DATABASE_URL=postgresql://postgres:password@db:5432/yoshi
   # Add OAuth credentials, API keys, etc.
   ```

### OAuth Configuration

Add both development and production callback URLs to OAuth providers:

**Google OAuth Console:**

- Authorized redirect URIs:
  - `http://localhost:6666/api/auth/callback/google`
  - `https://yoshitomo.rxx.jp/api/auth/callback/google`

**Discord Developer Portal:**

- Redirect URIs:
  - `http://localhost:6666/api/auth/callback/discord`
  - `https://yoshitomo.rxx.jp/api/auth/callback/discord`

## Tech Stack

- **Runtime:** Bun (JavaScript/TypeScript)
- **Framework:** Next.js 15 (App Router, Turbopack)
- **Database:** PostgreSQL 17 + Prisma ORM
- **Authentication:** NextAuth.js v5 (Google, Discord, Credentials)
- **API:** tRPC
- **Styling:** Tailwind CSS + shadcn/ui
- **AI/ML:**
  - SambaNova API (Llama-4-Maverick, Whisper-Large-v3)
  - Hume AI (Empathic TTS with Fumiko voice)

## Troubleshooting

**Docker containers won't start:**

- Check if ports 6666 and 6670 are available
- Run `make docker-dev-logs` to see error messages
- Ensure `.env` file exists and is properly configured

**Database connection issues:**

- Verify PostgreSQL is running: `docker ps`
- Check DATABASE_URL in `.env`
- Try `make db-reset` to reset database

**OAuth errors:**

- Verify callback URLs match exactly in provider consoles
- Check NEXTAUTH_URL matches your deployment URL
- Ensure NEXTAUTH_SECRET is set (generate with `openssl rand -base64 32`)

**Hot reload not working:**

- Ensure using development setup: `make docker-dev-up`
- Check volume mounts in docker-compose.dev.yml
- Try `make docker-dev-restart`

## What's next? How do I make an app with this?

We try to keep this project as simple as possible, so you can start with just the scaffolding we set up for you, and add additional things later when they become necessary.

If you are not familiar with the different technologies used in this project, please refer to the respective docs. If you still are in the wind, please join our [Discord](https://t3.gg/discord) and ask for help.

- [Next.js](https://nextjs.org)
- [NextAuth.js](https://next-auth.js.org)
- [Prisma](https://prisma.io)
- [Drizzle](https://orm.drizzle.team)
- [Tailwind CSS](https://tailwindcss.com)
- [tRPC](https://trpc.io)

## Learn More

To learn more about the [T3 Stack](https://create.t3.gg/), take a look at the following resources:

- [Documentation](https://create.t3.gg/)
- [Learn the T3 Stack](https://create.t3.gg/en/faq#what-learning-resources-are-currently-available) — Check out these awesome tutorials

You can check out the [create-t3-app GitHub repository](https://github.com/t3-oss/create-t3-app) — your feedback and contributions are welcome!

## How do I deploy this?

Follow our deployment guides for [Vercel](https://create.t3.gg/en/deployment/vercel), [Netlify](https://create.t3.gg/en/deployment/netlify) and [Docker](https://create.t3.gg/en/deployment/docker) for more information.
