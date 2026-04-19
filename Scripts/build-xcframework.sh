#!/usr/bin/env zsh
# build-xcframework.sh
# LiquidGlass Framework
# © 2026 — Private Library
#
# Usage:
#   chmod +x Scripts/build-xcframework.sh
#   ./Scripts/build-xcframework.sh
#
# Output: build/LiquidGlass.xcframework

set -euo pipefail

SCHEME="LiquidGlass"
PROJECT="LiquidGlass.xcodeproj"
BUILD_DIR="$(pwd)/build"
ARCHIVES_DIR="$BUILD_DIR/archives"
OUTPUT="$BUILD_DIR/LiquidGlass.xcframework"

echo "▶ LiquidGlass XCFramework build"
echo "  Project : $PROJECT"
echo "  Output  : $OUTPUT"
echo ""

# Clean previous output
rm -rf "$BUILD_DIR"
mkdir -p "$ARCHIVES_DIR"

# ─────────────────────────────────────────────
# Helper: archive a single destination
# ─────────────────────────────────────────────
archive() {
  local destination="$1"
  local archive_name="$2"
  local archive_path="$ARCHIVES_DIR/$archive_name.xcarchive"

  echo "  Archiving [$archive_name] → $archive_path"

  xcodebuild archive \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -destination "$destination" \
    -archivePath "$archive_path" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    | grep -E "^(error:|warning:|Build (succeeded|FAILED))" || true

  echo "  ✓ $archive_name"
}

# ─────────────────────────────────────────────
# Archive all slices
# ─────────────────────────────────────────────
archive "generic/platform=iOS"                     "iphoneos"
archive "generic/platform=iOS Simulator"           "iphonesimulator"
archive "generic/platform=macOS"                   "macosx"
archive "generic/platform=tvOS"                    "appletvos"
archive "generic/platform=tvOS Simulator"          "appletvsimulator"
archive "generic/platform=watchOS"                 "watchos"
archive "generic/platform=watchOS Simulator"       "watchsimulator"

# ─────────────────────────────────────────────
# Combine into XCFramework
# ─────────────────────────────────────────────
echo ""
echo "▶ Creating XCFramework…"

xcodebuild -create-xcframework \
  -framework "$ARCHIVES_DIR/iphoneos.xcarchive/Products/Library/Frameworks/$SCHEME.framework" \
  -framework "$ARCHIVES_DIR/iphonesimulator.xcarchive/Products/Library/Frameworks/$SCHEME.framework" \
  -framework "$ARCHIVES_DIR/macosx.xcarchive/Products/Library/Frameworks/$SCHEME.framework" \
  -framework "$ARCHIVES_DIR/appletvos.xcarchive/Products/Library/Frameworks/$SCHEME.framework" \
  -framework "$ARCHIVES_DIR/appletvsimulator.xcarchive/Products/Library/Frameworks/$SCHEME.framework" \
  -framework "$ARCHIVES_DIR/watchos.xcarchive/Products/Library/Frameworks/$SCHEME.framework" \
  -framework "$ARCHIVES_DIR/watchsimulator.xcarchive/Products/Library/Frameworks/$SCHEME.framework" \
  -output "$OUTPUT"

echo ""
echo "✅ Done! XCFramework at:"
echo "   $OUTPUT"
