#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Move File to home Obsidian
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🔮

# Documentation:
# @raycast.author ksemele
# @raycast.authorURL https://raycast.com/ksemele

# ✏️ Specify your directory here
TARGET_DIR="$HOME/obsidian/home"

# Get the path from the clipboard
FILE_PATH=$(pbpaste)

# Checks
if [ -z "$FILE_PATH" ]; then
  echo "❌ Clipboard is empty"
  exit 1
fi

if [ ! -e "$FILE_PATH" ]; then
  echo "❌ File not found: $FILE_PATH"
  exit 1
fi

FILENAME=$(basename "$FILE_PATH")

# Confirmation dialog with details
osascript -e "display dialog \"Move file?\n\n📄 $FILE_PATH\n📁 → $TARGET_DIR\" buttons {\"Cancel\", \"Move\"} default button \"Move\" with icon caution" 2>/dev/null

if [ $? -ne 0 ]; then
  echo "⏭️ Cancelled"
  exit 0
fi

if [ ! -d "$TARGET_DIR" ]; then
  mkdir -p "$TARGET_DIR"
fi

mv "$FILE_PATH" "$TARGET_DIR/$FILENAME"

echo "✅ Moved: $FILE_PATH → $TARGET_DIR"
