---
name: api-design-review
description: Checklist-based review of API design decisions before implementation begins. Run between to-prd and to-issues to catch naming inconsistencies, missing pagination, auth gaps, and breaking-change risks early.
---

# API Design Review

Review the API design described in the current PRD or implementation plan against this checklist. Do NOT parse OpenAPI/Swagger specs — use reasoning against the checklist items.

Run this automatically between `to-prd` (after implementation decisions are drafted) and `to-issues` (before issues are published). Scope is per feature, not a full API audit.

## Checklist

For each endpoint in the proposed feature, verify:

### 1. Naming Consistency
- Are resource names plural nouns? (`/users`, `/orders`) — not verbs (`/createUser`), not singular (`/user/5`)
- Are relationships expressed through nesting when appropriate? (`/orders/5/items`)
- Do resource names match the domain vocabulary in `CONTEXT.md`? If `CONTEXT.md` says "Shipment" not "Delivery", paths should use `/shipments`

### 2. HTTP Method Semantics
| Method | Idempotent? | Used correctly? |
|--------|------------|-----------------|
| `GET` | ✅ Yes | Retrieval only, no side effects |
| `HEAD` | ✅ Yes | Like GET without body |
| `POST` | ❌ No | Creating new resources, non-idempotent operations |
| `PUT` | ✅ Yes | Full replacement of resource |
| `PATCH` | ❌ No* | Partial update (may or may not be idempotent) |
| `DELETE` | ✅ Yes | Removal |

### 3. Error Response Format
- Is there a consistent error format? (RFC 7807 Problem Details recommended: `type`, `title`, `status`, `detail`, `instance`)
- Are HTTP status codes used appropriately? (400 bad input, 401 unauthenticated, 403 forbidden, 404 not found, 409 conflict, 422 unprocessable, 500 internal)
- Are error messages actionable? Does the response tell the client _what_ went wrong and _how_ to fix it?

### 4. Pagination
- Does every list endpoint support pagination? (No unbounded `GET /users` returning everything)
- Is the strategy consistent across all endpoints? (cursor-based for real-time data, offset-based for admin/reporting)
- Are pagination parameters documented? (`cursor`, `limit`, `after`, `before`)

### 5. Authentication & Authorization
- What auth mechanism does this endpoint require? (JWT, API key, session cookie, none/public)
- If auth is required, what scope/permission level? (read-only, write, admin)
- Are there endpoints that accidentally expose data at a broader scope than intended? (`GET /users` returning all users vs only current user's data)

### 6. Rate Limiting
- Is this endpoint a candidate for rate limiting? (login, password reset, public endpoints, expensive queries)
- Are rate limit headers communicated? (`X-RateLimit-Remaining`, `Retry-After`)

### 7. Breaking Change Risk
- Are there existing clients consuming the current version of this endpoint?
- If yes: does this change break them? Is a new version needed (`/v2/...`)?
- Are deprecated fields clearly marked with a migration path?

### 8. Schema Consistency
- Do request/response field names follow the same convention? (camelCase consistently, or snake_case consistently — not mixed)
- Are date/time fields in a consistent format? (ISO 8601 recommended)
- Are optional vs required fields clearly distinguished?

## On Failure

If any item fails, flag it explicitly to the user before proceeding to `to-issues`. Do not silently pass a design with known issues.

Example output:

> ⚠️ API design issues found:
> 1. **Naming**: `POST /createOrder` uses verb — rename to `POST /orders`
> 2. **Pagination**: `GET /users` returns all results — add cursor-based pagination
> 3. **Auth**: `GET /users/:id/email` exposes PII without auth check — requires `user:read` scope
>
> Proceed to `to-issues` after these are resolved.
