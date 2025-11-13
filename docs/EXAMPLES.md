# Real-World Examples

Collection of practical button configurations for common use cases.

## Table of Contents

- [Development](#development)
- [System Administration](#system-administration)
- [Daily Workflow](#daily-workflow)
- [Media & Entertainment](#media--entertainment)
- [Web Development](#web-development)
- [Complete Widget Configurations](#complete-widget-configurations)

---

## Development

### Git Operations

#### Quick Commit & Push
```json
{
  "label": "Git Push",
  "tooltip": "Commit and push changes",
  "actionType": "script",
  "actionTarget": "/home/user/scripts/git-quick-push.sh",
  "icon": "git",
  "color": "#f1c40f",
  "runInTerminal": true,
  "workingDirectory": "/home/user/projects/myapp"
}
```

**Script (`git-quick-push.sh`):**
```bash
#!/bin/bash
git add .
git commit -m "Quick update: $(date '+%Y-%m-%d %H:%M')"
git push
echo "✓ Changes pushed successfully!"
read -p "Press enter to close..."
```

#### Pull Latest Changes
```json
{
  "label": "Git Pull",
  "tooltip": "Pull latest changes from origin",
  "actionType": "script",
  "actionTarget": "git pull origin main",
  "icon": "vcs-update-required",
  "color": "#3498db",
  "runInTerminal": true,
  "workingDirectory": "/home/user/projects/myapp"
}
```

### Build & Deploy

#### Development Server
```json
{
  "label": "Dev Server",
  "tooltip": "Start development server",
  "actionType": "script",
  "actionTarget": "npm run dev",
  "icon": "applications-development",
  "color": "#2ecc71",
  "runInTerminal": true,
  "workingDirectory": "/home/user/projects/webapp"
}
```

#### Production Build
```json
{
  "label": "Build",
  "tooltip": "Build for production",
  "actionType": "script",
  "actionTarget": "npm run build",
  "icon": "run-build",
  "color": "#e67e22",
  "runInTerminal": true,
  "workingDirectory": "/home/user/projects/webapp"
}
```

### IDE & Editors

#### VS Code
```json
{
  "label": "",
  "tooltip": "Open VS Code",
  "actionType": "application",
  "actionTarget": "code",
  "icon": "vscode",
  "iconOnly": true,
  "color": "#007ACC",
  "arguments": "/home/user/projects/myapp"
}
```

#### Open Project in Kate
```json
{
  "label": "Kate",
  "tooltip": "Open project in Kate",
  "actionType": "application",
  "actionTarget": "kate",
  "icon": "kate",
  "color": "#1d99f3",
  "arguments": "/home/user/projects"
}
```

---

## System Administration

### System Monitoring

#### System Monitor
```json
{
  "label": "Monitor",
  "tooltip": "Open system monitor",
  "actionType": "application",
  "actionTarget": "ksysguard",
  "icon": "utilities-system-monitor",
  "color": "#3498db"
}
```

#### Htop
```json
{
  "label": "Htop",
  "tooltip": "Process monitor",
  "actionType": "script",
  "actionTarget": "htop",
  "icon": "utilities-terminal",
  "color": "#2ecc71",
  "runInTerminal": true
}
```

### Maintenance

#### System Update
```json
{
  "label": "Update System",
  "tooltip": "Update all packages (Fedora)",
  "actionType": "script",
  "actionTarget": "/home/user/scripts/system-update.sh",
  "icon": "system-software-update",
  "color": "#e74c3c",
  "runInTerminal": true
}
```

**Script (`system-update.sh`):**
```bash
#!/bin/bash
echo "=== SYSTEM UPDATE ==="
echo ""
echo "Updating package database..."
sudo dnf check-update
echo ""
echo "Installing updates..."
sudo dnf upgrade -y
echo ""
echo "=== UPDATE COMPLETE ==="
read -p "Press enter to close..."
```

#### Clean Package Cache
```json
{
  "label": "Clean Cache",
  "tooltip": "Remove old package files",
  "actionType": "script",
  "actionTarget": "sudo dnf clean all && sudo dnf autoremove -y",
  "icon": "edit-clear",
  "color": "#95a5a6",
  "runInTerminal": true
}
```

### Disk Management

#### Check Disk Usage
```json
{
  "label": "Disk Usage",
  "tooltip": "Check disk space",
  "actionType": "script",
  "actionTarget": "df -h && echo '' && du -sh ~/* | sort -h",
  "icon": "drive-harddisk",
  "color": "#9b59b6",
  "runInTerminal": true
}
```

---

## Daily Workflow

### Quick Access

#### Home Directory
```json
{
  "label": "",
  "tooltip": "Open home directory",
  "actionType": "application",
  "actionTarget": "dolphin",
  "icon": "user-home",
  "iconOnly": true,
  "arguments": "/home/user"
}
```

#### Downloads Folder
```json
{
  "label": "",
  "tooltip": "Open downloads",
  "actionType": "application",
  "actionTarget": "dolphin",
  "icon": "folder-download",
  "iconOnly": true,
  "arguments": "/home/user/Downloads"
}
```

#### Documents
```json
{
  "label": "",
  "tooltip": "Open documents",
  "actionType": "application",
  "actionTarget": "dolphin",
  "icon": "folder-documents",
  "iconOnly": true,
  "arguments": "/home/user/Documents"
}
```

### Communication

#### Email Client
```json
{
  "label": "",
  "tooltip": "Open Thunderbird",
  "actionType": "application",
  "actionTarget": "thunderbird",
  "icon": "thunderbird",
  "iconOnly": true,
  "color": "#0a84ff"
}
```

#### Web Chat (Discord)
```json
{
  "label": "Discord",
  "tooltip": "Open Discord web",
  "actionType": "url",
  "actionTarget": "https://discord.com/app",
  "icon": "discord",
  "color": "#5865F2"
}
```

### Productivity

#### Today's Tasks
```json
{
  "label": "Tasks",
  "tooltip": "Open task list",
  "actionType": "script",
  "actionTarget": "kate /home/user/Documents/todo.txt",
  "icon": "view-task",
  "color": "#f39c12"
}
```

#### Daily Journal
```json
{
  "label": "Journal",
  "tooltip": "Open today's journal entry",
  "actionType": "script",
  "actionTarget": "/home/user/scripts/open-journal.sh",
  "icon": "journal",
  "color": "#9b59b6"
}
```

**Script (`open-journal.sh`):**
```bash
#!/bin/bash
DATE=$(date +%Y-%m-%d)
JOURNAL_DIR="$HOME/Documents/Journal"
JOURNAL_FILE="$JOURNAL_DIR/$DATE.md"

mkdir -p "$JOURNAL_DIR"

if [ ! -f "$JOURNAL_FILE" ]; then
    echo "# Journal Entry - $DATE" > "$JOURNAL_FILE"
    echo "" >> "$JOURNAL_FILE"
    echo "## Morning" >> "$JOURNAL_FILE"
    echo "" >> "$JOURNAL_FILE"
    echo "## Afternoon" >> "$JOURNAL_FILE"
    echo "" >> "$JOURNAL_FILE"
    echo "## Evening" >> "$JOURNAL_FILE"
fi

kate "$JOURNAL_FILE"
```

---

## Media & Entertainment

### Media Players

#### Spotify
```json
{
  "label": "",
  "tooltip": "Open Spotify",
  "actionType": "application",
  "actionTarget": "spotify",
  "icon": "spotify",
  "iconOnly": true,
  "color": "#1DB954"
}
```

#### VLC Media Player
```json
{
  "label": "",
  "tooltip": "Open VLC",
  "actionType": "application",
  "actionTarget": "vlc",
  "icon": "vlc",
  "iconOnly": true,
  "color": "#FF8800"
}
```

### Gaming

#### Steam
```json
{
  "label": "",
  "tooltip": "Launch Steam",
  "actionType": "application",
  "actionTarget": "steam",
  "icon": "steam",
  "iconOnly": true,
  "color": "#1b2838"
}
```

---

## Web Development

### Local Servers

#### Start Docker Containers
```json
{
  "label": "Start Docker",
  "tooltip": "Start development containers",
  "actionType": "script",
  "actionTarget": "docker-compose up -d",
  "icon": "docker",
  "color": "#2496ED",
  "runInTerminal": true,
  "workingDirectory": "/home/user/projects/webapp"
}
```

#### Stop Docker Containers
```json
{
  "label": "Stop Docker",
  "tooltip": "Stop all containers",
  "actionType": "script",
  "actionTarget": "docker-compose down",
  "icon": "process-stop",
  "color": "#e74c3c",
  "runInTerminal": true,
  "workingDirectory": "/home/user/projects/webapp"
}
```

### Testing

#### Run Tests
```json
{
  "label": "Run Tests",
  "tooltip": "Execute test suite",
  "actionType": "script",
  "actionTarget": "npm test",
  "icon": "run-build-check",
  "color": "#2ecc71",
  "runInTerminal": true,
  "workingDirectory": "/home/user/projects/webapp"
}
```

### Quick Links

#### Localhost Development
```json
{
  "label": "Localhost",
  "tooltip": "Open local development server",
  "actionType": "url",
  "actionTarget": "http://localhost:3000",
  "icon": "application-x-mswinurl",
  "color": "#3498db"
}
```

#### API Documentation
```json
{
  "label": "API Docs",
  "tooltip": "Open API documentation",
  "actionType": "url",
  "actionTarget": "http://localhost:8000/docs",
  "icon": "documentation",
  "color": "#9b59b6"
}
```

---

## Complete Widget Configurations

### Developer's Toolbar

A complete configuration for software developers:

```json
{
  "layoutType": "row",
  "buttonSize": "medium",
  "spacing": 5,
  "gridColumns": 3,
  "buttonsData": [
    {
      "id": "btn_dev_001",
      "label": "",
      "tooltip": "VS Code",
      "actionType": "application",
      "actionTarget": "code",
      "icon": "vscode",
      "iconOnly": true,
      "color": "#007ACC"
    },
    {
      "id": "btn_dev_002",
      "label": "",
      "tooltip": "Terminal",
      "actionType": "application",
      "actionTarget": "konsole",
      "icon": "utilities-terminal",
      "iconOnly": true,
      "color": "#2c3e50"
    },
    {
      "id": "btn_dev_003",
      "label": "",
      "tooltip": "Start Dev Server",
      "actionType": "script",
      "actionTarget": "npm run dev",
      "icon": "media-playback-start",
      "iconOnly": true,
      "color": "#2ecc71",
      "runInTerminal": true,
      "workingDirectory": "/home/user/projects/webapp"
    },
    {
      "id": "btn_dev_004",
      "label": "",
      "tooltip": "Git Push",
      "actionType": "script",
      "actionTarget": "/home/user/scripts/git-push.sh",
      "icon": "git",
      "iconOnly": true,
      "color": "#f39c12",
      "runInTerminal": true
    },
    {
      "id": "btn_dev_005",
      "label": "",
      "tooltip": "Localhost:3000",
      "actionType": "url",
      "actionTarget": "http://localhost:3000",
      "icon": "applications-internet",
      "iconOnly": true,
      "color": "#3498db"
    }
  ]
}
```

### System Administrator Panel

```json
{
  "layoutType": "grid",
  "buttonSize": "large",
  "spacing": 10,
  "gridColumns": 2,
  "buttonsData": [
    {
      "id": "btn_admin_001",
      "label": "System Update",
      "tooltip": "Update all packages",
      "actionType": "script",
      "actionTarget": "sudo dnf upgrade -y",
      "icon": "system-software-update",
      "color": "#e74c3c",
      "runInTerminal": true
    },
    {
      "id": "btn_admin_002",
      "label": "Disk Usage",
      "tooltip": "Check disk space",
      "actionType": "script",
      "actionTarget": "df -h",
      "icon": "drive-harddisk",
      "color": "#9b59b6",
      "runInTerminal": true
    },
    {
      "id": "btn_admin_003",
      "label": "System Monitor",
      "tooltip": "CPU/Memory usage",
      "actionType": "script",
      "actionTarget": "htop",
      "icon": "utilities-system-monitor",
      "color": "#2ecc71",
      "runInTerminal": true
    },
    {
      "id": "btn_admin_004",
      "label": "Logs",
      "tooltip": "View system logs",
      "actionType": "script",
      "actionTarget": "journalctl -f",
      "icon": "documentinfo",
      "color": "#3498db",
      "runInTerminal": true
    }
  ]
}
```

### Quick Launch Dashboard

```json
{
  "layoutType": "grid",
  "buttonSize": "medium",
  "spacing": 5,
  "gridColumns": 4,
  "buttonsData": [
    {
      "id": "btn_ql_001",
      "label": "",
      "tooltip": "Firefox",
      "actionType": "application",
      "actionTarget": "firefox",
      "icon": "firefox",
      "iconOnly": true
    },
    {
      "id": "btn_ql_002",
      "label": "",
      "tooltip": "Files",
      "actionType": "application",
      "actionTarget": "dolphin",
      "icon": "system-file-manager",
      "iconOnly": true
    },
    {
      "id": "btn_ql_003",
      "label": "",
      "tooltip": "Calculator",
      "actionType": "application",
      "actionTarget": "kcalc",
      "icon": "accessories-calculator",
      "iconOnly": true
    },
    {
      "id": "btn_ql_004",
      "label": "",
      "tooltip": "Text Editor",
      "actionType": "application",
      "actionTarget": "kate",
      "icon": "kate",
      "iconOnly": true
    },
    {
      "id": "btn_ql_005",
      "label": "",
      "tooltip": "Email",
      "actionType": "application",
      "actionTarget": "thunderbird",
      "icon": "thunderbird",
      "iconOnly": true
    },
    {
      "id": "btn_ql_006",
      "label": "",
      "tooltip": "Music",
      "actionType": "application",
      "actionTarget": "spotify",
      "icon": "spotify",
      "iconOnly": true
    },
    {
      "id": "btn_ql_007",
      "label": "",
      "tooltip": "Settings",
      "actionType": "application",
      "actionTarget": "systemsettings",
      "icon": "preferences-system",
      "iconOnly": true
    },
    {
      "id": "btn_ql_008",
      "label": "",
      "tooltip": "Terminal",
      "actionType": "application",
      "actionTarget": "konsole",
      "icon": "utilities-terminal",
      "iconOnly": true
    }
  ]
}
```

---

## Tips for Creating Your Own

### Script Best Practices

1. **Add Shebang**
   ```bash
   #!/bin/bash
   ```

2. **Make Executable**
   ```bash
   chmod +x /path/to/script.sh
   ```

3. **Error Handling**
   ```bash
   set -e  # Exit on error
   set -u  # Error on undefined variable
   ```

4. **User Feedback**
   ```bash
   echo "Starting process..."
   # commands
   echo "Complete!"
   read -p "Press enter to close..."
   ```

### Organizing Buttons

**By Function:**
- Row 1: Most frequently used
- Row 2: Development tools
- Row 3: System utilities

**By Color:**
- Red: Critical/destructive actions
- Green: Safe/productive actions
- Blue: Information/navigation
- Purple: Special/creative tools

---

Need more examples? Check the [User Guide](USER_GUIDE.md) or ask in [GitHub Discussions](https://github.com/OlaProeis/ActionPad/discussions)!

