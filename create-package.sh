#!/bin/bash
# Create .plasmoid package for ActionPad

echo "=========================================="
echo "  Creating ActionPad Package"
echo "=========================================="
echo ""

PACKAGE_NAME="actionpad"
VERSION="1.0.0"
BUILD_DIR="build"
PACKAGE_DIR="package"
OUTPUT_FILE="${PACKAGE_NAME}-${VERSION}.plasmoid"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if package directory exists
if [ ! -d "$PACKAGE_DIR" ]; then
    echo -e "${RED}ERROR: Package directory not found!${NC}"
    echo "Expected: $PACKAGE_DIR"
    exit 1
fi

# Verify required files exist
echo "Verifying package contents..."
REQUIRED_FILES=(
    "$PACKAGE_DIR/metadata.json"
    "$PACKAGE_DIR/contents/ui/main.qml"
    "$PACKAGE_DIR/contents/ui/configGeneral.qml"
    "$PACKAGE_DIR/contents/config/main.xml"
    "$PACKAGE_DIR/contents/config/config.qml"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}ERROR: Required file missing: $file${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓${NC} $file"
done

echo ""
echo "Creating .plasmoid package..."

# Create the plasmoid package (it's just a zip file with .plasmoid extension)
cd "$PACKAGE_DIR" || exit 1
zip -r "../$OUTPUT_FILE" . -x "*.git*" -x "*~" -x "*.swp"
cd ..

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}SUCCESS!${NC} Package created: $OUTPUT_FILE"
    echo ""
    
    # Show package info
    echo "Package Information:"
    echo "  File: $OUTPUT_FILE"
    echo "  Size: $(du -h "$OUTPUT_FILE" | cut -f1)"
    echo ""
    
    # Show contents
    echo "Package contents:"
    unzip -l "$OUTPUT_FILE" | tail -n +4 | head -n -2
    echo ""
    
    echo -e "${YELLOW}Note:${NC} This package only includes the QML widget."
    echo "The C++ plugin must be built and installed separately using:"
    echo "  ./build-and-install.sh"
    echo ""
    echo "Installation options:"
    echo "  1. System-wide: kpackagetool6 -t Plasma/Applet -i $OUTPUT_FILE"
    echo "  2. User-only:   kpackagetool6 -t Plasma/Applet -g -i $OUTPUT_FILE"
    echo "  3. GUI:         Right-click panel → Add Widgets → Install Widget From Local File"
    echo ""
else
    echo -e "${RED}ERROR: Failed to create package!${NC}"
    exit 1
fi

