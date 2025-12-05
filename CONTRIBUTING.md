# Contributing to promptmachine-eval

First off, thank you for considering contributing to promptmachine-eval! 🎉

This document provides guidelines for contributing to the project. By participating, you agree to abide by our [Code of Conduct](CODE_OF_CONDUCT.md).

## Table of Contents

- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Making Changes](#making-changes)
- [Code Style](#code-style)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)
- [Release Process](#release-process)

## Getting Started

### Types of Contributions

We welcome all contributions:

- 🐛 **Bug Reports** — Found a bug? [Open an issue](https://github.com/framersai/promptmachine-eval/issues/new?template=bug_report.yml)
- 💡 **Feature Requests** — Have an idea? [Open a feature request](https://github.com/framersai/promptmachine-eval/issues/new?template=feature_request.yml)
- 📚 **Documentation** — Improve docs, add examples, fix typos
- 🧪 **Tests** — Add test coverage for existing features
- ✨ **Code** — Fix bugs, implement features, improve performance

### First-Time Contributors

Look for issues labeled [`good first issue`](https://github.com/framersai/promptmachine-eval/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22) — these are beginner-friendly.

## Development Setup

### Prerequisites

- Python 3.10 or higher
- Git
- A GitHub account

### Clone and Install

```bash
# Fork the repo on GitHub first, then:
git clone https://github.com/YOUR_USERNAME/promptmachine-eval.git
cd promptmachine-eval

# Create a virtual environment
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Install in development mode with all dependencies
pip install -e ".[dev]"

# Install pre-commit hooks
pre-commit install
```

### Verify Installation

```bash
# Run tests
pytest

# Run linting
ruff check .
black --check .
mypy src/

# Test CLI
pm-eval version
```

## Making Changes

### Branch Naming

Use descriptive branch names:

- `feature/add-tournament-mode`
- `fix/elo-calculation-edge-case`
- `docs/improve-api-examples`
- `test/matchmaking-coverage`

### Development Workflow

1. **Create a branch** from `master`:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** with clear, atomic commits

3. **Write/update tests** for your changes

4. **Run the test suite**:
   ```bash
   pytest
   ```

5. **Run linting and formatting**:
   ```bash
   ruff check . --fix
   black .
   mypy src/
   ```

6. **Update documentation** if needed

7. **Update CHANGELOG.md** under `[Unreleased]`

## Code Style

We use automated tools to maintain consistent code style:

### Formatting & Linting

- **Black** — Code formatting (line length: 100)
- **Ruff** — Fast Python linter
- **MyPy** — Static type checking

```bash
# Format code
black .

# Check for issues
ruff check .

# Auto-fix issues
ruff check . --fix

# Type checking
mypy src/
```

### Docstrings

We follow Google-style docstrings:

```python
def calculate_elo(rating_a: float, rating_b: float, score_a: float) -> tuple[float, float]:
    """
    Calculate new ELO ratings after a match.
    
    Args:
        rating_a: Current rating of player A.
        rating_b: Current rating of player B.
        score_a: Actual score for player A (1.0=win, 0.5=draw, 0.0=loss).
        
    Returns:
        Tuple of (new_rating_a, new_rating_b).
        
    Example:
        >>> new_a, new_b = calculate_elo(1200, 1000, 1.0)
        >>> print(f"A gained {new_a - 1200:.0f} points")
    """
    ...
```

### Type Hints

All public functions should have type hints:

```python
from typing import Optional

def test_prompt(
    prompt: str,
    models: list[str],
    temperature: Optional[float] = None,
) -> list[TestResult]:
    ...
```

## Testing

### Running Tests

```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=promptmachine_eval --cov-report=html

# Run specific test file
pytest tests/test_elo.py

# Run specific test
pytest tests/test_elo.py::TestEloCalculator::test_expected_score_equal_ratings

# Run with verbose output
pytest -v
```

### Writing Tests

- Place tests in `tests/` directory
- Name test files `test_*.py`
- Use descriptive test names: `test_update_ratings_winner_gains`
- Use fixtures for common setup
- Aim for >80% coverage on new code

```python
import pytest
from promptmachine_eval import EloCalculator

class TestEloCalculator:
    """Tests for EloCalculator class."""
    
    def test_equal_ratings_give_fifty_percent(self) -> None:
        """Equal ratings should give 50% expected score."""
        calc = EloCalculator()
        score = calc.expected_score(1000, 1000)
        assert abs(score - 0.5) < 0.001
```

## Submitting Changes

### Pull Request Process

1. **Push your branch** to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

2. **Open a Pull Request** against `master`

3. **Fill out the PR template** completely

4. **Wait for review** — maintainers will review your PR

5. **Address feedback** — make requested changes

6. **Merge!** — Once approved, we'll merge your PR

### PR Requirements

- [ ] All tests pass
- [ ] Linting passes (`ruff`, `black`, `mypy`)
- [ ] Documentation updated (if applicable)
- [ ] CHANGELOG.md updated
- [ ] PR description is complete

## Release Process

Releases are handled by maintainers:

1. Version bump in `pyproject.toml` and `__init__.py`
2. Update CHANGELOG.md with release date
3. Create a GitHub Release with tag `v0.X.Y`
4. GitHub Actions automatically publishes to PyPI

## Getting Help

- 💬 [GitHub Discussions](https://github.com/framersai/promptmachine-eval/discussions)
- 📧 Email: [team@frame.dev](mailto:team@frame.dev)
- 🐦 Twitter: [@framedev](https://twitter.com/framedev)

## Recognition

Contributors are recognized in:

- CHANGELOG.md for their contributions
- GitHub's contributor graphs
- Our documentation site

Thank you for contributing! 🙏

