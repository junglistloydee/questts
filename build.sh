#!/bin/bash

# Define release name
RELEASE_NAME="QuestNarrator"
RELEASE_DIR="release"
ZIP_FILE="$RELEASE_DIR/$RELEASE_NAME.zip"

# Create the release directory if it doesn't exist
mkdir -p $RELEASE_DIR

# Remove old zip file if it exists
rm -f $ZIP_FILE

# Create the zip archive with both the addon and the TTS application
echo "Creating archive: $ZIP_FILE"
zip -r $ZIP_FILE QuestNarrator/ QuestNarrator_TTS/

echo "Build complete."