# Leave Tracker — image for your own server.
# Node 22: the version package.json "engines" declares (">=22").
# The base tag is a release tag; the digest is still to be pinned (unchecked).

# Stage 1: dependencies. package.json lists no dependencies, so npm ci only
# validates the lockfile and creates no node_modules folder.
FROM node:22-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

# Stage 2: production. The app has no build step: the server runs straight from
# src/server.js, so the source is copied from the build context.
FROM node:22-alpine AS production
WORKDIR /app
ENV NODE_ENV=production
# A non-root user with a fixed numeric UID and GID.
RUN addgroup -g 1001 appgroup && adduser -u 1001 -G appgroup -s /bin/sh -D appuser
COPY --from=deps /app/package.json ./package.json
COPY src ./src
USER appuser
# The server reads its port from PORT and defaults to 3000.
EXPOSE 3000
# GET /api/health answers 200 with {"ok":true}.
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/api/health || exit 1
CMD ["node", "src/server.js"]
