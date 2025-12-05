# Setting Up as Standalone Repository

This guide explains how to set up `promptmachine-eval` as its own GitHub repository while keeping it linked to the main `promptmachine` monorepo.

## Architecture Overview

```
framersai/promptmachine (monorepo)
├── frontend/
├── backend/
├── docs/
└── packages/
    └── promptmachine-eval/  ← git submodule pointing to ↓

framersai/promptmachine-eval (standalone repo)
├── src/promptmachine_eval/
├── tests/
├── pyproject.toml
└── ...
```

## Option 1: Git Submodule (Recommended)

### Step 1: Create the Standalone Repository

```bash
# Navigate to the package directory
cd /path/to/promptmachine/packages/promptmachine-eval

# Initialize as a new git repo (if not already)
git init

# Add all files
git add .

# Initial commit
git commit -m "feat: initial release of promptmachine-eval

- ELO rating system with configurable K-factor
- Monte Carlo matchmaking for optimal battle pairings  
- Arena battles with LLM-as-judge evaluation
- Cost tracking for 30+ models
- CLI tool (pm-eval) for testing and battles
- Comprehensive test suite"

# Create GitHub repo (using gh CLI)
gh repo create framersai/promptmachine-eval \
  --public \
  --description "LLM evaluation framework with ELO ratings, arena battles, and benchmark testing" \
  --homepage "https://promptmachine.io/docs/eval"

# Add remote and push
git remote add origin https://github.com/framersai/promptmachine-eval.git
git branch -M master
git push -u origin master
```

### Step 2: Remove from Monorepo and Add as Submodule

```bash
# From the monorepo root
cd /path/to/promptmachine

# Remove the package directory (but keep it backed up first!)
mv packages/promptmachine-eval /tmp/promptmachine-eval-backup

# Add as submodule
git submodule add https://github.com/framersai/promptmachine-eval.git packages/promptmachine-eval

# Commit the submodule addition
git add .gitmodules packages/promptmachine-eval
git commit -m "chore: add promptmachine-eval as submodule"
```

### Step 3: Working with the Submodule

```bash
# Clone monorepo with submodules
git clone --recurse-submodules https://github.com/framersai/promptmachine.git

# Or update submodules after clone
git submodule update --init --recursive

# Pull latest changes in submodule
cd packages/promptmachine-eval
git pull origin master

# Or from monorepo root
git submodule update --remote packages/promptmachine-eval
```

## Option 2: Git Subtree

Alternative approach using subtrees (no `.gitmodules` file):

```bash
# Add subtree
git subtree add --prefix=packages/promptmachine-eval \
  https://github.com/framersai/promptmachine-eval.git master --squash

# Pull updates
git subtree pull --prefix=packages/promptmachine-eval \
  https://github.com/framersai/promptmachine-eval.git master --squash

# Push changes back to standalone repo
git subtree push --prefix=packages/promptmachine-eval \
  https://github.com/framersai/promptmachine-eval.git master
```

## GitHub Repository Settings

### Recommended Settings for promptmachine-eval

1. **General**
   - Description: "LLM evaluation framework with ELO ratings, arena battles, and benchmark testing"
   - Website: https://promptmachine.io/docs/eval
   - Topics: `llm`, `evaluation`, `benchmark`, `elo`, `gpt`, `claude`, `ai`, `python`

2. **Features**
   - ✅ Issues
   - ✅ Discussions
   - ✅ Projects (optional)
   - ✅ Wiki (optional)

3. **Branches**
   - Default branch: `master`
   - Branch protection on `master`:
     - ✅ Require pull request reviews
     - ✅ Require status checks (CI)
     - ✅ Require conversation resolution

4. **Environments**
   - `testpypi` - For test releases
   - `pypi` - For production releases (add trusted publishing)

5. **Secrets**
   - `CODECOV_TOKEN` - For coverage reports

### Setting Up Trusted Publishing (PyPI)

1. Go to https://pypi.org/manage/account/publishing/
2. Add new pending publisher:
   - PyPI Project Name: `promptmachine-eval`
   - Owner: `framersai`
   - Repository: `promptmachine-eval`
   - Workflow: `publish.yml`
   - Environment: `pypi`

## Directory Structure After Setup

```
promptmachine/
├── .git/
├── .gitmodules          # New file listing submodules
├── frontend/
├── backend/
├── docs/
└── packages/
    └── promptmachine-eval/  # Submodule (has its own .git)
        ├── .git → ../../../.git/modules/packages/promptmachine-eval
        ├── src/
        ├── tests/
        └── ...
```

## CI/CD Integration

The standalone repo has its own CI/CD that runs independently. The monorepo can also run tests:

### Monorepo CI (`.github/workflows/ci.yml`)

```yaml
# Add job to test the Python package
test-eval-package:
  runs-on: ubuntu-latest
  defaults:
    run:
      working-directory: packages/promptmachine-eval
  steps:
    - uses: actions/checkout@v4
      with:
        submodules: recursive
    
    - uses: actions/setup-python@v5
      with:
        python-version: '3.11'
    
    - run: pip install -e ".[dev]"
    - run: pytest
```

## Release Workflow

1. **Develop in standalone repo**
   ```bash
   cd packages/promptmachine-eval
   git checkout -b feature/new-feature
   # Make changes...
   git commit -m "feat: add new feature"
   git push origin feature/new-feature
   # Open PR in framersai/promptmachine-eval
   ```

2. **After merge to master**
   - CI runs automatically
   - Create GitHub release for PyPI publish

3. **Update monorepo submodule**
   ```bash
   cd /path/to/promptmachine
   git submodule update --remote packages/promptmachine-eval
   git add packages/promptmachine-eval
   git commit -m "chore: update promptmachine-eval to v0.2.0"
   git push
   ```

## Quick Commands Reference

```bash
# Initialize submodule after fresh clone
git submodule update --init --recursive

# Update submodule to latest
git submodule update --remote

# Check submodule status
git submodule status

# Enter submodule and work
cd packages/promptmachine-eval
git checkout master
git pull

# Commit submodule update in parent
cd ../..
git add packages/promptmachine-eval
git commit -m "chore: update promptmachine-eval submodule"
```

