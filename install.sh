#!/bin/bash
# Installation script for KDE Plasma Shortcut Widget

echo "=== KDE Plasma Shortcut Widget Installer ==="
echo ""

# Detect which packaging tool to use
if command -v kpackagetool6 &> /dev/null; then
    PACKAGE_TOOL="kpackagetool6"
    echo "Using kpackagetool6 (Plasma 6)"
elif command -v kpackagetool5 &> /dev/null; then
    PACKAGE_TOOL="kpackagetool5"
    echo "Using kpackagetool5 (Plasma 5)"
elif command -v plasmapkg2 &> /dev/null; then
    PACKAGE_TOOL="plasmapkg2"
    echo "Using plasmapkg2"
else
    echo "ERROR: No KDE package tool found. Please install KDE Plasma development tools."
    exit 1
fi

echo ""

# Check if widget is already installed
if $PACKAGE_TOOL --type=Plasma/Applet --list | grep -q "com.github.shortcutwidget"; then
    echo "Widget is already installed. Upgrading..."
    $PACKAGE_TOOL --type=Plasma/Applet --upgrade package
    if [ $? -eq 0 ]; then
        echo ""
        echo "SUCCESS: Widget upgraded successfully!"
    else
        echo ""
        echo "ERROR: Failed to upgrade widget."
        exit 1
    fi
else
    echo "Installing widget..."
    $PACKAGE_TOOL --type=Plasma/Applet --install package
    if [ $? -eq 0 ]; then
        echo ""
        echo "SUCCESS: Widget installed successfully!"
    else
        echo ""
        echo "ERROR: Failed to install widget."
        exit 1
    fi
fi

echo ""
echo "To use the widget:"
echo "1. Right-click on your panel or desktop"
echo "2. Select 'Add Widgets'"
echo "3. Search for 'Shortcut Widget'"
echo "4. Drag it to your desired location"
echo ""
echo "To configure:"
echo "- Right-click the widget and select 'Configure'"
echo ""

