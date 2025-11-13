# Configuration Reference

Complete reference for all Shortcut Widget configuration options.

## Configuration File Location

Widget configuration is stored in:
```
~/.config/plasma-org.kde.plasma.desktop-appletsrc
```

Buttons data is stored as JSON in the configuration.

---

## General Settings

### Layout Type

**Option:** `layoutType`  
**Type:** String  
**Values:** `grid`, `row`, `column`  
**Default:** `grid`

Controls how buttons are arranged.

```qml
// Configuration
layoutType: "grid"
```

**Effects:**
- `grid`: Multi-row, multi-column layout
- `row`: Single horizontal row
- `column`: Single vertical column

---

### Button Size

**Option:** `buttonSize`  
**Type:** String  
**Values:** `small`, `medium`, `large`  
**Default:** `medium`

Sets the size of all buttons.

```qml
// Configuration
buttonSize: "medium"
```

**Actual Sizes:**
- `small`: 48px × 48px
- `medium`: 64px × 64px
- `large`: 96px × 96px

---

### Spacing

**Option:** `spacing`  
**Type:** Integer  
**Range:** 0-50  
**Default:** 5

Spacing between buttons in pixels.

```qml
// Configuration
spacing: 5
```

---

### Grid Columns

**Option:** `gridColumns`  
**Type:** Integer  
**Range:** 1-10  
**Default:** 3

Number of columns when using grid layout.

```qml
// Configuration
gridColumns: 3
```

**Note:** Only applies when `layoutType` is `grid`.

---

## Button Properties

Each button is stored as a JSON object with these properties:

### Button Data Structure

```json
{
  "id": "btn_1234567890_123",
  "label": "Button Text",
  "tooltip": "Hover text",
  "actionType": "script",
  "actionTarget": "/path/to/script.sh",
  "icon": "icon-name",
  "iconOnly": false,
  "color": "#ff5733",
  "arguments": "--flag value",
  "runInTerminal": true,
  "workingDirectory": "/home/user/projects"
}
```

### Property Descriptions

#### id
**Type:** String  
**Required:** Yes (auto-generated)  
**Format:** `btn_[timestamp]_[random]`

Unique identifier for the button.

```json
"id": "btn_1700000000_456"
```

#### label
**Type:** String  
**Required:** Yes  
**Max Length:** 50 characters recommended

Text displayed on the button.

```json
"label": "Deploy to Production"
```

#### tooltip
**Type:** String  
**Required:** No  
**Default:** Same as label

Text shown when hovering over button.

```json
"tooltip": "Deploy application to production server with backup"
```

#### actionType
**Type:** String  
**Required:** Yes  
**Values:** `script`, `application`, `url`

Type of action to perform.

```json
"actionType": "script"
```

**Types:**
- `script`: Execute shell script or command
- `application`: Launch application
- `url`: Open URL in browser

#### actionTarget
**Type:** String  
**Required:** Yes

The script path, application name, or URL to execute.

```json
// Script
"actionTarget": "/home/user/scripts/backup.sh"

// Application
"actionTarget": "firefox"

// URL
"actionTarget": "https://github.com"
```

#### icon
**Type:** String  
**Required:** No  
**Default:** `application-default-icon`

Icon to display on button.

```json
// System icon (name)
"icon": "utilities-terminal"

// Custom file (path)
"icon": "/home/user/icons/custom.png"
```

**System Icon Names:**
- Browse available icons: `/usr/share/icons/`
- Use icon picker for easy selection
- Common icons: see [Icon Reference](#icon-reference)

#### iconOnly
**Type:** Boolean  
**Required:** No  
**Default:** `false`

Hide label text, show only icon.

```json
"iconOnly": true
```

**Effects:**
- Text is hidden
- Icon scales to 60% of button size
- Icon is centered in button

#### color
**Type:** String  
**Required:** No  
**Default:** Empty (theme color)

Custom background color for button.

```json
// Hex color
"color": "#e74c3c"

// RGB color
"color": "rgb(231, 76, 60)"

// Named color
"color": "crimson"

// Theme color (empty)
"color": ""
```

#### arguments
**Type:** String  
**Required:** No  
**Default:** Empty

Arguments to pass to script or application.

```json
"arguments": "--production --verbose --config=/path/to/config.json"
```

**Examples:**
```json
// Script with flags
"actionTarget": "/home/user/deploy.sh",
"arguments": "--env=prod --skip-tests"

// Application with file
"actionTarget": "kate",
"arguments": "/home/user/document.txt"
```

#### runInTerminal
**Type:** Boolean  
**Required:** No  
**Default:** `false`

Execute script in terminal window.

```json
"runInTerminal": true
```

**Effects:**
- Opens terminal emulator (konsole)
- Shows script output
- Terminal stays open after execution
- Only applies to `actionType: "script"`

#### workingDirectory
**Type:** String  
**Required:** No  
**Default:** User home directory

Working directory for script execution.

```json
"workingDirectory": "/home/user/projects/myapp"
```

**Use Cases:**
- Run scripts relative to project directory
- Execute build tools in correct location
- Access local configuration files

---

## Complete Button Examples

### Script Button (Simple)
```json
{
  "id": "btn_1700000000_001",
  "label": "Backup",
  "tooltip": "Run daily backup",
  "actionType": "script",
  "actionTarget": "/home/user/scripts/backup.sh",
  "icon": "drive-harddisk",
  "iconOnly": false,
  "color": "#3498db",
  "arguments": "",
  "runInTerminal": false,
  "workingDirectory": ""
}
```

### Script Button (Advanced)
```json
{
  "id": "btn_1700000000_002",
  "label": "Deploy",
  "tooltip": "Deploy to production with backup",
  "actionType": "script",
  "actionTarget": "/home/user/deploy.sh",
  "icon": "application-x-executable-script",
  "iconOnly": false,
  "color": "#e74c3c",
  "arguments": "--environment=production --backup --verbose",
  "runInTerminal": true,
  "workingDirectory": "/home/user/projects/webapp"
}
```

### Application Button
```json
{
  "id": "btn_1700000000_003",
  "label": "Firefox",
  "tooltip": "Open Firefox browser",
  "actionType": "application",
  "actionTarget": "firefox",
  "icon": "firefox",
  "iconOnly": true,
  "color": "",
  "arguments": "",
  "runInTerminal": false,
  "workingDirectory": ""
}
```

### URL Button
```json
{
  "id": "btn_1700000000_004",
  "label": "GitHub",
  "tooltip": "Open GitHub homepage",
  "actionType": "url",
  "actionTarget": "https://github.com",
  "icon": "github",
  "iconOnly": false,
  "color": "#2c3e50",
  "arguments": "",
  "runInTerminal": false,
  "workingDirectory": ""
}
```

---

## Icon Reference

### Common System Icons

**Applications:**
- `applications-internet` - Web browser
- `applications-development` - Development tools
- `applications-games` - Games
- `applications-graphics` - Graphics apps
- `applications-system` - System tools

**Actions:**
- `system-run` - Execute/run
- `document-open` - Open file
- `document-save` - Save
- `edit-delete` - Delete
- `configure` - Settings

**Devices:**
- `computer` - Computer
- `drive-harddisk` - Hard drive
- `network-server` - Server
- `phone` - Phone

**Places:**
- `folder` - Folder
- `folder-documents` - Documents
- `folder-download` - Downloads
- `user-home` - Home directory

**Status:**
- `dialog-information` - Information
- `dialog-warning` - Warning
- `dialog-error` - Error
- `task-complete` - Success

**Media:**
- `media-playback-start` - Play
- `media-playback-pause` - Pause
- `media-playback-stop` - Stop

**Utilities:**
- `utilities-terminal` - Terminal
- `utilities-file-archiver` - Archive
- `preferences-system` - System preferences

---

## Color Presets

The widget includes 16 pre-configured colors:

| Color Name | Hex Code | Use Case |
|------------|----------|----------|
| Red | `#e74c3c` | Critical actions |
| Orange | `#e67e22` | Warning actions |
| Yellow | `#f39c12` | Attention items |
| Bright Yellow | `#f1c40f` | Highlights |
| Green | `#2ecc71` | Success actions |
| Teal | `#1abc9c` | Info items |
| Blue | `#3498db` | Primary actions |
| Purple | `#9b59b6` | Special items |
| Dark Blue | `#34495e` | System tools |
| Gray | `#95a5a6` | Disabled/inactive |
| Dark Gray | `#7f8c8d` | Secondary |
| Darkest Blue | `#2c3e50` | Background |
| Pastel Red | `#ff6b6b` | Soft warning |
| Pastel Teal | `#4ecdc4` | Soft info |
| Pastel Blue | `#45b7d1` | Soft primary |
| Pastel Green | `#96ceb4` | Soft success |

---

## Theme Integration

### Theme Colors

When `color` is empty, button uses theme colors:

```qml
backgroundColor: PlasmaCore.Theme.backgroundColor
textColor: PlasmaCore.Theme.textColor
highlightColor: PlasmaCore.Theme.highlightColor
buttonBackgroundColor: PlasmaCore.Theme.buttonBackgroundColor
```

### Text Contrast

Widget automatically calculates optimal text color based on background:

```javascript
function getContrastColor(backgroundColor) {
    // Calculate relative luminance
    let r = parseInt(backgroundColor.substr(1,2), 16) / 255
    let g = parseInt(backgroundColor.substr(3,2), 16) / 255
    let b = parseInt(backgroundColor.substr(5,2), 16) / 255
    
    // Return white for dark, black for light
    let luminance = 0.299 * r + 0.587 * g + 0.114 * b
    return luminance > 0.5 ? "#000000" : "#FFFFFF"
}
```

---

## Import/Export

### Export Configuration

```bash
# Manual export
cat ~/.config/plasma-org.kde.plasma.desktop-appletsrc | grep -A 100 "com.github.shortcutwidget"
```

### Backup Configuration

```bash
# Backup widget config
cp ~/.config/plasma-org.kde.plasma.desktop-appletsrc \
   ~/.config/plasma-org.kde.plasma.desktop-appletsrc.backup
```

### Restore Configuration

```bash
# Restore from backup
cp ~/.config/plasma-org.kde.plasma.desktop-appletsrc.backup \
   ~/.config/plasma-org.kde.plasma.desktop-appletsrc
   
# Restart Plasma
killall plasmashell && plasmashell &
```

---

## Advanced Configuration

### Manual JSON Editing

**Warning:** Manual editing can break configuration. Always backup first!

1. Export current configuration
2. Edit JSON carefully
3. Validate JSON syntax
4. Import back
5. Restart Plasma Shell

### Configuration Schema

```json
{
  "buttonsData": "[{...}, {...}]",  // JSON string of button array
  "layoutType": "grid",              // grid | row | column
  "buttonSize": "medium",            // small | medium | large
  "spacing": 5,                      // 0-50
  "gridColumns": 3                   // 1-10
}
```

---

## Performance Considerations

### Recommended Limits

- **Buttons**: 5-20 (optimal performance)
- **Icon Size**: 64x64 to 256x256 pixels
- **Script Execution**: < 5 seconds (use terminal for long scripts)

### Optimization Tips

1. **Use System Icons**: Faster than custom files
2. **Optimize Scripts**: Make scripts efficient
3. **Limit Custom Colors**: Theme colors are faster
4. **Reasonable Button Count**: 15-20 max recommended

---

## See Also

- [User Guide](USER_GUIDE.md) - General usage instructions
- [Examples](EXAMPLES.md) - Real-world configurations
- [API Reference](API.md) - Developer documentation

