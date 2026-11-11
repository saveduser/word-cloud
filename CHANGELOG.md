# Changelog

All notable changes to the Pure Mojo Word Cloud library will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

---

## [0.2.0] - 2026-11-11

### Added
- **Library Versioning**: Added `src/wordcloud/version.mojo` providing `LibraryInfo`, `get_version()`, and `get_supported_mojo()`.
- **Regression Tests**: Added `tests/test_version.mojo` and high-density placement validation `test_high_density_placement` in `tests/test_layout.mojo`.
- **Real-World Article Generator**: Added `examples/generate_real_articles.mojo` generating word clouds for DeepMind Gemini, NASA JWST, and Quantum Computing articles.
- **Layout Quality Evaluator**: Added `benchmarks/evaluate_quality.mojo` for multi-canvas performance testing across 400x300, 800x600, 1200x800, and 1920x1080 resolutions.

### Changed
- **Compiler Version Pinning**: Pinned development compiler dependency in `pixi.toml` to `mojo == 1.2.0`.
- **Adaptive Spiral Engine**: Replaced static spiral step limit with dynamic canvas-proportional `max_radius`.
- **Uniform Arc Sampling**: Implemented adaptive tangential angle stepping ($\Delta\theta$) to prevent candidate skipping at large radii.
- **Progressive Multi-Pass Scaling**: Added 4-tier progressive size reduction ($1.0 \to 0.82 \to 0.67 \to 0.52$) before dropping words.
- **Dual-Orientation Fallback**: Words failing in primary orientation now attempt secondary orientation before resizing.
- **Config Defaults**: Updated default `max_placement_attempts` in `WordCloudConfig` from 500 to 1500.

### Fixed
- **Large Canvas Placement Bottleneck**: Fixed premature termination at $r=250\text{px}$, increasing Full HD (1920x1080) placement rate from 21.3% to 98.7% while maintaining 0 overlaps and 0 out-of-bounds coordinates.

---

## [0.1.0] - 2026-11-11

### Added
- Initial standalone release of the Pure Mojo Word Cloud library.
- Pure Mojo tokenizer supporting Unicode, punctuation filtering, and configurable word length.
- Built-in English stopwords set and custom stopword manager.
- Word frequency analysis supporting raw text and precomputed dictionaries.
- Typographic character width and bounding box estimation.
- 2D uniform spatial grid index for $O(1)$ collision checks.
- Color system with hex parsing, RGB interpolation, and 6 palette presets.
- SVG 1.1 exporter with XML entity escaping and vertical text rotation.
- Public `WordCloud` and `WordCloudResult` APIs.
- Comprehensive 42-test test suite across all modules.
