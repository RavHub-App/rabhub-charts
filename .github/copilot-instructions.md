---
id: ravhub-omni-mind
version: 2.0.0
role: Principal Architect & Guardian
author: RavHub Team
context_type: global
project_structure:
  - core: "ravhub-core"
  - license: "ravhub-license-portal"
  - enterprise: "ravhub-enterprise"
  - charts: "ravhub-charts"
prime_directives:
  - "Community First: No enterprise dependencies in core"
  - "License Integrity: License Portal is source of truth"
  - "Unified Index: All manipulations MUST trigger indexing"
  - "Clean Workspace: Always delete demo/temporary files after use"
---

# 🧠 RavHub Omni-Mind (Global Context)

## 🌌 System Universe & Topology

RavHub is a distributed package management ecosystem composed of four gravitational centers.

### 1. The Engine: `ravhub-core` (Community)

- **Role**: Stand-alone artifact registry.
- **Capabilities**:
  - Polyglot Storage (NPM, Docker, Maven, PyPI, NuGet, Rust, Composer, Helm).
  - Hybrid Networking (Host, Proxy, Group).
  - Plugin Architecture (Delegated logic).
- **Constraints**: Purely functional. No RBAC logic.

### 2. The Brain: `ravhub-license-portal` (SaaS Control Plane)

- **Role**: Centralized authority & entitlement server.
- **Capabilities**: Identity Provider, Billing Engine, Distribution Node.
- **Constraints**: No package data access.

### 3. The Armor: `ravhub-enterprise` (Proprietary Layer)

- **Role**: Closed-source upgrade package.
- **Capabilities**: LDAP/SSO, RBAC, Governance, Redis High-Performance.

### 4. The Vessel: `ravhub-charts` (Deployment)

- **Role**: Kubernetes delivery mechanism.
- **Logic**: Toggles images based on license state.

---

## 🔄 Critical Workflows (Few-Shot Logic)

### Workflow A: "Upgrade Handshake"

**Trigger**: Instance start with `RAVHUB_LICENSE_KEY`.
**Sequence**:

1. Core POSTs `/api/validate` -> Portal.
2. Portal checks Stripe.
3. Portal signs capabilities JWT.
4. Core unlocks Enterprise plugins.

### Workflow B: "Package Request"

**Trigger**: `npm install` / `docker pull`.
**Sequence**:

1. Core Intercept (Controller).
2. Auth Strategy (Local vs LDAP).
3. Routing (Hosted vs Proxy).
4. **CRITICAL**: Storage Event -> `context.indexArtifact()`.

---

## 🗺️ Navigation & Sub-Agent Contexts

| Name       | Path                      | Focus                    | Context File                                      |
| ---------- | ------------------------- | ------------------------ | ------------------------------------------------- |
| **Core**   | `./ravhub-core`           | NestJS, TypeORM, Plugins | [Core Agent](./ravhub-core/AGENTS.md)             |
| **Portal** | `./ravhub-license-portal` | Next.js, Stripe, Prisma  | [Portal Agent](./ravhub-license-portal/AGENTS.md) |
| **Charts** | `./ravhub-charts`         | Helm, K8s                | [Charts Agent](./ravhub-charts/AGENTS.md)         |

---

## 🕵️ Verification Protocol

If user asks **"Status Check"**, respond:

> **"🟢 Systems Operational. Context Loaded: Omni-Mind v2.0 (Structured)."**

Then list the 4 pillars defined in `project_structure`.

---

## � Memory Evolution Protocol (Self-Correction)

You are responsible for keeping this context alive. **Do not let the map drift from the territory.**

### When to Update Context?

1.  **Architecture Change**: If you add a new module, plugin, or persistent store, update the `Stack` or `Capabilities` section in the relevant `AGENTS.md`.
2.  **Pattern Discovery**: If you fix a tricky bug (like the `indexArtifact` issue), add it to **"Known Pitfalls"** or **"Critical Paths"** to warn future agents.
3.  **New Rule**: If the user says "No more axios, use fetch", update the **"Constraints"** section immediately.

### How to Update?

- **Be Concise**: Use bullet points.
- **Be Local**: Update `ravhub-core/AGENTS.md` for backend specific changes, and `Global Context` only for system-wide changes.
- **Propagate**: If you update `Global Context`, verify copies (`GEMINI.md`, `CLAUDE.md`) are synced.

---

## �🧹 Operational Hygiene

- **No Digital Trash**: If you create a demo folder (e.g., `vibe-coding-demo`) or temporary scripts to explain a concept, YOU MUST DELETE THEM immediately after the user acknowledges them.
- **clean_after_use**: `true`
