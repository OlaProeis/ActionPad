# Shortcut Widget - User Guide

Complete guide to using Shortcut Widget for KDE Plasma 6.

## Table of Contents

- [Getting Started](#getting-started)
- [Adding Buttons](#adding-buttons)
- [Button Configuration](#button-configuration)
- [Layout Options](#layout-options)
- [Advanced Features](#advanced-features)
- [Tips & Best Practices](#tips--best-practices)

---

## Getting Started

### Installing the Widget

1. **Add to Panel or Desktop**
   - Right-click on your panel or desktop
   - Select "Add Widgets..."
   - Search for "Shortcut Widget"
   - Drag and drop to desired location

2. **First Launch**
   - A default "Hello World" button appears
   - Right-click the widget → "Configure Shortcut Widget"
   - Start customizing!

### Widget Placement

**Panel Placement:**
- Automatically adapts to panel orientation
- Horizontal panels: buttons arranged horizontally
- Vertical panels: buttons arranged vertically
- Recommended for quick access

**Desktop Placement:**
- More flexible sizing
- Can use larger button sizes
- Better for icon-only layouts
- Recommended for custom dashboards

---

## Adding Buttons

### Quick Add

1. Right-click widget → "Configure Shortcut Widget"
2. Click **"Add New Button"**
3. Fill in basic details
4. Click **"OK"**

### Button Properties

Every button has these properties:

| Property | Description | Required |
|----------|-------------|----------|
| **Label** | Text displayed on button | Yes |
| **Tooltip** | Text shown on hover | No |
| **Action Type** | Script, Application, or URL | Yes |
| **Action Target** | Path, command, or URL | Yes |
| **Icon** | Visual identifier | No |
| **Color** | Custom background color | No |
| **Icon Only** | Hide text, show only icon | No |
| **Arguments** | Parameters for script/app | No |
| **Run in Terminal** | Show terminal output | No (scripts only) |
| **Working Directory** | Execution directory | No (scripts only) |

---

## Button Configuration

### Action Types

#### 1. Script

Execute shell scripts or system commands.

**Examples:**
```bash
# Run a backup script
/home/user/scripts/backup.sh

# Open system monitor
/usr/bin/htop

# Execute inline command
echo "Hello World"
```

**Script Options:**

- **Arguments**: Pass parameters to your script
  ```bash
  Script: /home/user/deploy.sh
  Arguments: --production --verbose
  ```

- **Working Directory**: Set execution path
  ```bash
  Script: ./build.sh
  Working Directory: /home/user/projects/myapp
  ```

- **Run in Terminal**: Show output in terminal window
  - Useful for interactive scripts
  - Terminal stays open after execution
  - Great for debugging

**Common Use Cases:**
- System maintenance scripts
- Development tools
- Custom automation
- Terminal applications

#### 2. Application

Launch installed applications.

**Methods:**

1. **Application Name**
   ```
   firefox
   kate
   dolphin
   ```

2. **Full Path**
   ```
   /usr/bin/firefox
   /usr/bin/code
   ```

3. **Desktop File**
   ```
   /usr/share/applications/firefox.desktop
   ```

**With Arguments:**
```
Application: firefox
Arguments: --new-window https://github.com
```

**Common Use Cases:**
- Quick app launcher
- Open apps with specific parameters
- Launch development environments
- Start games or creative tools

#### 3. URL

Open websites or local resources in your default browser.

**Formats Supported:**
```
https://github.com
http://localhost:3000
tog.no (automatically adds https://)
file:///home/user/docs/index.html
```

**Common Use Cases:**
- Frequently visited websites
- Development servers
- Documentation pages
- Web applications

---

### Icon Configuration

#### System Icon Picker

1. Click **"Pick System Icon..."**
2. Browse categories:
   - Applications
   - Actions
   - Devices
   - Places
   - Emotes
   - Status
3. Use search to find icons quickly
4. Click icon to select

**Popular Icons:**
- `applications-internet` - Web/browser
- `utilities-terminal` - Terminal/script
- `folder` - Files/folders
- `document-edit` - Text editor
- `system-shutdown` - Power options
- `mail-unread` - Email
- `media-playback-start` - Media/games

#### Custom Icon Files

1. Click **"Browse Custom File..."**
2. Navigate to your image
3. Supported formats: PNG, SVG, JPG
4. Recommended size: 64x64 to 256x256 pixels

**Icon Tips:**
- SVG icons scale perfectly
- PNG works well for photos/screenshots
- Use transparent backgrounds for best results
- System icons match your theme automatically

#### Icon-Only Mode

Enable "Icon Only" to:
- Hide button text
- Show large, centered icon
- Create minimalist interface
- Save panel space

**Best for:**
- Commonly used actions (you recognize by icon)
- Small panels
- Clean, modern look
- Icon collections

---

### Color Customization

#### Theme Colors (Default)

Leave color field empty to use theme colors:
- Adapts to your KDE theme
- Changes with theme switches
- Respects light/dark modes
- Professional appearance

#### Color Presets

16 pre-configured colors:
- **Reds/Oranges**: `#e74c3c`, `#e67e22`, `#f39c12`, `#f1c40f`
- **Greens**: `#2ecc71`, `#1abc9c`
- **Blues**: `#3498db`, `#9b59b6`
- **Grays**: `#34495e`, `#95a5a6`, `#7f8c8d`, `#2c3e50`
- **Pastels**: `#ff6b6b`, `#4ecdc4`, `#45b7d1`, `#96ceb4`

Click any preset to apply instantly.

#### Custom Colors

Enter any valid CSS color:
- Hex: `#ff5733`
- RGB: `rgb(255, 87, 51)`
- Named: `crimson`, `steelblue`

**Color Tips:**
- Use colors to categorize buttons (red=system, blue=apps, green=web)
- High contrast colors improve visibility
- Text color adjusts automatically for readability
- Preview color before saving

---

## Layout Options

### Layout Types

#### Grid Layout
- Buttons arranged in rows and columns
- Set number of columns
- Wraps to new row automatically
- Best for: Multiple buttons, organized appearance

**Configuration:**
```
Layout: Grid
Columns: 3
Spacing: 5px
```

#### Row Layout
- All buttons in horizontal line
- Single row
- Scrolls if too many buttons
- Best for: Panel placement, quick access bar

**Configuration:**
```
Layout: Row
Spacing: 5px
```

#### Column Layout
- All buttons stacked vertically
- Single column
- Scrolls if too many buttons
- Best for: Vertical panels, sidebar placement

**Configuration:**
```
Layout: Column
Spacing: 10px
```

### Button Sizes

| Size | Dimensions | Best For |
|------|------------|----------|
| **Small** | Compact | Panels, many buttons |
| **Medium** | Standard | General use (default) |
| **Large** | Prominent | Desktop, few buttons |

Sizes scale proportionally with:
- Button dimensions
- Icon size (in icon-only mode)
- Text size
- Spacing

### Spacing

Adjust pixel spacing between buttons:
- **0-5px**: Tight, compact
- **5-10px**: Comfortable (default: 5px)
- **10-20px**: Spacious, modern

---

## Advanced Features

### Button Reordering

1. Open configuration
2. Select button in list
3. Click **"Move Up"** or **"Move Down"**
4. Click **"OK"** to save

**Tip:** Order affects visual layout from left-to-right or top-to-bottom.

### Editing Existing Buttons

1. Open configuration
2. Click **"Edit"** on desired button
3. Modify any property
4. Click **"OK"** to save changes

### Deleting Buttons

1. Open configuration
2. Click **"Delete"** on button
3. Confirm deletion
4. Click **"OK"** to apply

**Warning:** Deletion is permanent!

### Enhanced Tooltips

Tooltips automatically show:
- Custom tooltip text (if set)
- Button label (if no tooltip)
- Action type (Script/Application/URL)
- Action target (path/command/URL)

Example:
```
Terminal Emulator
Application: konsole
```

---

## Tips & Best Practices

### Organization

**Categorize by Color:**
```
System Tools: Blue
Development: Green
Websites: Purple
Scripts: Red
```

**Categorize by Layout:**
```
Row 1: Most used (top priority)
Row 2: Development tools
Row 3: System utilities
```

### Performance

- **Keep It Light**: 5-15 buttons recommended
- **Icon-Only**: Reduces visual clutter
- **Smart Grouping**: Use multiple widgets for different contexts

### Naming Conventions

**Clear Labels:**
- ✅ "Deploy Production"
- ❌ "deploy.sh"

**Descriptive Tooltips:**
- ✅ "Deploy application to production server with backup"
- ❌ "Deploy"

### Icon Selection

**Consistent Style:**
- Use all system icons OR all custom icons
- Match icon style to theme
- Use recognizable symbols

**Meaningful Icons:**
- Terminal icon for scripts
- App icon for applications
- Globe icon for websites

### Script Best Practices

**Error Handling:**
```bash
#!/bin/bash
set -e  # Exit on error
set -u  # Error on undefined variable

# Your script here
```

**Output to User:**
```bash
#!/bin/bash
echo "Starting backup..."
# backup commands
echo "Backup complete!"
```

**Terminal Scripts:**
- Enable "Run in Terminal" for interactive scripts
- Add `read -p "Press enter to close"` at end to keep terminal open

---

## Keyboard Navigation

- **Tab**: Move between buttons
- **Enter/Space**: Activate button
- **Shift+Tab**: Move backwards
- **Arrow Keys**: Navigate in grid layout

---

## Troubleshooting

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues and solutions.

---

**Need More Help?**
- [Configuration Reference](CONFIGURATION.md)
- [Examples](EXAMPLES.md)
- [GitHub Issues](https://github.com/olaproeis/actionpad/issues)

