---
name: dockerfile-review
description: Pre-commit checklist for Dockerfile review — catches common anti-patterns before they hit production.
---

> ⚠️ DEFERRED — tulis saat ada proyek konkret yang butuh Dockerfile.

Intent: Verify Dockerfile against checklist: multi-stage build, non-root user, `.dockerignore`, layer caching, no secrets, minimal base image, proper signal handling.
