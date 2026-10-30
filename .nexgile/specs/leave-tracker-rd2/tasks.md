# Tasks: Leave Tracker

- [x] 1. Project setup
  - The Node.js server with GET /api/health, and its test.
  - _Requirements: 1.1_
  - _Files: package.json, package-lock.json, src/**, test/**_
  - _Verify: npm test_
  - _Issue: #1_
- [ ] 2. Deployment setup
  - Write what ssh-docker needs to build and run the app on the server, and do not deploy it: a Dockerfile, a .dockerignore and docker-compose.prod.yml.
  - _Requirements: 1.1_
  - _Depends: 1_
  - _Files: Dockerfile, .dockerignore, docker-compose.prod.yml_
  - _Verify: docker compose -f docker-compose.prod.yml config --quiet --no-interpolate_
  - _Verify: docker build -t leave-tracker-rd2:verify ._
  - _Mode: devops_
  - _Issue: #2_

- [ ] 3. Deployment setup for Your own server with Docker
  - Write what Your own server with Docker needs to build and run the app there, and do not deploy it: for example its configuration file, a Dockerfile, or the workflow of a pipeline that deploys it.
  - Read every secret from an environment variable. Never write a secret in a file.
  - Greenfield then checks the Docker files this task writes, with no secret or deploy value set: each compose file with `docker compose -f <file> config --quiet --no-interpolate`, and a `Dockerfile` in the app's root folder with `docker build -t leave-tracker-rd2:verify .`, with `--target <stage>` for each stage a compose file it writes builds from it. Write them so these checks pass.
  - _Requirements: 1.1_
  - _Files: **_
  - _Verify: npm test_
  - _Mode: devops_
  - _Docker checks: the files this task writes_
  - _Issue: #5_
