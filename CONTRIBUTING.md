# Contributing to Mojo Word Cloud

Thank you for your interest in contributing to the Mojo Word Cloud library!

## Development Setup

This project uses Pixi and the Modular Conda channel for Mojo development.

1. Ensure Pixi is installed (`curl -fsSL https://pixi.sh/install.sh | bash`).
2. Clone this repository.
3. Install dependencies:
   ```bash
   pixi install
   ```

## Running Tests

Run the full unit test suite:
```bash
pixi run test
```

## Running Benchmarks

Run performance benchmarks:
```bash
pixi run benchmark
```

## Running Examples

Execute any example script:
```bash
pixi run example-basic
pixi run example-colors
pixi run example-stopwords
pixi run example-frequencies
```

## Code Guidelines

- Maintain pure Mojo implementations with zero Python runtime dependencies.
- Follow value semantics (`Copyable`, `Movable`, `Comparable`) and explicit `@fieldwise_init`.
- Include unit tests in `tests/` for all new features and bug fixes.
