# Requirements: Leave Tracker

## Introduction

A leave tracker for a 50-person company. Release 1 is its server, with a health check a deploy can use.

## Requirement 1: Health check

**User Story:** As the person who deploys the app, I want a health address, so that a deploy can be checked.

### Acceptance Criteria

1. WHEN GET /api/health is requested THE SYSTEM SHALL answer 200 with {"ok":true}
