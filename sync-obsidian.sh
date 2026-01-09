#!/bin/bash
# Sync Obsidian vault to Quartz content folder and publish

OBSIDIAN_PATH="/Users/jlee0724/obsidian/mediatte/KDNG"
CONTENT_PATH="content"

echo "🔄 Step 1/2: Syncing Obsidian vault to Quartz content folder..."
rsync -av --delete "$OBSIDIAN_PATH/" "$CONTENT_PATH/" \
  --exclude='.obsidian' \
  --exclude='.trash' \
  --exclude='.DS_Store'

echo ""
echo "✅ Obsidian sync complete!"
echo ""
echo "📝 Modified files:"
git status --short content/

# Check if there are any changes to sync
if [[ -z $(git status --porcelain content/) ]]; then
  echo ""
  echo "ℹ️  No changes detected. Content is already up to date."
  exit 0
fi

echo ""
echo "🔄 Step 2/2: Running quartz sync to commit and publish..."
echo ""

# Run quartz sync to commit and push changes
npx quartz sync

echo ""
echo "🎉 All done! Your changes have been synced and published."
