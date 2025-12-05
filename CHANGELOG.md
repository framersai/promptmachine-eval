# Changelog

All notable changes to promptmachine-eval will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2024-12-05

### Added
- Initial release of promptmachine-eval
- ELO rating system with configurable K-factor and uncertainty tracking
- Monte Carlo matchmaking for optimal battle pairings
- Arena battle runner with LLM-as-judge evaluation
- Prompt testing across multiple providers (OpenAI, Anthropic, OpenRouter)
- Cost tracking and estimation for all supported models
- CLI tool (`pm-eval`) with commands:
  - `test` - Test prompts across models
  - `battle` - Run head-to-head comparisons
  - `cost` - Estimate API costs
  - `models` - List supported models
  - `init` - Create config file
- Benchmark framework base classes
- Markdown report generation
- Comprehensive test suite

### Supported Providers
- OpenAI (GPT-4o, GPT-4o-mini, GPT-4, GPT-3.5, o1-preview, o1-mini)
- Anthropic (Claude 3.5 Sonnet, Claude 3.5 Haiku, Claude 3 Opus)
- OpenRouter (Gemini, Llama, Mistral, DeepSeek, Qwen, and more)

