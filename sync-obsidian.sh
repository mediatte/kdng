#!/bin/bash
set -e

# Sync Obsidian vault to Quartz content folder and publish

QUARTZ_DIR="/Users/jlee0724/PAGE/quartz"
OBSIDIAN_PATH="/Users/jlee0724/obsidian/mediatte/KDNG"
CONTENT_PATH="content"

REMOTE_URL="https://github.com/mediatte/kdng.git"
SOURCE_BRANCH="v4"
DEPLOY_BRANCH="main"

echo "📁 Moving to Quartz directory..."
cd "$QUARTZ_DIR" || {
  echo "❌ Quartz directory not found: $QUARTZ_DIR"
  exit 1
}

echo ""
echo "🔍 Checking Git repository..."
if [ ! -d ".git" ]; then
  echo "❌ Not a git repository: $QUARTZ_DIR"
  exit 1
fi

echo ""
echo "🔐 Setting GitHub remote..."
git remote set-url origin "$REMOTE_URL"
git remote -v

echo ""
echo "🌿 Switching to $SOURCE_BRANCH..."
git checkout "$SOURCE_BRANCH"

echo ""
echo "📦 Syncing Obsidian vault to Quartz content folder..."
rsync -av --delete "$OBSIDIAN_PATH/" "$CONTENT_PATH/" \
  --exclude='.obsidian' \
  --exclude='.trash' \
  --exclude='.DS_Store'

echo ""
echo "📝 Git status:"
git status --short

echo ""
echo "🔎 Checking Explorer layout..."
if grep -q "Component.Explorer" quartz.layout.ts; then
  echo "✅ Explorer found in quartz.layout.ts"
else
  echo "⚠️ Explorer not found in quartz.layout.ts"
  echo "   Add Component.Explorer() to your left layout."
fi

echo ""
echo "🏗️ Building Quartz locally..."
npx quartz build

echo ""
echo "💾 Committing changes if any..."
if [[ -n $(git status --porcelain) ]]; then
  git add .
  git commit -m "Quartz sync: $(date '+%Y-%m-%d %H:%M')"
else
  echo "ℹ️ No file changes to commit."
fi

echo ""
echo "🚀 Pushing $SOURCE_BRANCH..."
git push origin "$SOURCE_BRANCH"

echo ""
echo "🚀 Pushing $SOURCE_BRANCH to $DEPLOY_BRANCH..."
git push origin "$SOURCE_BRANCH:$DEPLOY_BRANCH" --force-with-lease

echo ""
echo "✅ Done. Obsidian content, Quartz config, $SOURCE_BRANCH, and $DEPLOY_BRANCH are synced."
echo "🌐 Check GitHub Actions / Pages after deployment finishes."
