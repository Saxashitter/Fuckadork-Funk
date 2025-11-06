#!/bin/bash
# Check if path is provided as an argument

GAME_DIR="$PWD/src"
# Check if the directory exists
if [ ! -d "$GAME_DIR" ]; then
  echo "Directory not found: $GAME_DIR"
  exit 1
fi

# Navigate to the game directory
cd "$GAME_DIR" || exit

# Create the .love file
zip -r game.love *

# Share the .love file using termux-share
termux-share -d game.love