# Recent Updates & Decisions

This file is the append-only log of project decisions and notable changes, maintained by coding agents following the `recent-updates` skill. Everything below the marker line is user-owned history: slopctl never overwrites it during init or merge.

<!-- {changelog} -->

### 2026-07-29 (v2.0.0, fill in AGENTS.md project placeholders)

- populated Mission Statement, Technology Stack, Development Guidelines, Testing, and Documentation sections in AGENTS.md with real NMCS project details sourced from README.md and CMakeLists.txt
- filled Code Review and Security & Safety placeholder bullets with actual project practices (PR review against `develop` gated by `.github/workflows/build.yml`; secrets via `src/services/vault`)
- rationale: AGENTS.md was still the unfilled scaffold template despite the project having real, documented conventions; no code changed, so no version bump
- version: no bump (documentation-only change, current version 2.0.0 unchanged)

### 2025-10-05 (v0.1.0, initial setup)

- initial AGENTS.md setup
- established core coding standards and conventions
- defined repository structure and governance principles
