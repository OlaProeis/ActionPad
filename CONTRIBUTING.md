# Contributing to Shortcut Widget

Thank you for your interest in contributing to Shortcut Widget! This document provides guidelines and instructions for contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Pull Request Process](#pull-request-process)

---

## Code of Conduct

### Our Pledge

We pledge to make participation in our project a harassment-free experience for everyone, regardless of age, body size, disability, ethnicity, gender identity and expression, level of experience, nationality, personal appearance, race, religion, or sexual identity and orientation.

### Our Standards

**Examples of behavior that contributes to creating a positive environment:**
- Using welcoming and inclusive language
- Being respectful of differing viewpoints and experiences
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members

**Examples of unacceptable behavior:**
- Trolling, insulting/derogatory comments, and personal or political attacks
- Public or private harassment
- Publishing others' private information without explicit permission
- Other conduct which could reasonably be considered inappropriate

---

## Getting Started

### Prerequisites

- KDE Plasma 6.0+
- Qt 6.0+
- CMake 3.16+
- C++ compiler (GCC 11+ or Clang 14+)
- Git

### Quick Start

1. Fork the repository on GitHub
2. Clone your fork locally
3. Set up development environment
4. Create a feature branch
5. Make your changes
6. Test thoroughly
7. Submit a pull request

---

## Development Setup

### 1. Fork and Clone

```bash
# Fork on GitHub, then clone your fork
git clone https://github.com/YOUR_USERNAME/actionpad.git
cd actionpad

# Add upstream remote
git remote add upstream https://github.com/olaproeis/actionpad.git
```

### 2. Install Dependencies

**Fedora:**
```bash
sudo dnf install cmake extra-cmake-modules qt6-qtbase-devel \
                 kf6-kcoreaddons-devel kf6-ki18n-devel kf6-kconfigwidgets-devel \
                 kf6-kiconthemes-devel plasma-workspace-devel
```

**Ubuntu/Debian:**
```bash
sudo apt install cmake extra-cmake-modules qt6-base-dev \
                 libkf6coreaddons-dev libkf6i18n-dev libkf6configwidgets-dev \
                 libkf6iconthemes-dev plasma-workspace-dev
```

### 3. Build for Development

```bash
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make -j$(nproc)
```

### 4. Install for Testing

```bash
sudo make install
killall plasmashell && plasmashell &
```

---

## How to Contribute

### Reporting Bugs

Before creating a bug report, please check:
- Existing issues to avoid duplicates
- You're running supported versions (Plasma 6.0+, Qt 6.0+)

**Bug Report Template:**

```markdown
### Description
Clear description of the bug

### Steps to Reproduce
1. Step one
2. Step two
3. ...

### Expected Behavior
What should happen

### Actual Behavior
What actually happens

### Environment
- OS: Fedora 40
- KDE Plasma Version: 6.0.2
- Qt Version: 6.6.2
- Widget Version: 1.0.0

### Additional Context
Screenshots, logs, etc.
```

### Suggesting Features

Feature requests are welcome! Please provide:
- Clear description of the feature
- Use case (why is it needed?)
- Proposed implementation (if you have ideas)
- Mockups or examples (if applicable)

### Improving Documentation

Documentation improvements are highly appreciated:
- Fix typos or clarify existing docs
- Add examples
- Translate documentation
- Improve code comments

---

## Coding Standards

### QML Style Guide

```qml
// Use camelCase for properties and functions
property string buttonLabel: "Click Me"
property int buttonCount: 0

// Use clear, descriptive names
function executeButtonAction() {
    // implementation
}

// Group related properties
// Properties first
property string label: ""
property string icon: ""

// Then signals
signal buttonClicked()

// Then functions
function handleClick() {
    buttonClicked()
}

// Proper indentation (4 spaces)
Item {
    width: 100
    height: 100
    
    Rectangle {
        anchors.fill: parent
        color: "blue"
    }
}

// Comments for non-obvious code
// Calculate contrast color for text visibility
function getContrastColor(bgColor) {
    // Implementation
}
```

### C++ Style Guide

```cpp
// Use camelCase for methods, PascalCase for classes
class CommandExecutor : public QObject
{
    Q_OBJECT
    
public:
    explicit CommandExecutor(QObject *parent = nullptr);
    
    Q_INVOKABLE void executeCommand(const QString &command);
    
signals:
    void commandFinished(int exitCode);
    
private:
    QProcess *m_process;  // m_ prefix for member variables
};

// Clear, descriptive names
void CommandExecutor::executeCommand(const QString &command)
{
    if (command.isEmpty()) {
        return;
    }
    
    // Implementation
}
```

### CMake Style Guide

```cmake
# Uppercase for commands
cmake_minimum_required(VERSION 3.16)
project(shortcutwidget)

# Clear variable names
set(PLUGIN_SOURCES
    plugin/commandexecutor.cpp
    plugin/shortcutwidgetplugin.cpp
)

# Group related items
find_package(Qt6 REQUIRED COMPONENTS
    Core
    Qml
    Quick
)
```

### General Guidelines

1. **Code Quality**
   - Write clear, readable code
   - Comment non-obvious logic
   - Use meaningful variable names
   - Keep functions focused and small

2. **Documentation**
   - Document public APIs
   - Add code comments for complex logic
   - Update user documentation for feature changes

3. **Testing**
   - Test your changes thoroughly
   - Test on supported Plasma versions
   - Verify both panel and desktop placement

4. **Commits**
   - Write clear commit messages
   - One logical change per commit
   - Reference issues in commit messages

---

## Testing

### Manual Testing Checklist

Before submitting a PR, verify:

**Basic Functionality:**
- [ ] Widget installs without errors
- [ ] Widget appears in widget list
- [ ] Widget loads on panel
- [ ] Widget loads on desktop
- [ ] Configuration dialog opens
- [ ] Can add new buttons
- [ ] Can edit existing buttons
- [ ] Can delete buttons
- [ ] Can reorder buttons
- [ ] Changes persist after reload

**Action Types:**
- [ ] Scripts execute correctly
- [ ] Applications launch correctly
- [ ] URLs open in browser
- [ ] Terminal mode works for scripts
- [ ] Arguments are passed correctly
- [ ] Working directory is respected

**UI/UX:**
- [ ] Icons display correctly
- [ ] Icon picker works
- [ ] Custom icons load
- [ ] Icon-only mode works
- [ ] Colors apply correctly
- [ ] Theme integration works
- [ ] Layout changes work (grid/row/column)
- [ ] Button sizes work (small/medium/large)
- [ ] Text is readable on all colors

**Edge Cases:**
- [ ] Empty configuration
- [ ] Many buttons (20+)
- [ ] Long button labels
- [ ] Missing icons
- [ ] Invalid script paths
- [ ] Theme changes

### Testing Different Environments

Test on:
- Light and dark themes
- Different KDE themes
- Panel placement (top/bottom/left/right)
- Desktop placement
- Different screen resolutions

---

## Pull Request Process

### Before Submitting

1. **Update from upstream**
   ```bash
   git fetch upstream
   git rebase upstream/master
   ```

2. **Test thoroughly** (see Testing checklist)

3. **Update documentation** if needed

4. **Write clear commit messages**
   ```
   Add: Brief description of what was added
   
   Detailed explanation of the changes and why they were made.
   
   Fixes #123
   ```

### PR Template

```markdown
### Description
Brief description of changes

### Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Code refactoring

### Testing
- [ ] Tested on Plasma 6.0
- [ ] Tested on panel
- [ ] Tested on desktop
- [ ] Tested with light/dark themes

### Screenshots
If applicable, add screenshots

### Related Issues
Fixes #123
Relates to #456
```

### Review Process

1. Maintainer will review your PR
2. Address any requested changes
3. Once approved, maintainer will merge
4. Your contribution will be in the next release!

### Commit Message Format

Use conventional commits format:

```
type(scope): subject

body

footer
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Code style (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(ui): add icon-only mode for buttons

Implements #45. Users can now hide button text and display only
large, centered icons for a minimalist appearance.

fix(config): resolve icon picker not opening

The IconDialog was not being instantiated correctly.
Fixed by importing org.kde.iconthemes module.

Fixes #67

docs(readme): update installation instructions for Ubuntu

Added apt package names for Ubuntu 24.04 LTS.
```

---

## Development Workflow

### Typical Development Cycle

1. **Create feature branch**
   ```bash
   git checkout -b feat/my-new-feature
   ```

2. **Make changes**
   - Edit code
   - Test locally
   - Commit frequently

3. **Build and test**
   ```bash
   cd build
   make -j$(nproc)
   sudo make install
   killall plasmashell && plasmashell &
   ```

4. **Push and create PR**
   ```bash
   git push origin feat/my-new-feature
   ```
   Then create PR on GitHub

### Tips for Development

**Fast Iteration:**
```bash
# One-liner for rebuild and reload
cd build && make -j$(nproc) && sudo make install && killall plasmashell && plasmashell &
```

**Debug Logging:**
```qml
// In QML
console.log("Debug:", variable)
console.error("Error:", errorMessage)
```

```cpp
// In C++
qDebug() << "Debug:" << variable;
qWarning() << "Warning:" << message;
qCritical() << "Error:" << error;
```

**View Logs:**
```bash
# Follow Plasma logs
journalctl -f | grep plasmashell

# Or use qdbus for console
qdbus org.kde.plasmashell /PlasmaShell showInteractiveKWinConsole
```

---

## Questions?

- **GitHub Discussions**: For general questions
- **GitHub Issues**: For bug reports
- **Email**: your.email@example.com

---

## License

By contributing, you agree that your contributions will be licensed under the GNU General Public License v3.0.

---

**Thank you for contributing to Shortcut Widget!** 🎉

