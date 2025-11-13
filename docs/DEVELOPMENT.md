# Development Guide

Complete technical guide for developing and contributing to Shortcut Widget.

## Table of Contents

- [Architecture Overview](#architecture-overview)
- [Project Structure](#project-structure)
- [Build System](#build-system)
- [Development Workflow](#development-workflow)
- [QML Components](#qml-components)
- [C++ Plugin](#c-plugin)
- [Configuration System](#configuration-system)
- [Debugging](#debugging)

---

## Architecture Overview

Shortcut Widget uses a hybrid architecture combining QML for UI and C++ for system operations.

### Architecture Diagram

```
┌─────────────────────────────────────────────────┐
│                 User Interface                   │
│              (QML - Declarative)                 │
├─────────────────────────────────────────────────┤
│  main.qml           │  configGeneral.qml        │
│  - Widget UI        │  - Configuration Dialog   │
│  - Button Layout    │  - Settings Management    │
│  - Theme Colors     │  - Icon Picker            │
└──────────┬──────────┴───────────┬───────────────┘
           │                      │
           │ Qt/QML Binding      │
           │                      │
┌──────────▼──────────────────────▼───────────────┐
│           C++ Plugin (Native Code)              │
│         commandexecutor.cpp                     │
│  - QProcess for script execution                │
│  - Terminal integration (konsole)               │
│  - Application launching (KRun)                 │
└──────────┬──────────────────────────────────────┘
           │
           │ System Calls
           │
┌──────────▼──────────────────────────────────────┐
│              Operating System                    │
│  - Execute Scripts                              │
│  - Launch Applications                          │
│  - Open URLs                                    │
└─────────────────────────────────────────────────┘
```

### Technology Stack

- **Frontend**: QML (Qt Quick 6)
- **Backend**: C++ (Qt 6, KDE Frameworks 6)
- **Build System**: CMake 3.16+
- **Package Format**: .plasmoid (ZIP archive)
- **Configuration**: KDE ConfigXT
- **Icons**: KDE Icon Themes

---

## Project Structure

```
shortcutwidget/
│
├── package/                      # Plasma widget (QML)
│   ├── metadata.json             # Widget metadata
│   └── contents/
│       ├── config/               # Configuration schema
│       │   ├── main.xml          # ConfigXT schema
│       │   └── config.qml        # Config category registration
│       └── ui/                   # User interface
│           ├── main.qml          # Main widget UI
│           └── configGeneral.qml # Configuration dialog
│
├── plugin/                       # C++ Plugin
│   ├── commandexecutor.h         # Command execution header
│   ├── commandexecutor.cpp       # Command execution implementation
│   ├── shortcutwidgetplugin.h    # QML plugin registration
│   ├── shortcutwidgetplugin.cpp  # QML plugin implementation
│   └── qmldir                    # QML module definition
│
├── CMakeLists.txt                # Build configuration
├── build-and-install.sh          # Build automation
├── create-package.sh             # Package creation
│
└── docs/                         # Documentation
    ├── USER_GUIDE.md
    ├── CONFIGURATION.md
    ├── EXAMPLES.md
    └── DEVELOPMENT.md (this file)
```

---

## Build System

### CMake Configuration

**Key CMake Variables:**

```cmake
CMAKE_INSTALL_PREFIX    # Installation prefix (default: /usr)
CMAKE_BUILD_TYPE        # Build type (Release/Debug)
CMAKE_CXX_STANDARD      # C++ standard (17)
```

**Build Targets:**

- `shortcutwidgetplugin` - C++ plugin library
- `install` - Install widget and plugin

**Installation Paths:**

```cmake
# Widget files
/usr/share/plasma/plasmoids/com.github.shortcutwidget/

# C++ plugin
/usr/lib64/qt6/qml/com/github/shortcutwidget/
```

### Manual Build

```bash
# Configure
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release \
      ..

# Build
make -j$(nproc)

# Install (requires sudo)
sudo make install
```

### Build Flags

**Debug Build:**
```bash
cmake -DCMAKE_BUILD_TYPE=Debug ..
```

**Custom Install Prefix:**
```bash
cmake -DCMAKE_INSTALL_PREFIX=/opt/kde6 ..
```

**Verbose Build:**
```bash
make VERBOSE=1
```

---

## Development Workflow

### Quick Rebuild Cycle

For rapid development iteration:

```bash
# One-liner: rebuild and reload
cd build && make -j$(nproc) && sudo make install && killall plasmashell && plasmashell &

# Or use separate steps
cd build
make -j$(nproc)           # Rebuild
sudo make install         # Install
killall plasmashell       # Stop Plasma
plasmashell &             # Start Plasma
```

### Live Debugging

**QML Debugging:**
```bash
# Enable QML debugging
export QML_IMPORT_TRACE=1
export QT_LOGGING_RULES="*.debug=true"

# Restart Plasma
killall plasmashell && plasmashell
```

**View Console Output:**
```bash
# Follow Plasma logs in real-time
journalctl -f | grep plasmashell

# Or filter for widget
journalctl -f | grep shortcutwidget
```

### Code Hot-Reload

**QML Changes:**
- QML changes require Plasma restart
- No rebuild needed for QML-only changes

**C++ Changes:**
- Requires full rebuild
- Must restart Plasma after installation

---

## QML Components

### Main Widget (main.qml)

**Root Element:**
```qml
PlasmoidItem {
    id: root
    // Widget container in Plasma 6
}
```

**Key Properties:**

```qml
// Configuration binding
plasmoid.configuration.buttonsData  // Button JSON data
plasmoid.configuration.layoutType   // grid/row/column
plasmoid.configuration.buttonSize   // small/medium/large

// Theme integration
PlasmaCore.Theme.backgroundColor
PlasmaCore.Theme.textColor
PlasmaCore.Theme.highlightColor

// Placement detection
plasmoid.location      // Panel location
plasmoid.formFactor    // Horizontal/Vertical
```

**Data Model:**

```qml
// Button data structure
property var buttons: []  // Array of button objects

// Button object schema
{
    id: "btn_timestamp_random",
    label: "Button Text",
    tooltip: "Hover text",
    actionType: "script|application|url",
    actionTarget: "/path/or/url",
    icon: "icon-name",
    iconOnly: false,
    color: "#hexcolor",
    arguments: "args",
    runInTerminal: false,
    workingDirectory: "/path"
}
```

**Key Functions:**

```qml
// Button management
function addButton(buttonData)      // Add new button
function updateButton(id, data)     // Update existing
function deleteButton(id)           // Remove button
function moveButton(fromId, toId)   // Reorder

// Action execution
function executeAction(buttonData)  // Dispatch action
function executeScript(data)        // Run script
function executeApplication(data)   // Launch app
function executeUrl(data)           // Open URL

// Utility
function getContrastColor(bgColor)  // Calculate text color
function generateUniqueId()         // Create button ID
```

### Configuration Dialog (configGeneral.qml)

**Root Element:**
```qml
KCM.SimpleKCM {
    // KDE Configuration Module
}
```

**Configuration Binding:**

```qml
// Two-way binding with plasmoid.configuration
property alias cfg_layoutType: layoutTypeCombo.currentValue
property alias cfg_buttonSize: buttonSizeCombo.currentValue
property string cfg_buttonsData: plasmoid.configuration.buttonsData
```

**Components:**

- `Kirigami.FormLayout` - Form container
- `QQC2.TextField` - Text inputs
- `QQC2.ComboBox` - Dropdowns
- `QQC2.Button` - Action buttons
- `FileDialog` - File browser
- `KIconThemes.IconDialog` - Icon picker

---

## C++ Plugin

### CommandExecutor Class

**Header (commandexecutor.h):**

```cpp
class CommandExecutor : public QObject
{
    Q_OBJECT

public:
    explicit CommandExecutor(QObject *parent = nullptr);

    // Invokable from QML
    Q_INVOKABLE void executeCommand(
        const QString &command, 
        const QString &workingDirectory = QString()
    );
    
    Q_INVOKABLE void executeInTerminal(
        const QString &command,
        const QString &workingDirectory = QString()
    );
    
    Q_INVOKABLE void launchApplication(
        const QString &application,
        const QString &arguments = QString()
    );

signals:
    void commandStarted(const QString &command);
    void commandFinished(int exitCode, const QString &output);
    void commandError(const QString &error);

private:
    QProcess *m_process;
};
```

**Implementation Details:**

**executeCommand():**
- Uses `QProcess::start()` for background execution
- Captures stdout/stderr
- Emits signals for status updates

**executeInTerminal():**
- Launches Konsole with command
- Uses `konsole --hold -e <command>`
- Terminal stays open after execution

**launchApplication():**
- Uses `QProcess::startDetached()`
- Detached process (doesn't block)
- Supports command-line arguments

### QML Plugin Registration

**Plugin Class (shortcutwidgetplugin.cpp):**

```cpp
void ShortcutWidgetPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("com.github.shortcutwidget"));
    
    qmlRegisterType<CommandExecutor>(
        uri, 1, 0, "CommandExecutor"
    );
}
```

**QML Module Definition (qmldir):**

```
module com.github.shortcutwidget
plugin shortcutwidgetplugin
```

### Using C++ Plugin in QML

```qml
import com.github.shortcutwidget 1.0

CommandExecutor {
    id: commandExecutor
    
    onCommandStarted: function(command) {
        console.log("Started:", command)
    }
    
    onCommandFinished: function(exitCode, output) {
        console.log("Exit code:", exitCode)
        console.log("Output:", output)
    }
    
    onCommandError: function(error) {
        console.error("Error:", error)
    }
}

// Usage
Button {
    onClicked: {
        commandExecutor.executeCommand(
            "/path/to/script.sh",
            "/working/directory"
        )
    }
}
```

---

## Configuration System

### ConfigXT Schema (main.xml)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<kcfg xmlns="http://www.kde.org/standards/kcfg/1.0">
    <kcfgfile name=""/>
    
    <group name="General">
        <!-- Button data (JSON string) -->
        <entry name="buttonsData" type="String">
            <default>[]</default>
        </entry>
        
        <!-- Layout type -->
        <entry name="layoutType" type="String">
            <default>grid</default>
        </entry>
        
        <!-- Button size -->
        <entry name="buttonSize" type="String">
            <default>medium</default>
        </entry>
        
        <!-- Spacing in pixels -->
        <entry name="spacing" type="Int">
            <default>5</default>
        </entry>
        
        <!-- Grid columns -->
        <entry name="gridColumns" type="Int">
            <default>3</default>
        </entry>
    </group>
</kcfg>
```

### Configuration Storage

**Location:**
```
~/.config/plasma-org.kde.plasma.desktop-appletsrc
```

**Access in QML:**
```qml
// Read
let layoutType = plasmoid.configuration.layoutType

// Write
plasmoid.configuration.layoutType = "row"

// JSON data
let buttons = JSON.parse(plasmoid.configuration.buttonsData)
plasmoid.configuration.buttonsData = JSON.stringify(buttons)
```

---

## Debugging

### Enable Debug Logging

```bash
export QT_LOGGING_RULES="*.debug=true"
export QML_IMPORT_TRACE=1
```

### QML Debugging

**Console Output:**
```qml
console.log("Debug:", variable)
console.warn("Warning:", message)
console.error("Error:", error)
```

**View Logs:**
```bash
journalctl -f --user | grep -i plasmashell
```

### C++ Debugging

**Debug Statements:**
```cpp
qDebug() << "Debug:" << variable;
qWarning() << "Warning:" << message;
qCritical() << "Critical:" << error;
```

**GDB Debugging:**
```bash
# Build with debug symbols
cmake -DCMAKE_BUILD_TYPE=Debug ..
make

# Debug Plasma
gdb plasmashell
(gdb) run
# Trigger issue
(gdb) backtrace
```

### Common Issues

**"module not installed"**
- C++ plugin not in Qt6 QML path
- Check: `/usr/lib64/qt6/qml/com/github/shortcutwidget/`
- Solution: Rebuild and reinstall

**QML errors**
- Syntax errors in QML files
- Check: `qml6 /path/to/file.qml`
- View: `journalctl -f | grep -i qml`

**Configuration not saving**
- Permission issues
- Check: `~/.config/plasma-org.kde.plasma.desktop-appletsrc`

---

## Performance Optimization

### Best Practices

**QML Performance:**
- Use `Repeater` for dynamic lists (not `Loader`)
- Minimize property bindings in loops
- Use `ListView` for large datasets (50+ items)
- Cache complex calculations

**Memory Management:**
- Destroy unused objects
- Avoid memory leaks in C++
- Use smart pointers (`QPointer`)

**Startup Time:**
- Lazy load heavy components
- Defer icon loading until visible
- Cache theme colors

---

## Testing

### Unit Tests

Currently manual testing. Future: Qt Test framework.

### Integration Testing

```bash
# Run validation script
./validate.sh

# Manual testing checklist
cat TESTING_CHECKLIST.md
```

---

## API Reference

See [API.md](API.md) for complete API documentation (coming soon).

---

## Contributing

See [CONTRIBUTING.md](../CONTRIBUTING.md) for contribution guidelines.

---

## Resources

**Qt Documentation:**
- Qt Quick: https://doc.qt.io/qt-6/qtquick-index.html
- QML: https://doc.qt.io/qt-6/qmlapplications.html
- Qt Widgets: https://doc.qt.io/qt-6/qtwidgets-index.html

**KDE Documentation:**
- Plasma Development: https://develop.kde.org/
- Plasmoid Tutorial: https://develop.kde.org/docs/plasma/
- KDE Frameworks: https://api.kde.org/frameworks/

**CMake:**
- CMake Documentation: https://cmake.org/documentation/
- ECM (Extra CMake Modules): https://api.kde.org/ecm/

---

**Questions?** Open an issue on [GitHub](https://github.com/yourusername/shortcutwidget/issues)!

