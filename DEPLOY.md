# Deploying Leave Tracker to your own server with Docker

These files build and run the app on a server you control. Nothing here deploys by
itself: the pipeline's production job waits for a person.

| File | What it is |
| --- | --- |
| `Dockerfile` | Two stages on `node:22-alpine` (matches `package.json` engines `>=22`). The `production` stage runs as non-root UID/GID 1001, listens on `PORT` (default 3000) and health-checks `GET /api/health`. |
| `.dockerignore` | Keeps `.git`, `.env*`, `node_modules`, `.nexgile`, `test` and docs out of the build context. |
| `docker-compose.prod.yml` | One `app` service building the `production` stage, publishing `${APP_PORT:-3000}:3000`. |
| `.env.example` | The variable names the compose file reads. Copy it to `.env` on the server; `.env` is git-ignored. |
| `.github/workflows/deploy.yml` | CI (`npm test`, Trivy scan) and a manual, reviewer-gated deploy over SSH. |

## Run it on the server by hand

```sh
git clone <your repository> leave-tracker && cd leave-tracker
cp .env.example .env        # then set APP_PORT if 3000 is taken
docker compose -f docker-compose.prod.yml up -d --build
curl -fsS http://127.0.0.1:3000/api/health   # {"ok":true}
```

Stop it with `docker compose -f docker-compose.prod.yml down`.

## Manual settings you must make (the YAML does not create them)

1. **GitHub environment `production`** — Settings → Environments → New environment
   → `production`. Add **Required reviewers** (yourself or a team). Without this the
   manual trigger is the only gate. Some plans do not offer required reviewers for
   private repositories.
2. **Repository secrets** (Settings → Secrets and variables → Actions):
   - `DEPLOY_SSH_HOST` — the server's host name or IP.
   - `DEPLOY_SSH_USER` — the SSH user that may run `docker`.
   - `DEPLOY_SSH_KEY` — the private key for that user (never commit it).
   - `DEPLOY_SSH_KNOWN_HOSTS` — the server's line from `ssh-keyscan <host>`.
   - `GITHUB_TOKEN` is provided by GitHub; the workflow uses it to push and pull the
     image from `ghcr.io`.
3. **Repository variables** (optional):
   - `APP_PORT` — the host port the health check probes on the server (defaults to 3000).
   - `DEPLOY_DIR` — the absolute path of the repository checkout on the server
     (defaults to `~/leave-tracker`). The workflow `cd`s into it before running
     `docker compose`, because an SSH command starts in the user's home directory.
4. **Server prerequisites** — Docker with the Compose plugin, the repository checked
   out in the deploy directory (`~/leave-tracker` unless `DEPLOY_DIR` says otherwise),
   and a `.env` file in that same directory next to `docker-compose.prod.yml`. The
   workflow writes `deploy/current-tag` there after each deploy and copies it to
   `deploy/previous-tag`, which the rollback step reads.
5. **Branch protection** — require the `test` and `security-scan` checks on `main`.

## Versions to pin

The action tags in `.github/workflows/deploy.yml` and the `node:22-alpine` base
image tag were written from memory and are **not verified** — no tag lookup was run
for them. Before relying on the workflow, pin each third-party action to a full
commit SHA (keep the tag in a comment) and the base image to a digest. To check a
tag, run `git ls-remote --tags --sort=v:refname https://github.com/<owner>/<repo>`
and take the newest stable `vX.Y.Z`; for its commit, run
`git ls-remote https://github.com/<owner>/<repo> refs/tags/vX.Y.Z 'refs/tags/vX.Y.Z^{}'`.

## Rollback

If the health check after a deploy fails, the workflow redeploys the tag stored in
`deploy/previous-tag` on the server and fails the run so a person sees it. To roll
back by hand: `IMAGE_TAG=<previous tag> docker compose -f docker-compose.prod.yml up -d --no-build app`.
