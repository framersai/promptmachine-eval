#!/bin/bash
#
# Script to add promptmachine-eval as a submodule to the main monorepo
#
# Run this from the MONOREPO root directory after the standalone repo is created
#
# Usage:
#   cd /path/to/promptmachine  # monorepo root
#   bash packages/promptmachine-eval/scripts/add_as_submodule.sh
#

set -e

GITHUB_ORG="${GITHUB_ORG:-framersai}"
REPO_NAME="promptmachine-eval"
SUBMODULE_PATH="packages/promptmachine-eval"

echo "📦 Adding promptmachine-eval as a git submodule"
echo ""

# Check if we're in the monorepo root
if [ ! -f "README.md" ] || [ ! -d "frontend" ]; then
    echo "❌ This script should be run from the promptmachine monorepo root"
    exit 1
fi

# Check if path exists
if [ -d "$SUBMODULE_PATH" ]; then
    echo "⚠️  $SUBMODULE_PATH already exists"
    echo "   Backing up to /tmp/..."
    mv "$SUBMODULE_PATH" "/tmp/promptmachine-eval-backup-$(date +%s)"
fi

# Remove from git index if tracked
git rm -rf --cached "$SUBMODULE_PATH" 2>/dev/null || true

# Add submodule
echo "🔗 Adding submodule..."
git submodule add "https://github.com/$GITHUB_ORG/$REPO_NAME.git" "$SUBMODULE_PATH"

# Update .gitmodules to track main branch
echo "📝 Configuring submodule to track main branch..."
git config -f .gitmodules "submodule.$SUBMODULE_PATH.branch" master

# Commit
echo "💾 Committing submodule addition..."
git add .gitmodules "$SUBMODULE_PATH"
git commit -m "chore: add promptmachine-eval as git submodule

The evaluation package is now maintained in its own repository:
https://github.com/$GITHUB_ORG/$REPO_NAME

This allows for:
- Independent versioning and releases
- Separate CI/CD pipeline
- Easy pip installation from PyPI
- Community contributions to the package alone"

echo ""
echo "✅ Submodule added successfully!"
echo ""
echo "📋 Common submodule commands:"
echo "   # Clone with submodules"
echo "   git clone --recurse-submodules <repo-url>"
echo ""
echo "   # Update submodule to latest"
echo "   git submodule update --remote $SUBMODULE_PATH"
echo ""
echo "   # Work inside submodule"
echo "   cd $SUBMODULE_PATH"
echo "   git checkout master && git pull"

