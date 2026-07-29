# Project Instructions for AI Coding Agents

**Last updated:** 2026-07-29

<!-- {preamble} -->

# ⚠️ Before You Start

Run `/init-session` at the beginning of each new session, OR read this entire file before proceeding.

**DO NOT** make code changes or commits until you have done one of the above.

<!-- {mission} -->

## Mission Statement

NMCS (Network Media Control System) is a modern, cross-platform C++23 library and service system for controlling and managing network-based media services, with a particular focus on podcast and audio content management (ID3v2 metadata, episode/season/contributor models, HTTP and database-backed services).

## Technology Stack

- **Language:** C++23 with C23 support
- **Build System:** CMake 3.28+, with platform files under `cmake/{darwin,linux,windows}.cmake` and CMakePresets.json
- **Version Control:** Git
- **Package Manager:** none — third-party dependencies (CLI11, zlib, libcurl, libxml2, simdutf, simdjson, spdlog, whisper.cpp) are fetched and built from source by the CMake build itself
- **License:** MIT

## Session Protocol

When starting a new session, read this entire file and confirm you have
understood the project instructions before proceeding. Summarize the project
purpose and key conventions briefly. Do not make changes until you have
confirmed your understanding.

<!-- {principles} -->

## Primary Instructions

- Avoid making assumptions. If you need additional context to accurately answer the user, ask the user for the missing information. Be specific about which context you need.
- Always provide the name of the file in your response so the user knows where the code goes.
- Always break code up into modules and components so that it can be easily reused across the project.
- All code you write MUST be fully optimized. ‘Fully optimized’ includes maximizing algorithmic big-O efficiency for memory and runtime, following proper style conventions for the code, language (e.g. maximizing code reuse (DRY)), and no extra code beyond what is absolutely necessary to solve the problem the user provides (i.e. no technical debt). If the code is not fully optimized, you will be fined $100.

### Working Together

This file (`AGENTS.md`) is the primary instructions file for AI coding assistants working on this project. Agent-specific instruction files (such as `.github/copilot-instructions.md`, `CLAUDE.md`) reference this document, maintaining a single source of truth.

When initializing a session or analyzing the workspace, refer to instruction files in this order:

1. `AGENTS.md` (this file - primary instructions and single source of truth)
2. Agent-specific reference file (if present - points back to AGENTS.md)

### Update Protocol (CRITICAL)

**PROACTIVELY update this file (`AGENTS.md`) as we work together.** Whenever you make a decision, choose a technology, establish a convention, or define a standard, you MUST update AGENTS.md immediately in the same response.

**Update ONLY this file (`AGENTS.md`)** when coding standards, conventions, or project decisions evolve. Do not modify agent-specific reference files unless the reference mechanism itself needs changes.

**When to update** (do this automatically, without being asked):

- Technology choices (build tools, languages, frameworks)
- Directory structure decisions
- Coding conventions and style guidelines
- Architecture decisions
- Naming conventions
- Build/test/deployment procedures

**How to update AGENTS.md:**

- Maintain the "Last updated" timestamp at the top
- Add content to the relevant section (Project Overview, Coding Standards, etc.)
- Log every change in the "Recent Updates & Decisions" log in `UPDATES.md` with:
  - Date (with time if multiple updates per day)
  - Brief description
  - Reasoning for the change
- New log entries go directly below the changelog marker in `UPDATES.md`, newest first; load the `recent-updates` skill for the full rules
- Preserve the AGENTS.md structure: title header → timestamp → main instructions

## Best Practices

### When Updating This Repository

1. **Maintain Consistency**: Keep code style consistent across the codebase
2. **Test First**: Write tests before implementing features when applicable
3. **Document Changes**: Update documentation when changing functionality
4. **Code Review**: Changes are proposed via pull request against `develop`; `.github/workflows/build.yml` runs the CMake build as a CI gate
5. **Date Changes**: Update the "Last updated" timestamp in this file when making changes
6. **Log Updates**: Add entries to the "Recent Updates & Decisions" log in `UPDATES.md`

### Development Guidelines

- Project layout follows a layered architecture: Platform (`src/platform`) → Runtime (`src/runtime`) → Model (`src/model`) → Server (`src/server`) → Agent/Client (`src/agent`, `src/client`), plus optional services (`src/services/*`) and gateways (`src/gateways/{northbound,southbound}/*`) toggled via CMake `ENABLE_*` options
- All code lives under the `ultralove::nmcs` namespace; public API headers go in `include/nmcs/`
- Naming: PascalCase for classes, camelCase for functions; header guards use `#ifndef __NMCS_*_H_INCL__`
- Use RAII and smart pointers for memory management; public API exports use `NMCS_SHARED_API`
- Error handling uses the `NmcsStatus` return type and `NMCS_FAILED()` macro, not exceptions, across API boundaries

### Security & Safety

- Never include API keys, tokens, or credentials in code
- Always require explicit human confirmation before commits
- Maintain conventional commit message standards
- Keep change history transparent through commit messages
- Secrets and credentials go through the platform's native security vault integration (`src/services/vault`), never hardcoded

### Testing

No automated test suite exists yet. Manual verification currently relies on exercising the built CLI tools (e.g. `./nmcsclient guidgen`, `./nmcsclient chapters --input audio.mp3`). Introduce a proper unit/integration test framework and update this section when one is adopted.

### Documentation

- Code comments: none by default; only when the WHY is non-obvious (see `cpp-coding-conventions` skill)
- API documentation: generated via Doxygen (`scripts/doxyfile`); run `doxygen doxyfile` from `scripts/`
- README updates: keep README.md's architecture, prerequisites, and usage sections in sync with actual build/dependency changes
- Changelog: maintained in `UPDATES.md` (see the `recent-updates` skill)

<!-- {languages} -->

Load the `cmake-build-commands` skill when building or running the project.

## C++ Coding Standards

Load the `c++-coding-conventions` skill before writing, reviewing, or refactoring C++ code.

<!-- {integration} -->

## Commit Protocol

- **NEVER commit automatically** — always wait for explicit user confirmation
- Stage changes, write a conventional commits message (max 50-char subject, 72-char body lines), then commit
- Load the `git-workflow` skill for the full message format, character limits, and examples before committing
- Never add co-authorship trailers or any attribution naming an AI coding agent to commit messages

## Recent Updates & Decisions

Project decisions and notable changes are logged in `UPDATES.md`, below its changelog marker. The log is append-only: add new entries at the top, never edit or delete existing ones, and keep the "Last updated" timestamp in `AGENTS.md` in sync. Load the `recent-updates` skill for the entry format and full rules.

## Semantic Versioning

Automatically bump the project version after every code change and include it in the same commit. Load the `semantic-versioning` skill for the full PATCH/MINOR/MAJOR decision rules.
