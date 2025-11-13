# Building Shortcut Widget from Source

This guide explains how to build and install the Shortcut Widget with its C++ plugin for full functionality.

## Prerequisites

### Required Packages (Fedora)

```bash
sudo dnf install cmake extra-cmake-modules \
    qt6-qtbase-devel qt6-qtdeclarative-devel \
    kf6-plasma-devel kf6-ki18n-devel \
    kf6-kcmutils-devel kf6-kpackage-devel
```

### Required Packages (Ubuntu/Debian)

```bash
sudo apt install cmake extra-cmake-modules \
    qt6-base-dev qt6-declarative-dev \
    libkf6plasma-dev libkf6i18n-dev \
    libkf6kcmutils-dev libkf6package-dev
```

### Required Packages (Arch)

```bash
sudo pacman -S cmake extra-cmake-modules \
    qt6-base qt6-declarative \
    plasma-framework
```

## Building

### Option 1: Using the build script (Recommended)

```bash
cd /home/lowbuthigh/Dev/ShortcutWidget
./build-and-install.sh
```

This script will:
1. Create a build directory
2. Run CMake
3. Compile the C++ plugin
4. Install everything to the system

### Option 2: Manual build

```bash
cd /home/lowbuthigh/Dev/ShortcutWidget
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
sudo make install
```

## After Installation

1. **Restart Plasmashell:**
   ```bash
   killall plasmashell && plasmashell &
   ```

2. **Add the widget:**
   - Right-click on panel or desktop
   - Select "Add Widgets"
   - Search for "Shortcut Widget"
   - Drag it to your desired location

3. **Configure:**
   - Right-click the widget → Configure
   - Add your custom buttons!

## What Gets Built

- **C++ Plugin** (`shortcutwidgetplugin.so`) - Command execution backend
- **QML Widget** - User interface and button management
- Installed to: `/usr/lib/qt6/qml/com/github/shortcutwidget/`

## Uninstalling

```bash
cd /home/lowbuthigh/Dev/ShortcutWidget/build
sudo make uninstall

# Or manually:
sudo rm -rf /usr/lib/qt6/qml/com/github/shortcutwidget
kpackagetool6 --type=Plasma/Applet --remove com.github.shortcutwidget
```

## Troubleshooting

### "Cannot find module com.github.shortcutwidget"

- Make sure you installed with `sudo make install`
- Check that the plugin exists: `ls /usr/lib/qt6/qml/com/github/shortcutwidget/`
- Restart plasmashell

### Build errors about missing headers

- Install all development packages listed in Prerequisites
- Make sure you have KDE Plasma 6 (not Plasma 5)

### Widget doesn't appear in widget list

- Check installation: `kpackagetool6 --type=Plasma/Applet --list | grep shortcut`
- Try reinstalling: `./build-and-install.sh`

## Development

To make changes and test:

```bash
# Make your changes
cd /home/lowbuthigh/Dev/ShortcutWidget/build
make
sudo make install
killall plasmashell && plasmashell &
```

For QML-only changes (no C++ changes):

```bash
kpackagetool6 --type=Plasma/Applet --upgrade package
killall plasmashell && plasmashell &
```

