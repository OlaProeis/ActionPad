# Changelog

All notable changes to Shortcut Widget will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Drag-and-drop button reordering in configuration
- Button groups/categories
- Import/Export button configurations
- Custom button animations
- Keyboard shortcut assignment
- Button search/filter in configuration

---

## [1.0.0] - 2025-11-13

### Initial Release - ActionPad

#### Added
- **Core Functionality**
  - Execute shell scripts with custom arguments
  - Launch applications
  - Open URLs in default browser
  - C++ plugin for command execution
  - Terminal mode for interactive scripts
  - Working directory configuration

- **User Interface**
  - Three layout modes (Grid, Row, Column)
  - Three button sizes (Small, Medium, Large)
  - Icon-only mode with large, centered icons
  - Custom button colors with 16 presets
  - Theme integration with automatic contrast adjustment
  - Enhanced tooltips showing action details

- **Configuration**
  - User-friendly configuration dialog
  - System icon picker with 1000+ icons
  - Custom icon file support (PNG, SVG, JPG)
  - Live icon preview
  - Button reordering (Move Up/Down)
  - Add/Edit/Delete buttons
  - Persistent configuration storage

- **Icons & Customization**
  - System icon browser by category
  - Custom image file upload
  - Icon preview in configuration
  - 16 color presets
  - Manual color input (hex, RGB, named colors)
  - Automatic text contrast for readability

- **Layout Options**
  - Configurable grid columns
  - Adjustable spacing between buttons
  - Dynamic widget sizing
  - Panel and desktop placement support
  - Responsive to theme changes

- **Developer Features**
  - CMake build system
  - QML-based UI with C++ plugin
  - Qt 6 and KDE Plasma 6 compatibility
  - Clean, modular code structure
  - Comprehensive documentation

- **Documentation**
  - README with installation instructions
  - User Guide with detailed usage
  - Configuration reference
  - Real-world examples
  - API documentation
  - Development guide
  - Contributing guidelines
  - Troubleshooting guide

#### Technical Details
- **Minimum Requirements**
  - KDE Plasma 6.0+
  - Qt 6.0+
  - CMake 3.16+

- **Architecture**
  - QML UI layer for widget interface
  - C++ plugin for system command execution
  - KDE Frameworks 6 integration
  - Theme-aware color system

---

## Version History

### [1.0.0] - 2025-11-13
First stable release of ActionPad for KDE Plasma 6.

---

## Upgrade Notes

### From Development to 1.0.0
- No breaking changes
- Configuration migrates automatically
- Reinstall widget after building from source

---

## Known Issues

### Version 1.0.0
- Some KDE themes may not provide all system icons (use custom files as workaround)
- Terminal mode requires Konsole terminal emulator
- Configuration warnings in logs (harmless, related to KCM properties)

See [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) for solutions.

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for information on contributing to this project.

---

## Links

- **GitHub Repository**: https://github.com/OlaProeis/ActionPad
- **Issue Tracker**: https://github.com/OlaProeis/ActionPad/issues
- **Discussions**: https://github.com/OlaProeis/ActionPad/discussions

---

[Unreleased]: https://github.com/OlaProeis/ActionPad/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/OlaProeis/ActionPad/releases/tag/v1.0.0

