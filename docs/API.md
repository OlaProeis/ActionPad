# API Reference

Complete API reference for ActionPad QML and C++ interfaces.

## Table of Contents

- [QML API](#qml-api)
  - [Main Widget](#main-widget-mainqml)
  - [Configuration](#configuration-configgeneralqml)
- [C++ API](#c-api)
  - [CommandExecutor](#commandexecutor-class)
- [Data Structures](#data-structures)
- [Configuration Properties](#configuration-properties)
- [Signals and Slots](#signals-and-slots)

---

## QML API

### Main Widget (main.qml)

#### Root Element

```qml
PlasmoidItem {
    id: root
}
```

**Inherits:** `PlasmoidItem` (Plasma 6)

---

#### Properties

##### buttons
```qml
property var buttons: []
```
**Type:** `Array<ButtonObject>`  
**Description:** Array of button data objects  
**Default:** `[]` (empty, loads from configuration)  
**Read/Write:** Read-write  

**Example:**
```qml
root.buttons.push({
    id: "btn_001",
    label: "Test",
    actionType: "script",
    actionTarget: "/path/to/script.sh"
})
```

---

##### isInPanel
```qml
readonly property bool isInPanel
```
**Type:** `bool`  
**Description:** True if widget is in a panel  
**Read-only:** Yes  

**Calculation:**
```qml
[PlasmaCore.Types.TopEdge, PlasmaCore.Types.BottomEdge,
 PlasmaCore.Types.LeftEdge, PlasmaCore.Types.RightEdge]
    .indexOf(plasmoid.location) !== -1
```

---

##### isVertical / isHorizontal
```qml
readonly property bool isVertical
readonly property bool isHorizontal
```
**Type:** `bool`  
**Description:** Panel orientation  
**Read-only:** Yes  

---

##### Theme Colors
```qml
readonly property color backgroundColor
readonly property color textColor
readonly property color highlightColor
readonly property color buttonBackgroundColor
```
**Type:** `color`  
**Description:** Theme-aware colors from `PlasmaCore.Theme`  
**Read-only:** Yes  
**Updates:** Automatically on theme change  

---

#### Functions

##### addButton()
```qml
function addButton(buttonData: ButtonObject): string
```
**Parameters:**
- `buttonData` - Button configuration object

**Returns:** `string` - Newly created button ID

**Description:** Adds a new button to the widget

**Example:**
```qml
let id = root.addButton({
    label: "Firefox",
    tooltip: "Open browser",
    actionType: "application",
    actionTarget: "firefox",
    icon: "firefox",
    color: "#ff9500"
})
```

---

##### updateButton()
```qml
function updateButton(buttonId: string, buttonData: ButtonObject): bool
```
**Parameters:**
- `buttonId` - ID of button to update
- `buttonData` - New button data (partial update supported)

**Returns:** `bool` - True if successful, false if button not found

**Description:** Updates an existing button's properties

**Example:**
```qml
root.updateButton("btn_001", {
    label: "New Label",
    color: "#ff0000"
})
```

---

##### deleteButton()
```qml
function deleteButton(buttonId: string): bool
```
**Parameters:**
- `buttonId` - ID of button to delete

**Returns:** `bool` - True if successful

**Description:** Removes a button from the widget

**Example:**
```qml
root.deleteButton("btn_001")
```

---

##### moveButton()
```qml
function moveButton(fromIndex: int, toIndex: int): void
```
**Parameters:**
- `fromIndex` - Current button index
- `toIndex` - Target button index

**Description:** Reorders buttons by moving from one position to another

**Example:**
```qml
// Move button from position 2 to position 0 (first)
root.moveButton(2, 0)
```

---

##### executeAction()
```qml
function executeAction(buttonData: ButtonObject): void
```
**Parameters:**
- `buttonData` - Button object containing action details

**Description:** Main dispatch function for executing button actions. Routes to specific execution function based on `actionType`.

**Example:**
```qml
root.executeAction({
    actionType: "script",
    actionTarget: "/path/to/script.sh",
    arguments: "--flag value",
    runInTerminal: true
})
```

---

##### executeScript()
```qml
function executeScript(buttonData: ButtonObject): void
```
**Parameters:**
- `buttonData` - Button data with script details

**Description:** Executes a shell script or command

**Required Fields:**
- `actionTarget` - Script path or command
- `runInTerminal` (optional) - Show terminal output
- `arguments` (optional) - Command arguments
- `workingDirectory` (optional) - Execution directory

**Example:**
```qml
root.executeScript({
    actionTarget: "/home/user/backup.sh",
    arguments: "--full --verbose",
    runInTerminal: true,
    workingDirectory: "/home/user"
})
```

---

##### executeApplication()
```qml
function executeApplication(buttonData: ButtonObject): void
```
**Parameters:**
- `buttonData` - Button data with application details

**Description:** Launches an application

**Required Fields:**
- `actionTarget` - Application name or path

**Example:**
```qml
root.executeApplication({
    actionTarget: "firefox",
    arguments: "--new-window https://github.com"
})
```

---

##### executeUrl()
```qml
function executeUrl(buttonData: ButtonObject): void
```
**Parameters:**
- `buttonData` - Button data with URL

**Description:** Opens URL in default browser using `Qt.openUrlExternally()`

**Required Fields:**
- `actionTarget` - URL to open

**Auto-adds `https://`** if no protocol specified

**Example:**
```qml
root.executeUrl({
    actionTarget: "github.com"  // Opens as https://github.com
})
```

---

##### getContrastColor()
```qml
function getContrastColor(backgroundColor: string): string
```
**Parameters:**
- `backgroundColor` - Hex color string (e.g., "#ff5733")

**Returns:** `string` - "#000000" or "#FFFFFF"

**Description:** Calculates optimal text color (black/white) for given background using relative luminance formula

**Algorithm:**
```javascript
luminance = 0.299 * R + 0.587 * G + 0.114 * B
return luminance > 0.5 ? "#000000" : "#FFFFFF"
```

**Example:**
```qml
let textColor = root.getContrastColor("#e74c3c")  // Returns "#FFFFFF"
```

---

##### generateUniqueId()
```qml
function generateUniqueId(): string
```
**Returns:** `string` - Unique button ID

**Format:** `"btn_<timestamp>_<random>"`

**Example:**
```qml
let id = root.generateUniqueId()  // "btn_1700000000_456"
```

---

### Configuration (configGeneral.qml)

#### Root Element

```qml
KCM.SimpleKCM {
    id: configPage
}
```

**Inherits:** `KCM.SimpleKCM` (KDE Configuration Module)

---

#### Configuration Aliases

```qml
property alias cfg_layoutType: layoutTypeCombo.currentValue
property alias cfg_buttonSize: buttonSizeCombo.currentValue
property alias cfg_spacing: spacingSpinBox.value
property alias cfg_gridColumns: gridColumnsSpinBox.value
property string cfg_buttonsData: plasmoid.configuration.buttonsData
```

**Description:** Two-way data binding with widget configuration

---

#### Functions

##### addNewButton()
```qml
function addNewButton(): void
```
**Description:** Creates new button with default values and opens edit dialog

**Default Button:**
```javascript
{
    id: "btn_<timestamp>_<random>",
    label: "New Button",
    tooltip: "New Button",
    actionType: "script",
    actionTarget: "",
    icon: "application-default-icon",
    iconOnly: false,
    color: "",
    arguments: "",
    runInTerminal: false,
    workingDirectory: ""
}
```

---

##### deleteButton()
```qml
function deleteButton(buttonId: string): void
```
**Parameters:**
- `buttonId` - ID of button to remove

**Description:** Removes button from configuration and saves

---

##### moveButtonUp() / moveButtonDown()
```qml
function moveButtonUp(index: int): void
function moveButtonDown(index: int): void
```
**Parameters:**
- `index` - Current button index in list

**Description:** Reorders buttons in configuration list

---

## C++ API

### CommandExecutor Class

**Header:** `plugin/commandexecutor.h`  
**Namespace:** Global (registered to QML as `com.github.shortcutwidget`)  
**Inherits:** `QObject`

---

#### Constructor

```cpp
explicit CommandExecutor(QObject *parent = nullptr)
```
**Parameters:**
- `parent` - Parent QObject (optional)

**Description:** Creates CommandExecutor instance with QProcess

---

#### Methods

##### executeCommand()
```cpp
Q_INVOKABLE void executeCommand(
    const QString &command,
    const QString &workingDirectory = QString()
)
```
**Parameters:**
- `command` - Shell command to execute
- `workingDirectory` - Working directory (optional, defaults to home)

**Description:** Executes command in background using `QProcess`

**Signals Emitted:**
- `commandStarted(command)`
- `commandFinished(exitCode, output)` or `commandError(error)`

**QML Usage:**
```qml
commandExecutor.executeCommand(
    "echo 'Hello World'",
    "/home/user"
)
```

---

##### executeInTerminal()
```cpp
Q_INVOKABLE void executeInTerminal(
    const QString &command,
    const QString &workingDirectory = QString()
)
```
**Parameters:**
- `command` - Command to execute in terminal
- `workingDirectory` - Working directory (optional)

**Description:** Launches Konsole terminal with command

**Terminal Command:**
```bash
konsole --hold -e bash -c "cd <workdir> && <command>"
```

**QML Usage:**
```qml
commandExecutor.executeInTerminal(
    "./build.sh",
    "/home/user/project"
)
```

---

##### launchApplication()
```cpp
Q_INVOKABLE void launchApplication(
    const QString &application,
    const QString &arguments = QString()
)
```
**Parameters:**
- `application` - Application name or path
- `arguments` - Command-line arguments (optional)

**Description:** Launches application using `QProcess::startDetached()`

**QML Usage:**
```qml
commandExecutor.launchApplication(
    "firefox",
    "--new-window https://github.com"
)
```

---

#### Signals

##### commandStarted()
```cpp
void commandStarted(const QString &command)
```
**Parameters:**
- `command` - Command that started

**Description:** Emitted when command execution begins

---

##### commandFinished()
```cpp
void commandFinished(int exitCode, const QString &output)
```
**Parameters:**
- `exitCode` - Process exit code (0 = success)
- `output` - Combined stdout/stderr

**Description:** Emitted when command completes successfully

---

##### commandError()
```cpp
void commandError(const QString &error)
```
**Parameters:**
- `error` - Error description

**Description:** Emitted when command fails to start or crashes

---

## Data Structures

### ButtonObject

Complete button configuration object.

```typescript
interface ButtonObject {
    id: string                    // Unique identifier
    label: string                 // Button text
    tooltip?: string              // Hover tooltip
    actionType: ActionType        // "script" | "application" | "url"
    actionTarget: string          // Path/command/URL
    icon?: string                 // Icon name or path
    iconOnly?: boolean            // Hide label, show only icon
    color?: string                // Custom background color (hex/rgb)
    arguments?: string            // Command arguments
    runInTerminal?: boolean       // Run script in terminal
    workingDirectory?: string     // Execution directory
}
```

**Field Details:**

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `id` | `string` | Yes | Auto-generated | Unique button ID |
| `label` | `string` | Yes | - | Button text |
| `tooltip` | `string` | No | Same as label | Hover text |
| `actionType` | `ActionType` | Yes | - | Action type |
| `actionTarget` | `string` | Yes | - | Target path/command/URL |
| `icon` | `string` | No | `"application-default-icon"` | Icon identifier |
| `iconOnly` | `boolean` | No | `false` | Icon-only mode |
| `color` | `string` | No | `""` (theme) | Background color |
| `arguments` | `string` | No | `""` | Command arguments |
| `runInTerminal` | `boolean` | No | `false` | Terminal execution |
| `workingDirectory` | `string` | No | `""` (home) | Working directory |

---

### ActionType

```typescript
type ActionType = "script" | "application" | "url"
```

- **script**: Execute shell script or command
- **application**: Launch application
- **url**: Open URL in browser

---

## Configuration Properties

### Available via plasmoid.configuration

```qml
plasmoid.configuration.buttonsData    // string (JSON)
plasmoid.configuration.layoutType     // string: "grid"|"row"|"column"
plasmoid.configuration.buttonSize     // string: "small"|"medium"|"large"
plasmoid.configuration.spacing        // int: 0-50
plasmoid.configuration.gridColumns    // int: 1-10
```

---

## Signals and Slots

### Main Widget Signals

#### Configuration Change
```qml
Connections {
    target: plasmoid.configuration
    function onButtonsDataChanged() {
        // Reload buttons
    }
}
```

#### Theme Change
```qml
Connections {
    target: PlasmaCore.Theme
    function onThemeChanged() {
        // Update colors
    }
}
```

---

## Complete Usage Example

```qml
import QtQuick
import org.kde.plasma.plasmoid
import com.github.shortcutwidget 1.0

PlasmoidItem {
    id: root
    
    // C++ Command Executor
    CommandExecutor {
        id: executor
        
        onCommandStarted: function(cmd) {
            console.log("Started:", cmd)
        }
        
        onCommandFinished: function(code, output) {
            console.log("Finished:", code, output)
        }
        
        onCommandError: function(err) {
            console.error("Error:", err)
        }
    }
    
    // Button with all features
    function createButton() {
        return addButton({
            label: "Deploy",
            tooltip: "Deploy to production",
            actionType: "script",
            actionTarget: "/home/user/deploy.sh",
            icon: "application-x-executable-script",
            iconOnly: false,
            color: "#e74c3c",
            arguments: "--env=prod --backup",
            runInTerminal: true,
            workingDirectory: "/home/user/project"
        })
    }
    
    // Execute button
    function runButton(buttonId) {
        let button = buttons.find(b => b.id === buttonId)
        if (button) {
            executeAction(button)
        }
    }
}
```

---

## Version History

- **1.0.0** - Initial API release

---

**Questions?** See [DEVELOPMENT.md](DEVELOPMENT.md) or open an issue on [GitHub](https://github.com/OlaProeis/ActionPad/issues)!

