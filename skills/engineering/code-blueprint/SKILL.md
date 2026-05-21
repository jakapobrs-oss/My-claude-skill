---
name: code-blueprint
description: Design-first coding discipline — clarify requirements, evaluate alternatives, draw the interface before the implementation, and map dependencies and side effects before writing a single line of code. Works for both small features inside an existing codebase and new modules or services built from scratch. Trigger on /code-blueprint and proactively whenever the user asks to implement, build, add, or create something new in code — especially when the request jumps straight to implementation without a stated design.
---

# Code Blueprint

Four-step discipline for any coding task. Complete all four before writing implementation code.

## Recite this — verbatim, as the first thing in your first response

> **Blueprint:**
> 1. **Clarify the requirement.** What exactly needs to be true when this is done?
> 2. **Evaluate alternatives.** Is there a simpler, smaller, or existing approach?
> 3. **Draw the interface first.** What does the boundary look like before the inside?
> 4. **Map dependencies and side effects.** What does this touch that you did not write?

Then begin the blueprint. Do not write implementation code until all four steps are complete and the user has confirmed.

---

## 1. Clarify the requirement

Before designing anything, establish what "done" actually means.

- **State the goal in one sentence.** If you cannot, the request is underspecified — say so and ask. Do not invent scope to fill the gap.
- **Distinguish need from solution.** The user often states a solution (*"add a cache here"*) when the underlying need (*"this call is too slow"*) might be solved differently. Surface the need.
- **Identify the acceptance condition.** What observable behavior, test, or metric will confirm this is correct? If none exists, name one and confirm it with the user before proceeding.
- **Flag ambiguities explicitly.** List every assumption you are making. An unspoken assumption is a future bug.

**Scale by task size:**
- *Small feature (in existing codebase):* One or two sentences on goal + acceptance condition is enough. Move on.
- *New module or service:* Enumerate the full requirement surface — inputs, outputs, failure modes, scale expectations, operational constraints (restartable? idempotent? stateless?). Do not compress this.

If the requirement is genuinely clear, say so in one line and move on. Do not manufacture ceremony.

## 2. Evaluate alternatives

Before designing the chosen approach, spend one pass asking whether it should exist at all.

Ask, in this order:

1. **Does this already exist?** In the codebase, in a dependency already in use, in the standard library. Reuse beats reimplementation.
2. **Is there a simpler approach?** A smaller change that solves 90% of the goal with 10% of the surface. A config flag instead of new code. A one-liner instead of a new abstraction.
3. **Is this the right layer?** Should it live at the framework level or the app level? The build step or runtime? The client or the server? Wrong layer means fighting the grain of the system forever.
4. **What does doing nothing cost?** Is the problem real and load-bearing, or is it speculative? If it is speculative, name it and let the user decide.

**Output:** Name the alternatives you considered, state why you ruled each out in one line, and declare which approach you are proceeding with and why. This is not ceremony — it is the record that prevents the same question from coming up in code review.

If the user has already made a deliberate choice ("I know about X, I want Y because Z"), acknowledge it and move on. Do not re-litigate decisions that are already made.

## 3. Draw the interface first

Before writing any implementation, define the boundary of what you are building.

- **Public interface:** Function signatures, method names, parameter types, return types, and error types. Write these as actual code stubs — not prose. The interface is the contract; prose is ambiguous.
- **Data shapes:** The structures that cross the boundary. Input shape in, output shape out, error shape on failure.
- **Invariants and preconditions:** What must be true for the caller to use this correctly? State them. If they are not enforced at the boundary, say so and explain where they are enforced instead.
- **What is explicitly out of scope:** Name what the interface deliberately does not do. Scope creep hides in unspoken assumptions.

**Scale by task size:**
- *Small feature:* The interface may be a single function signature + return type + error cases. That is enough.
- *New module or service:* Draw the full API surface — every exported symbol, every endpoint, every event emitted or consumed. Include the wire format if it crosses a process boundary.

Do not implement anything in this step. Stubs only. The user confirms the interface before implementation begins.

## 4. Map dependencies and side effects

Before writing implementation, enumerate everything this code will touch that you did not write.

**Dependencies:**
- External libraries, frameworks, runtime services (DB, cache, queue, file system, network).
- Internal modules or packages from the existing codebase.
- For each: what does this code *require* from it? What happens if it is unavailable, slow, or returns an unexpected value?

**Side effects:**
- Persistent state changes: DB writes, file writes, cache mutations, queue publishes.
- Transient state changes: in-memory mutations visible to other callers, global variables, shared mutable state.
- Observability footprint: logs emitted, metrics incremented, traces produced.
- Downstream consumers: other code or services that will observe or depend on what this code produces.

**Failure modes:**
- For each external dependency: what is the failure behavior? Crash? Return empty? Retry? Timeout? Partial write?
- Are there partial-failure scenarios where some side effects have already happened when the failure occurs? (The classic: DB write succeeded, queue publish failed.)

**Output:** A concise list — not an essay. One line per item: what it is, what this code requires from it, and what happens when it misbehaves. If the list is empty (pure function, no I/O, no shared state), say so explicitly — that is information too.

---

## Confirmation gate

After completing all four steps, present a summary:

```
Blueprint summary
─────────────────
Goal:        <one sentence>
Approach:    <chosen approach, alternatives ruled out>
Interface:   <stub or API surface>
Dependencies: <list>
Side effects: <list>

Proceed with implementation?
```

Do not write implementation code until the user confirms. A "yes," "go ahead," "looks good," or equivalent is the gate. If the user says "just write the code," proceed — do not re-ask.

---

## Operating rules

- Recite the blueprint block **once** per task, in your first response. Do not re-recite mid-task.
- Recite **verbatim**. Do not paraphrase or skip lines.
- If the user says "skip the blueprint" → skip the recital but still complete all four steps silently before writing implementation.
- **Do not write implementation code before the confirmation gate.** Stubs and interfaces are not implementation — they are part of step 3.
- **Do not invent requirements** to fill gaps. Ask.
- **Do not re-litigate deliberate decisions.** If the user has already chosen an approach, one acknowledgment is enough — do not keep surfacing alternatives.
- **Scale the blueprint to the task.** A one-line utility does not need a five-section design doc. A new service does. Match the formality to the stakes.
- The blueprint is a constraint **you** carry — not a checklist to deliver back to the user as advice.

---

## Relationship to other skills

- If the implementation reveals a bug rather than a missing feature → hand off to [`debug-mantra`](../debug-mantra/SKILL.md).
- After the fix is validated → [`post-mortem`](../post-mortem/SKILL.md).
- If the user wants a second opinion on the blueprint itself before confirming → [`scrutinize`](../scrutinize/SKILL.md) on the interface and dependency map.
- If the blueprint needs to be communicated to non-engineering stakeholders → [`management-talk`](../../productivity/management-talk/SKILL.md).

---

## Worked example — small feature (in existing codebase)

**Request:** *"Add rate limiting to the login endpoint."*

### Recite
> **Blueprint:**
> 1. Clarify the requirement. What exactly needs to be true when this is done?
> 2. Evaluate alternatives. Is there a simpler, smaller, or existing approach?
> 3. Draw the interface first. What does the boundary look like before the inside?
> 4. Map dependencies and side effects. What does this touch that you did not write?

### Step 1 — Clarify
Goal: prevent brute-force attacks on `POST /login` by limiting attempts per IP.
Acceptance condition: after N failed attempts within a time window, subsequent attempts return 429 until the window resets. N and the window are configurable.
Assumptions: IP is a reliable-enough key for this threat model (no CGNAT concern stated). Successful logins do not reset the counter.
Ambiguity: what is N? What is the window? → Ask.

*User replies: 5 attempts / 15 minutes.*

### Step 2 — Alternatives
- **Existing middleware in the framework?** → Checked. The framework has `express-rate-limit` already in `package.json`, unused. Use it rather than rolling custom logic.
- **Doing nothing?** → Login endpoint is public-facing. Real risk. Not speculative.
- **Proceeding with:** configure `express-rate-limit` on the login route with a Redis store (already in use for sessions).

### Step 3 — Interface

```ts
// config/rateLimits.ts
export const loginRateLimit = rateLimit({
  windowMs: 15 * 60 * 1000,   // 15 min
  max: 5,                      // attempts per window
  keyGenerator: (req) => req.ip,
  skipSuccessfulRequests: false,
  store: new RedisStore({ client: redisClient }),
  handler: (req, res) => res.status(429).json({ error: 'Too many attempts' }),
});

// Applied in: routes/auth.ts
// router.post('/login', loginRateLimit, loginHandler)
```

Out of scope: per-username limiting, distributed IP banning, CAPTCHA fallback.

### Step 4 — Dependencies and side effects
- **Redis** (existing): stores attempt counters. If Redis is unavailable, `express-rate-limit` with a Redis store fails open by default — all requests pass. Acceptable for this threat model; note it.
- **`req.ip`**: relies on Express trusting the proxy header. Already set (`app.set('trust proxy', 1)`). Fine.
- **Side effects**: writes a counter key per IP to Redis with TTL = window. No DB writes. No events emitted.
- **Failure mode**: Redis timeout → fail open (logged by the existing Redis error handler).

### Confirmation gate
```
Blueprint summary
─────────────────
Goal:         Limit POST /login to 5 attempts per IP per 15 min
Approach:     Configure express-rate-limit (already in package.json) with Redis store
Interface:    loginRateLimit middleware, applied to auth router
Dependencies: Redis (fail-open if unavailable), express-rate-limit, req.ip via trust proxy
Side effects: Redis counter key per IP, TTL-bounded, no DB writes

Proceed with implementation?
```

---

## Worked example — new module (built from scratch)

**Request:** *"Build a job queue for sending emails."*

### Step 1 — Clarify
Goal: decouple email sending from request handlers so slow/failed sends do not block the API.
Acceptance condition: jobs enqueued during a request are processed asynchronously; failures retry up to 3 times with backoff; permanently failed jobs are recorded for inspection.
Assumptions: email volume is low enough that a single worker process is sufficient for now. Emails are not time-critical to the second.
Ambiguities: which email provider? What is the retry backoff? Where are dead-letter jobs stored? → Ask.

*User replies: SendGrid, exponential backoff starting at 30s, dead-letter to a DB table.*

### Step 2 — Alternatives
- **Use an existing queue library (BullMQ, pg-boss)?** → `pg-boss` fits well — the project already has Postgres, no new infrastructure. Preferred over BullMQ (requires Redis, not in the stack).
- **Send inline (no queue)?** → Already rejected by the user's stated need for decoupling.
- **Proceeding with:** `pg-boss` backed by the existing Postgres instance.

### Step 3 — Interface

```ts
// jobs/emailQueue.ts

export type EmailJob = {
  to: string;
  subject: string;
  templateId: string;
  templateData: Record<string, unknown>;
};

// Enqueue — call from request handlers
export async function enqueueEmail(job: EmailJob): Promise<string>  // returns job id

// Worker — started once at app boot
export async function startEmailWorker(): Promise<void>

// Not exported (internal): processEmail, handleFailure, writeDead Letter
```

Out of scope: job cancellation, priority queues, per-recipient rate limiting.

### Step 4 — Dependencies and side effects
- **`pg-boss`**: manages job rows in Postgres. Requires a `pgboss` schema in the DB (auto-created on first start). Worker poll interval: default 2s.
- **Postgres** (existing): job queue table + dead-letter table. Schema migration required before deploy.
- **SendGrid API**: external HTTP call per job. Failures surface as thrown errors caught by `pg-boss` retry logic.
- **Side effects**:
  - `enqueueEmail`: inserts one row into the `pgboss.job` table.
  - Worker: reads and deletes job rows; writes to `pgboss.job` (retry) or `email_dead_letters` (permanent failure); calls SendGrid HTTP API; emits a structured log line per job outcome.
- **Failure modes**:
  - SendGrid 4xx (bad request): do not retry — write to dead-letter immediately.
  - SendGrid 5xx / network timeout: retry with exponential backoff, up to 3 times.
  - Postgres unavailable: `enqueueEmail` throws — caller must handle. Worker pauses poll until reconnected (pg-boss behavior).

### Confirmation gate
```
Blueprint summary
─────────────────
Goal:         Async email queue, decoupled from request handlers
Approach:     pg-boss on existing Postgres (no new infra)
Interface:    enqueueEmail(job) → id | startEmailWorker() → void
Dependencies: pg-boss, Postgres (migration required), SendGrid API
Side effects: Postgres rows (job table + dead-letter table), SendGrid HTTP calls,
              structured logs per outcome

Proceed with implementation?
```
