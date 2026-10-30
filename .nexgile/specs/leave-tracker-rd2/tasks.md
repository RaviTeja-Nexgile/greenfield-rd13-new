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
