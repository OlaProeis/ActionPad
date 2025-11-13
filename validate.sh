#!/bin/bash
# Quick validation script for ActionPad

echo "=========================================="
echo "  ActionPad - Quick Validation"
echo "=========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASS=0
FAIL=0

# Test function
test_item() {
    local name="$1"
    local command="$2"
    
    echo -n "Testing: $name... "
    if eval "$command" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ PASS${NC}"
        ((PASS++))
    else
        echo -e "${RED}✗ FAIL${NC}"
        ((FAIL++))
    fi
}

# File Tests
echo "=== File Existence Tests ==="
test_item "QML main.qml" "[ -f package/contents/ui/main.qml ]"
test_item "QML config" "[ -f package/contents/ui/configGeneral.qml ]"
test_item "Config XML" "[ -f package/contents/config/main.xml ]"
test_item "Metadata" "[ -f package/metadata.json ]"
test_item "C++ plugin source" "[ -f plugin/commandexecutor.cpp ]"
test_item "CMakeLists.txt" "[ -f CMakeLists.txt ]"
test_item "Build script" "[ -f build-and-install.sh ]"
test_item ".plasmoid package" "[ -f shortcutwidget-1.0.0.plasmoid ]"
echo ""

# Documentation Tests
echo "=== Documentation Tests ==="
test_item "README.md" "[ -f README.md ]"
test_item "LICENSE" "[ -f LICENSE ]"
test_item "CHANGELOG.md" "[ -f CHANGELOG.md ]"
test_item "CONTRIBUTING.md" "[ -f CONTRIBUTING.md ]"
test_item "User Guide" "[ -f docs/USER_GUIDE.md ]"
test_item "Configuration docs" "[ -f docs/CONFIGURATION.md ]"
test_item "Examples" "[ -f docs/EXAMPLES.md ]"
test_item "Troubleshooting" "[ -f docs/TROUBLESHOOTING.md ]"
test_item "Testing checklist" "[ -f TESTING_CHECKLIST.md ]"
test_item "KDE Store guide" "[ -f KDE_STORE_GUIDE.md ]"
echo ""

# Installation Tests
echo "=== Installation Tests ==="
test_item "Widget installed (system)" "kpackagetool6 -t Plasma/Applet --list | grep -q 'com.github.shortcutwidget'"
test_item "C++ plugin exists" "[ -f /usr/lib64/qt6/qml/com/github/shortcutwidget/libshortcutwidgetplugin.so ]"
test_item "QML files installed" "[ -f /usr/share/plasma/plasmoids/com.github.shortcutwidget/contents/ui/main.qml ]"
test_item "Metadata installed" "[ -f /usr/share/plasma/plasmoids/com.github.shortcutwidget/metadata.json ]"
echo ""

# Build Tests
echo "=== Build Environment Tests ==="
test_item "CMake installed" "command -v cmake"
test_item "Make installed" "command -v make"
test_item "C++ compiler (g++)" "command -v g++"
test_item "Qt6 qmake" "command -v qmake6 || command -v qmake"
test_item "kpackagetool6" "command -v kpackagetool6"
echo ""

# Package Validation
echo "=== Package Validation ==="
if [ -f shortcutwidget-1.0.0.plasmoid ]; then
    echo -n "Package file size... "
    SIZE=$(stat -f%z shortcutwidget-1.0.0.plasmoid 2>/dev/null || stat -c%s shortcutwidget-1.0.0.plasmoid 2>/dev/null)
    if [ "$SIZE" -gt 10000 ]; then
        echo -e "${GREEN}✓ PASS${NC} ($SIZE bytes)"
        ((PASS++))
    else
        echo -e "${RED}✗ FAIL${NC} (too small: $SIZE bytes)"
        ((FAIL++))
    fi
    
    echo -n "Package contains metadata.json... "
    if unzip -l shortcutwidget-1.0.0.plasmoid | grep -q "metadata.json"; then
        echo -e "${GREEN}✓ PASS${NC}"
        ((PASS++))
    else
        echo -e "${RED}✗ FAIL${NC}"
        ((FAIL++))
    fi
    
    echo -n "Package contains main.qml... "
    if unzip -l shortcutwidget-1.0.0.plasmoid | grep -q "main.qml"; then
        echo -e "${GREEN}✓ PASS${NC}"
        ((PASS++))
    else
        echo -e "${RED}✗ FAIL${NC}"
        ((FAIL++))
    fi
else
    echo -e "${YELLOW}! SKIP${NC} Package not found (run ./create-package.sh first)"
    ((FAIL+=3))
fi
echo ""

# Summary
echo "=========================================="
echo "  Test Summary"
echo "=========================================="
echo -e "Passed: ${GREEN}$PASS${NC}"
echo -e "Failed: ${RED}$FAIL${NC}"
echo "Total:  $((PASS + FAIL))"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed!${NC}"
    echo "Widget is ready for publication."
    exit 0
else
    echo -e "${YELLOW}⚠ Some tests failed.${NC}"
    echo "Review failures before publishing."
    exit 1
fi

