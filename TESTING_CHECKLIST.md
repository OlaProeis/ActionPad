# Testing Checklist

Complete testing guide before publishing Shortcut Widget.

## Pre-Publication Testing

### ✅ Installation Testing

#### Method 1: From Source (build-and-install.sh)
- [ ] Clean build succeeds without errors
- [ ] C++ plugin installs to correct location
- [ ] QML widget installs to correct location
- [ ] Widget appears in widget list after restart

**Test Command:**
```bash
./build-and-install.sh
killall plasmashell && plasmashell &
```

#### Method 2: .plasmoid Package
- [ ] Package file is valid (16KB, contains all files)
- [ ] Install via kpackagetool6 succeeds
- [ ] Install via GUI widget installer succeeds
- [ ] Widget appears in widget list

**Test Commands:**
```bash
# Create package
./create-package.sh

# Test system-wide install
kpackagetool6 -t Plasma/Applet -i shortcutwidget-1.0.0.plasmoid

# Or test user install
kpackagetool6 -t Plasma/Applet -g -i shortcutwidget-1.0.0.plasmoid

# Restart Plasma
killall plasmashell && plasmashell &
```

#### Method 3: GUI Installation
- [ ] Right-click panel → "Add Widgets"
- [ ] Click "Get New Widgets" → "Install from File"
- [ ] Select `.plasmoid` file
- [ ] Installation succeeds
- [ ] Widget appears in list

---

### ✅ Basic Functionality

#### Widget Loading
- [ ] Widget loads on panel without errors
- [ ] Widget loads on desktop without errors
- [ ] Default "Hello World" button appears
- [ ] Configuration dialog opens

#### Button Actions - Scripts
- [ ] Simple script executes (`echo "test"`)
- [ ] Script with path executes (`/path/to/script.sh`)
- [ ] Script with arguments works
- [ ] Terminal mode shows output
- [ ] Working directory is respected
- [ ] Script errors are handled gracefully

**Test Script (`test-script.sh`):**
```bash
#!/bin/bash
echo "Working directory: $(pwd)"
echo "Arguments: $@"
echo "Test successful!"
```

#### Button Actions - Applications
- [ ] Application launches by name (`firefox`)
- [ ] Application launches with path (`/usr/bin/kate`)
- [ ] Application with arguments works
- [ ] Invalid app name handled gracefully

#### Button Actions - URLs
- [ ] URL with https:// opens in browser
- [ ] URL without protocol opens (auto-adds https://)
- [ ] localhost URLs work
- [ ] Invalid URLs handled gracefully

---

### ✅ Configuration Testing

#### Add Buttons
- [ ] "Add New Button" creates button
- [ ] Button appears in list
- [ ] Button appears in widget
- [ ] Changes persist after Plasma restart

#### Edit Buttons
- [ ] "Edit" button opens dialog
- [ ] All fields populate correctly
- [ ] Changes save correctly
- [ ] Changes appear in widget immediately

#### Delete Buttons
- [ ] "Delete" removes button from list
- [ ] Button removed from widget
- [ ] Changes persist after restart

#### Reorder Buttons
- [ ] "Move Up" changes order
- [ ] "Move Down" changes order
- [ ] Order changes reflected in widget
- [ ] Order persists after restart

---

### ✅ Icon Testing

#### System Icon Picker
- [ ] "Pick System Icon" button opens dialog
- [ ] Can browse icon categories
- [ ] Can search for icons
- [ ] Selected icon appears in preview
- [ ] Selected icon appears on button

#### Custom Icon Files
- [ ] "Browse Custom File" opens file dialog
- [ ] PNG files load correctly
- [ ] SVG files load correctly
- [ ] JPG files load correctly
- [ ] Invalid files handled gracefully

#### Icon-Only Mode
- [ ] Checkbox enables icon-only mode
- [ ] Icon scales to 60% of button size
- [ ] Icon is centered in button
- [ ] Text is hidden
- [ ] Tooltip still shows label

---

### ✅ Color Testing

#### Theme Colors
- [ ] Empty color uses theme colors
- [ ] Theme changes update button colors
- [ ] Light theme looks good
- [ ] Dark theme looks good

#### Color Presets
- [ ] All 16 presets apply correctly
- [ ] Clicking preset updates color field
- [ ] Preset highlights when selected
- [ ] Text color adjusts for readability

#### Custom Colors
- [ ] Hex color (#ff5733) works
- [ ] RGB color (rgb(255,87,51)) works
- [ ] Named color (red, blue) works
- [ ] Color preview shows correctly
- [ ] Invalid colors handled gracefully

#### Text Contrast
- [ ] Text readable on all preset colors
- [ ] Text readable on custom light colors
- [ ] Text readable on custom dark colors
- [ ] Contrast calculation works correctly

---

### ✅ Layout Testing

#### Layout Types
- [ ] Grid layout displays correctly
- [ ] Row layout displays correctly
- [ ] Column layout displays correctly
- [ ] Switching layouts updates widget

#### Button Sizes
- [ ] Small size (48px) looks good
- [ ] Medium size (64px) looks good
- [ ] Large size (96px) looks good
- [ ] Icons scale proportionally

#### Spacing
- [ ] Spacing 0px works (no gaps)
- [ ] Spacing 5px works (default)
- [ ] Spacing 20px works (wide)
- [ ] Spacing updates immediately

#### Grid Columns
- [ ] 1 column works
- [ ] 3 columns works (default)
- [ ] 6 columns works
- [ ] Changes update layout correctly

---

### ✅ Placement Testing

#### Panel Placement
- [ ] Top panel: horizontal layout
- [ ] Bottom panel: horizontal layout
- [ ] Left panel: vertical layout
- [ ] Right panel: vertical layout
- [ ] Respects panel height/width

#### Desktop Placement
- [ ] Desktop widget resizes freely
- [ ] Large button sizes work
- [ ] Many buttons scroll if needed
- [ ] Looks good in corner placement

---

### ✅ Theme Integration

#### Theme Changes
- [ ] Breeze Light theme works
- [ ] Breeze Dark theme works
- [ ] Custom themes work
- [ ] Colors update without restart

#### Visual Consistency
- [ ] Matches KDE Plasma style
- [ ] Border radius consistent
- [ ] Focus indicators work
- [ ] Hover effects work

---

### ✅ Error Handling

#### Invalid Configuration
- [ ] Missing script path shows error/does nothing
- [ ] Invalid app name handled
- [ ] Malformed URL handled
- [ ] Empty button label handled

#### Missing Resources
- [ ] Missing icon falls back to default
- [ ] Missing script shows error
- [ ] Missing app shows error
- [ ] Handles gracefully, doesn't crash

#### Edge Cases
- [ ] 0 buttons (shows placeholder)
- [ ] 50+ buttons (performance OK?)
- [ ] Very long labels (ellipsis)
- [ ] Special characters in labels

---

### ✅ Performance Testing

#### Responsiveness
- [ ] Button clicks respond immediately
- [ ] Configuration opens quickly
- [ ] Icon picker opens quickly
- [ ] Layout changes are smooth

#### Resource Usage
- [ ] Memory usage reasonable (<50MB)
- [ ] CPU usage low when idle
- [ ] No memory leaks over time
- [ ] Smooth animations

---

### ✅ Persistence Testing

#### Configuration Persistence
- [ ] Button data persists after Plasma restart
- [ ] Layout settings persist
- [ ] Color settings persist
- [ ] Icon-only settings persist

#### Upgrade Testing
- [ ] Old config migrates to new version
- [ ] No data loss on upgrade
- [ ] Backward compatible

---

## Test Results

### Environment
- **OS**: Fedora 40
- **Kernel**: 6.17.7
- **KDE Plasma**: 6.0.x
- **Qt Version**: 6.6.x
- **Widget Version**: 1.0.0

### Test Date
- **Date**: ___________
- **Tester**: ___________

### Summary
- **Total Tests**: ___________
- **Passed**: ___________
- **Failed**: ___________
- **Skipped**: ___________

### Known Issues
List any issues found during testing:

1. 
2. 
3. 

---

## Sign-Off

I certify that I have completed the testing checklist and the widget is ready for publication.

**Signature**: ___________  
**Date**: ___________

---

## Quick Test Script

Save this as `quick-test.sh` for rapid testing:

```bash
#!/bin/bash
echo "=== Quick Test Script ==="

# Test 1: Widget is installed
echo -n "Test 1: Widget installed... "
if kpackagetool6 -t Plasma/Applet --list | grep -q "com.github.shortcutwidget"; then
    echo "✓ PASS"
else
    echo "✗ FAIL"
fi

# Test 2: C++ plugin exists
echo -n "Test 2: C++ plugin... "
if [ -f "/usr/lib64/qt6/qml/com/github/shortcutwidget/libshortcutwidgetplugin.so" ]; then
    echo "✓ PASS"
else
    echo "✗ FAIL"
fi

# Test 3: QML files exist
echo -n "Test 3: QML files... "
if [ -f "/usr/share/plasma/plasmoids/com.github.shortcutwidget/contents/ui/main.qml" ]; then
    echo "✓ PASS"
else
    echo "✗ FAIL"
fi

# Test 4: Metadata is valid
echo -n "Test 4: Metadata... "
if [ -f "/usr/share/plasma/plasmoids/com.github.shortcutwidget/metadata.json" ]; then
    echo "✓ PASS"
else
    echo "✗ FAIL"
fi

echo ""
echo "=== Test Complete ==="
```

Run with:
```bash
chmod +x quick-test.sh
./quick-test.sh
```

