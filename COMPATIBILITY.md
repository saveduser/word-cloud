# Mojo Versioning & Compatibility Guide

This document defines the compatibility matrix, compiler pinning strategy, API stability audit, and repeatable upgrade procedures for the **Pure Mojo Word Cloud** library.

---

## 1. Compatibility Matrix

| Library Version | Mojo Compiler Target | Status | Tested Environments |
|---|---|---|---|
| **0.2.x** | **Mojo 1.2.0** (`==1.2.0`) | **Current / Supported** | Linux x86_64, Windows 11 via WSL2 (Ubuntu 22.04) |
| **0.1.x** | Mojo 1.2.0 | Deprecated | Linux x86_64 |
| Any | Mojo < 1.2.0 | Unsupported | Incompatible with `std.` import namespace & `@fieldwise_init` |
| Any | Mojo Nightly | Experimental | Not guaranteed until test suite passes |

### Target Architectures & Operating Systems
- **Linux (x86_64)**: Fully supported natively with glibc $\ge$ 2.31.
- **Windows (x64)**: Supported via **WSL2** (Windows Subsystem for Linux, Ubuntu 22.04+). Modular does not yet provide native Win32/x64 binaries for Mojo.
- **macOS (Apple Silicon)**: Compatible with `osx-arm64` via Modular conda channels.

---

## 2. Compiler Pinning with Pixi

To ensure deterministic, reproducible builds and avoid unexpected upstream compiler breakage, the development environment is pinned strictly to **Mojo 1.2.0** in [`pixi.toml`](file:///mnt/e/Projects/Startup%20Projects/libraries/mojo/word-cloud/pixi.toml):

```toml
[dependencies]
mojo = "==1.2.0"
```

The exact package hashes and dependencies are locked in [`pixi.lock`](file:///mnt/e/Projects/Startup%20Projects/libraries/mojo/word-cloud/pixi.lock).

### Reproducing the Environment
To install the exact pinned development toolchain:
```bash
# 1. Install Pixi (if not already installed)
curl -fsSL https://pixi.sh/install.sh | bash

# 2. Install dependencies exactly as recorded in pixi.lock
pixi install --frozen

# 3. Verify the installed compiler version
pixi run mojo --version
# Output: Mojo 1.2.0 (2016d0cd)
```

---

## 3. Standard Library Stability Audit

A comprehensive audit was performed across all source files in `src/wordcloud/` to verify reliance on stable standard-library features:

| Module / Feature | Standard Library Namespace | Stability Status | Notes |
|---|---|---|---|
| **Dynamic Array** | `std.collections.List` | **Stable** | Standard dynamic array collection. |
| **Hash Map** | `std.collections.Dict` | **Stable** | Swiss Table hash map. |
| **Hash Set** | `std.collections.Set` | **Stable** | Set collection for stopword lookups. |
| **Unit Testing** | `std.testing.TestSuite`, `assert_*` | **Stable** | Native test discovery and assertions. |
| **Mathematics** | `std.math.sqrt`, `log`, `sin`, `cos` | **Stable** | Floating-point mathematical functions. |
| **High-Res Timer** | `std.time.perf_counter_ns` | **Stable** | Monotonic nanosecond benchmarking timer. |
| **Value Semantics** | `@fieldwise_init`, `Copyable`, `Movable`, `Comparable` | **Stable** | Modern struct lifecycle traits replacing deprecated `@value`. |
| **Unicode Strings** | `String.codepoints()`, `chr()`, `byte_length()` | **Stable** | Standard UTF-8 string APIs in Mojo 1.2+. |
| **Compiler Flags** | None | **Stable** | Built without experimental flags (`--experimental-*`). |

### Language Conventions & Rules Followed
1. **`def` only**: Conforms to the removal of `fn` in Mojo 1.2+.
2. **Explicit Lifetimes & Ownership**: Because collections are not implicitly copyable, transfer operators (`^`) and explicit `.copy()` calls are used strictly where ownership transfers or deep copies are required.
3. **No Positional String Indexing**: Avoids deprecated `s[i]` and `len(s)` in favor of unambiguous `s.codepoints()` and `s.byte_length()`.

---

## 4. Known Compiler & Environment Limitations

1. **Native Windows Executable Absence**:
   - The Mojo compiler does not currently distribute standalone Windows `.exe` toolchains.
   - On Windows, Mojo must run inside WSL2 (Ubuntu 22.04 recommended). The project directory can reside on a mounted Windows drive (`/mnt/e/...`), where file editing and git operations remain fully native to Windows.
2. **Global Module Aliases**:
   - In Mojo 1.2.0, top-level `alias` string declarations at file scope are rejected as bare expressions. Version constants are safely exposed via static methods on the `LibraryInfo` struct.

---

## 5. Multi-Version Testing Strategy

Future compatibility is governed by a three-tier testing matrix:

1. **Pinned Supported Version (`mojo == 1.2.0`)** *(Required)*:
   - Must pass all 45 unit and integration tests on every commit.
2. **Candidate Stable Version** *(Required before updating support claim)*:
   - Evaluated in an isolated branch/environment. All tests, benchmarks, and SVG generation examples must pass before claiming compatibility.
3. **Mojo Nightly** *(Optional / Informational)*:
   - Tested periodically to anticipate breaking standard-library or syntactic deprecations ahead of public releases.

---

## 6. Step-by-Step Compiler Upgrade Procedure

When Modular releases a new stable version of Mojo (e.g. Mojo 1.3.0), follow this repeatable 10-step protocol:

```text
[Step 1: Branch] ──> [Step 2: Update pixi.toml] ──> [Step 3: Relock] ──> [Step 4: Compile Check]
                                                                                  │
[Step 8: Investigate] <── [Step 7: Benchmarks] <── [Step 6: SVG Output] <── [Step 5: Run Tests]
        │
[Step 9: Update Docs] ──> [Step 10: Atomic Commit]
```

1. **Create an Upgrade Branch**:
   ```bash
   git checkout -b upgrade/mojo-1.3.0
   ```
2. **Update the Dependency Pin**:
   Edit `pixi.toml` to specify the candidate version:
   ```toml
   [dependencies]
   mojo = "==1.3.0"
   ```
3. **Regenerate Lockfile**:
   ```bash
   pixi update mojo
   ```
4. **Compile Source Files**:
   Verify compilation without warnings or deprecation errors:
   ```bash
   pixi run mojo -I src tests/test_version.mojo
   ```
5. **Run the Full Test Suite**:
   ```bash
   pixi run test
   ```
   *Requirement: 100% of unit and integration tests must pass.*
6. **Validate Visual SVG Output**:
   ```bash
   pixi run example-articles
   ```
   Inspect generated SVG files to ensure layout, text rendering, and rotation transforms remain visually correct.
7. **Run Benchmarks & Evaluation**:
   ```bash
   pixi run benchmark
   pixi run evaluate
   ```
   Compare throughput against documented baselines.
8. **Investigate & Resolve API Differences**:
   If syntax or standard-library functions changed, refactor using stable alternatives while maintaining public API backward compatibility.
9. **Update Documentation**:
   - Update `SUPPORTED_MOJO_VERSION` in `src/wordcloud/version.mojo`.
   - Update the Compatibility Matrix in `COMPATIBILITY.md`.
   - Record changes in `CHANGELOG.md`.
10. **Commit the Upgrade Separately**:
    ```bash
    git commit -m "chore: upgrade supported Mojo compiler to 1.3.0"
    ```

---

## 7. Semantic Versioning (SemVer) Policy

The library version (`MAJOR.MINOR.PATCH`) is strictly decoupled from the Mojo compiler version:

- **PATCH** (`0.2.x` $\to$ `0.2.y`):
  Backward-compatible bug fixes, performance optimizations, and layout enhancements that do not alter the public API.
- **MINOR** (`0.2.x` $\to$ `0.3.0`):
  New backward-compatible features (e.g., new color palettes, new exporters, additional configuration parameters with default values).
- **MAJOR** (`0.x.x` $\to$ `1.0.0`):
  Breaking changes to public types, method signatures, or configuration structures.

> **Note**: Upgrading the underlying supported Mojo compiler version does **not** trigger a library MAJOR bump unless it forces a breaking change to the library's public API.
