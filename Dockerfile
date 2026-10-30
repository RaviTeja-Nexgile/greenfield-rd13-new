# Leave Tracker — image for the app's own server.
# Node version: package.json "engines" declares ">=22", so this uses the Node 22 LTS line.
# The tag is pinned by release tag only; pin the digest before production use.

# Stage 1: dependencies. The app has no dependencies, so this stage only proves the
# lockfile installs cleanly and gives the production stage a package.json to copy.
FROM node:22-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev --ignore-scripts

# Stage 2: production. The app has no build step: CMD runs src/server.js directly,
# so the image only needs package.json and src/.
FROM node:22-alpine AS production
WORKDIR /app
ENV NODE_ENV=production
# Non-root user with a fixed numeric UID/GID.
RUN addgroup -g 1001 appgroup && adduser -u 1001 -G appgroup -s /bin/sh -D appuser
COPY --from=deps /app/package.json ./package.json
COPY src ./src
USER appuser
# The app reads its port from PORT (src/server.js), defaulting to 3000.
ENV PORT=3000
EXPOSE 3000
# GET /api/health is the route createServer() in src/server.js serves.
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider "http://127.0.0.1:${PORT}/api/health" || exit 1
CMD ["node", "src/server.js"]
