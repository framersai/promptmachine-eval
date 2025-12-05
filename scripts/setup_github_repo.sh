#!/bin/bash
#
# Setup script to create the standalone GitHub repository
# for promptmachine-eval
#
# Prerequisites:
#   - GitHub CLI (gh) installed and authenticated
#   - Git configured with your credentials
#
# Usage:
#   chmod +x scripts/setup_github_repo.sh
#   ./scripts/setup_github_repo.sh
#

set -e

# Configuration
GITHUB_ORG="${GITHUB_ORG:-framersai}"
REPO_NAME="promptmachine-eval"
DESCRIPTION="LLM evaluation framework with ELO ratings, arena battles, and benchmark testing"
HOMEPAGE="https://promptmachine.io/docs/eval"

echo "🚀 Setting up promptmachine-eval as standalone GitHub repository"
echo "   Organization: $GITHUB_ORG"
echo "   Repository: $REPO_NAME"
echo ""

# Check prerequisites
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) not found. Install from https://cli.github.com/"
    exit 1
fi

if ! gh auth status &> /dev/null; then
    echo "❌ Not authenticated with GitHub CLI. Run: gh auth login"
    exit 1
fi

# Navigate to package directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PACKAGE_DIR"

echo "📁 Working directory: $PACKAGE_DIR"

# Check if already a git repo
if [ -d ".git" ]; then
    echo "⚠️  Git repository already exists"
    read -p "   Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo "📦 Initializing git repository..."
    git init
fi

# Add all files
echo "📝 Staging all files..."
git add .

# Check if there's anything to commit
if git diff --cached --quiet; then
    echo "   No changes to commit"
else
    echo "💾 Creating initial commit..."
    git commit -m "feat: initial release of promptmachine-eval v0.1.0

🏆 LLM Evaluation Framework

Features:
- ELO rating system with configurable K-factor and uncertainty tracking
- Monte Carlo matchmaking for optimal battle pairings
- Arena battles with LLM-as-judge evaluation
- Prompt testing across multiple providers (OpenAI, Anthropic, OpenRouter)
- Cost tracking and estimation for 30+ models
- CLI tool (pm-eval) with test, battle, cost, and models commands
- Comprehensive test suite with >80% coverage
- Markdown report generation

Supported Providers:
- OpenAI (GPT-4o, GPT-4o-mini, o1-preview, o1-mini)
- Anthropic (Claude 3.5 Sonnet, Claude 3.5 Haiku, Claude 3 Opus)
- OpenRouter (Gemini, Llama, Mistral, DeepSeek, Qwen, and more)

Documentation: https://promptmachine.io/docs/eval
"
fi

# Check if repo already exists
if gh repo view "$GITHUB_ORG/$REPO_NAME" &> /dev/null; then
    echo "⚠️  Repository $GITHUB_ORG/$REPO_NAME already exists"
    REPO_EXISTS=true
else
    REPO_EXISTS=false
fi

# Create GitHub repository
if [ "$REPO_EXISTS" = false ]; then
    echo "🌐 Creating GitHub repository..."
    gh repo create "$GITHUB_ORG/$REPO_NAME" \
        --public \
        --description "$DESCRIPTION" \
        --homepage "$HOMEPAGE" \
        --source=. \
        --remote=origin \
        --push
else
    # Just add remote and push
    echo "🔗 Adding remote..."
    git remote remove origin 2>/dev/null || true
    git remote add origin "https://github.com/$GITHUB_ORG/$REPO_NAME.git"
    
    echo "⬆️  Pushing to GitHub..."
    git branch -M master
    git push -u origin master --force
fi

# Add topics
echo "🏷️  Adding repository topics..."
gh repo edit "$GITHUB_ORG/$REPO_NAME" \
    --add-topic llm \
    --add-topic evaluation \
    --add-topic benchmark \
    --add-topic elo \
    --add-topic gpt \
    --add-topic claude \
    --add-topic ai \
    --add-topic python \
    --add-topic openai \
    --add-topic anthropic

# Enable features
echo "⚙️  Configuring repository settings..."
gh repo edit "$GITHUB_ORG/$REPO_NAME" \
    --enable-issues \
    --enable-wiki=false \
    --enable-discussions

echo ""
echo "✅ Repository created successfully!"
echo ""
echo "📋 Next steps:"
echo "   1. Set up branch protection rules:"
echo "      gh browse -R $GITHUB_ORG/$REPO_NAME -- /settings/branches"
echo ""
echo "   2. Set up PyPI trusted publishing:"
echo "      - Go to https://pypi.org/manage/account/publishing/"
echo "      - Add pending publisher for: $GITHUB_ORG/$REPO_NAME"
echo ""
echo "   3. Add secrets (optional):"
echo "      gh secret set CODECOV_TOKEN --body \"your-token\""
echo ""
echo "   4. Create first release:"
echo "      gh release create v0.1.0 --title \"v0.1.0\" --notes \"Initial release\""
echo ""
echo "🔗 Repository URL: https://github.com/$GITHUB_ORG/$REPO_NAME"

