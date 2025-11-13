# Troubleshooting Guide

Common issues and solutions for Shortcut Widget.

## Table of Contents

- [Installation Issues](#installation-issues)
- [Widget Not Appearing](#widget-not-appearing)
- [Configuration Problems](#configuration-problems)
- [Action Execution Issues](#action-execution-issues)
- [UI/Display Problems](#uidisplay-problems)
- [Performance Issues](#performance-issues)
- [Logs and Debugging](#logs-and-debugging)

---

## Installation Issues

### Build Fails with "CMake Error"

**Problem:** CMake configuration fails.

**Solutions:**

1. **Install required dependencies**
   ```bash
   # Fedora
   sudo dnf install cmake extra-cmake-modules qt6-qtbase-devel \
                    kf6-kcoreaddons-devel kf6-ki18n-devel plasma-workspace-devel
   
   # Ubuntu
   sudo apt install cmake extra-cmake-modules qt6-base-dev \
                    libkf6coreaddons-dev libkf6i18n-dev plasma-workspace-dev
   ```

2. **Check CMake version**
   ```bash
   cmake --version  # Should be 3.16+
   ```

3. **Clean build directory**
   ```bash
   rm -rf build
   mkdir build
   cd build
   cmake ..
   ```

### "Could NOT find Qt6"

**Problem:** Qt 6 not found by CMake.

**Solution:**
```bash
# Fedora
sudo dnf install qt6-qtbase-devel qt6-qtdeclarative-devel

# Ubuntu
sudo apt install qt6-base-dev qt6-declarative-dev

# Set Qt6 path manually if needed
export CMAKE_PREFIX_PATH=/usr/lib64/cmake/Qt6:$CMAKE_PREFIX_PATH
```

### "Could NOT find KF6"

**Problem:** KDE Frameworks 6 not found.

**Solution:**
```bash
# Fedora
sudo dnf install kf6-kcoreaddons-devel kf6-ki18n-devel kf6-kconfigwidgets-devel

# Ubuntu
sudo apt install libkf6coreaddons-dev libkf6i18n-dev libkf6configwidgets-dev
```

### Plugin Not Loading

**Problem:** Widget shows "module not installed" error.

**Solution:**

1. **Verify plugin installation**
   ```bash
   ls -la /usr/lib64/qt6/qml/com/github/shortcutwidget/
   # Should show: libshortcutwidgetplugin.so and qmldir
   ```

2. **Check QML module path**
   ```bash
   qtpaths6 --query QT_INSTALL_QML
   # Should be: /usr/lib64/qt6/qml
   ```

3. **Reinstall with correct path**
   ```bash
   cd build
   sudo make install
   ```

4. **Restart Plasma**
   ```bash
   killall plasmashell && plasmashell &
   ```

---

## Widget Not Appearing

### Widget Not in Widget List

**Problem:** Can't find "Shortcut Widget" in Add Widgets dialog.

**Solutions:**

1. **Verify installation**
   ```bash
   ls -la /usr/share/plasma/plasmoids/ | grep shortcutwidget
   ```

2. **Check metadata**
   ```bash
   cat /usr/share/plasma/plasmoids/com.github.shortcutwidget/metadata.json
   ```

3. **Restart Plasma Shell**
   ```bash
   killall plasmashell && plasmashell &
   ```

4. **Clear Plasma cache**
   ```bash
   rm -rf ~/.cache/plasmashell/
   killall plasmashell && plasmashell &
   ```

### Widget Crashes on Load

**Problem:** Plasmashell crashes when adding widget.

**Solutions:**

1. **Check logs**
   ```bash
   journalctl -f | grep plasmashell
   ```

2. **Verify QML syntax**
   ```bash
   qml6 /usr/share/plasma/plasmoids/com.github.shortcutwidget/contents/ui/main.qml
   ```

3. **Reinstall clean**
   ```bash
   sudo rm -rf /usr/share/plasma/plasmoids/com.github.shortcutwidget
   sudo rm -rf /usr/lib64/qt6/qml/com/github/shortcutwidget
   cd build
   sudo make install
   killall plasmashell && plasmashell &
   ```

---

## Configuration Problems

### Configuration Dialog Won't Open

**Problem:** Right-click → Configure does nothing.

**Solutions:**

1. **Check config files exist**
   ```bash
   ls -la /usr/share/plasma/plasmoids/com.github.shortcutwidget/contents/config/
   # Should show: main.xml and config.qml
   ```

2. **Verify config.qml location**
   - Must be in `contents/config/`, not `contents/ui/`

3. **Check logs for errors**
   ```bash
   journalctl -f | grep -i error
   ```

### Configuration Not Saving

**Problem:** Changes don't persist after widget reload.

**Solutions:**

1. **Click "OK" or "Apply"** (not just closing dialog)

2. **Check configuration file**
   ```bash
   cat ~/.config/plasma-org.kde.plasma.desktop-appletsrc | grep -A 20 shortcutwidget
   ```

3. **Verify write permissions**
   ```bash
   ls -la ~/.config/plasma-org.kde.plasma.desktop-appletsrc
   ```

4. **Reset configuration**
   ```bash
   # Backup first!
   cp ~/.config/plasma-org.kde.plasma.desktop-appletsrc ~/.config/plasma-org.kde.plasma.desktop-appletsrc.backup
   # Remove widget, restart Plasma, re-add widget
   ```

### Icons Not Showing in Picker

**Problem:** Icon picker dialog is empty or shows errors.

**Solutions:**

1. **Install icon themes**
   ```bash
   # Fedora
   sudo dnf install breeze-icon-theme
   
   # Ubuntu
   sudo apt install breeze-icon-theme
   ```

2. **Check icon paths**
   ```bash
   ls /usr/share/icons/
   ```

3. **Use custom icon file** as workaround

---

## Action Execution Issues

### Scripts Not Running

**Problem:** Clicking script button does nothing.

**Solutions:**

1. **Check script path**
   ```bash
   ls -la /path/to/script.sh
   ```

2. **Make script executable**
   ```bash
   chmod +x /path/to/script.sh
   ```

3. **Test script manually**
   ```bash
   /path/to/script.sh
   ```

4. **Check logs**
   ```bash
   journalctl -f | grep -i command
   ```

5. **Use absolute paths**
   - Use `/home/user/script.sh` instead of `~/script.sh`

6. **Enable "Run in Terminal"** to see errors

### Applications Not Launching

**Problem:** Application buttons don't work.

**Solutions:**

1. **Verify application is installed**
   ```bash
   which firefox  # or your application name
   ```

2. **Test launch from terminal**
   ```bash
   firefox  # Does it open?
   ```

3. **Try full path**
   ```
   /usr/bin/firefox
   ```

4. **Try .desktop file**
   ```
   /usr/share/applications/firefox.desktop
   ```

### URLs Not Opening

**Problem:** URL buttons don't open browser.

**Solutions:**

1. **Check default browser**
   ```bash
   xdg-settings get default-web-browser
   ```

2. **Set default browser**
   ```bash
   xdg-settings set default-web-browser firefox.desktop
   ```

3. **Test URL manually**
   ```bash
   xdg-open https://github.com
   ```

4. **Use full URL** including `https://`

### Terminal Mode Not Working

**Problem:** "Run in Terminal" doesn't show terminal.

**Solutions:**

1. **Install Konsole**
   ```bash
   # Fedora
   sudo dnf install konsole
   
   # Ubuntu
   sudo apt install konsole
   ```

2. **Check Konsole path**
   ```bash
   which konsole
   ```

3. **Test terminal execution**
   ```bash
   konsole -e echo "test"
   ```

---

## UI/Display Problems

### Buttons Too Small/Large

**Problem:** Button size doesn't look right.

**Solutions:**

1. **Adjust button size** in configuration
   - Small: 48px
   - Medium: 64px
   - Large: 96px

2. **Check layout type**
   - Grid: Fixed size
   - Row/Column: Fills available space

3. **Adjust panel size** (for panel placement)

### Icons Too Small in Icon-Only Mode

**Problem:** Icon doesn't scale up in icon-only mode.

**Solution:**
- This was fixed in v1.0.0
- Reinstall widget if using older version
- Icon should be 60% of button size

### Text Color Unreadable

**Problem:** Text is hard to read on custom color.

**Solutions:**

1. **Widget automatically adjusts** text color
   - If not working, try different color

2. **Use theme colors**
   - Leave color field empty

3. **Choose high-contrast color**

4. **Update to latest version** (contrast calculation improved in v1.0.0)

### Widget Doesn't Match Theme

**Problem:** Colors don't change with theme.

**Solutions:**

1. **Use theme colors**
   - Remove custom colors
   - Leave color field empty

2. **Restart Plasma** after theme change
   ```bash
   killall plasmashell && plasmashell &
   ```

3. **Clear custom colors** from all buttons

### Layout Breaks on Theme Change

**Problem:** Widget layout gets messy after changing themes.

**Solutions:**

1. **Remove and re-add widget**

2. **Adjust spacing** in configuration

3. **Restart Plasma Shell**
   ```bash
   killall plasmashell && plasmashell &
   ```

---

## Performance Issues

### Widget Feels Slow

**Problem:** Button clicks or configuration feels laggy.

**Solutions:**

1. **Reduce button count**
   - Recommended: 5-20 buttons

2. **Use system icons** instead of custom files
   - System icons load faster

3. **Optimize scripts**
   - Make scripts faster
   - Use background execution

4. **Check system resources**
   ```bash
   htop
   ```

### High Memory Usage

**Problem:** Plasmashell using too much memory.

**Solutions:**

1. **Limit custom icon files**
   - Use smaller images
   - Use SVG instead of large PNG

2. **Reduce button count**

3. **Restart Plasmashell**
   ```bash
   killall plasmashell && plasmashell &
   ```

---

## Logs and Debugging

### Viewing Logs

**Real-time Plasma logs:**
```bash
journalctl -f | grep plasmashell
```

**Recent errors:**
```bash
journalctl -xe | grep -i error | tail -20
```

**Widget-specific logs:**
```bash
journalctl | grep shortcutwidget
```

### Console Debugging

**Enable QML debugging:**
```bash
export QT_LOGGING_RULES="*.debug=true"
killall plasmashell && plasmashell &
```

**Check console output:**
```qml
// Add to QML code
console.log("Debug:", variable)
console.error("Error:", errorMessage)
```

### Common Error Messages

**"module is not installed"**
- Solution: Reinstall C++ plugin, check Qt6 QML path

**"Cannot read property of undefined"**
- Solution: Check button data has all required fields

**"PlasmaCore.Theme is not a type"**
- Solution: Update imports, use Kirigami.Theme in newer code

**"File or directory not found"**
- Solution: Check paths are absolute, verify file exists

### Reporting Bugs

Include this information in bug reports:

```bash
# System info
uname -a
kwin_x11 --version  # or kwin_wayland
plasmashell --version

# Widget version
cat /usr/share/plasma/plasmoids/com.github.shortcutwidget/metadata.json | grep Version

# Error logs
journalctl -xe | grep -i shortcutwidget | tail -50
```

---

## Still Need Help?

- **GitHub Issues**: https://github.com/olaproeis/actionpad/issues
- **GitHub Discussions**: https://github.com/olaproeis/actionpad/discussions
- **KDE Forums**: https://forum.kde.org/

When asking for help, please provide:
1. Operating system and version
2. KDE Plasma version
3. Widget version
4. Error messages from logs
5. Steps to reproduce the issue

