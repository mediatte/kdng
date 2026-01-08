#!/bin/bash
# Sync Obsidian vault to Quartz content folder

OBSIDIAN_PATH="/Users/jlee0724/obsidian/mediatte/KDNG"
CONTENT_PATH="content"

echo "🔄 Syncing Obsidian vault to Quartz content folder..."
rsync -av --delete "$OBSIDIAN_PATH/" "$CONTENT_PATH/" \
  --exclude='.obsidian' \
  --exclude='.trash' \
  --exclude='.DS_Store'

echo "✅ Sync complete!"
echo ""
echo "📝 Modified files:"
git status --short content/

echo ""
echo "💡 Next steps:"
echo "   1. Review changes: git diff"
echo "   2. Commit and push: git add . && git commit -m 'Update content' && git push"
