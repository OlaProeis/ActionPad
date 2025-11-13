# Publishing to KDE Store

Complete guide to publish Shortcut Widget to the KDE Store so users can install it directly from their "Get New Widgets" menu.

## What is KDE Store?

**KDE Store** (https://store.kde.org/) is the official platform for distributing KDE Plasma widgets, themes, and other addons. When you publish to KDE Store:

✅ Users can install directly from Plasma  
✅ Updates are easy to distribute  
✅ Increased visibility in KDE community  
✅ Central repository for all KDE addons  

---

## Prerequisites

### Before Submitting

- [x] Widget is fully tested (see `TESTING_CHECKLIST.md`)
- [x] All documentation is complete
- [x] `.plasmoid` package is created
- [x] Screenshots are taken
- [ ] GitHub repository is public
- [ ] README has installation instructions

### Required Files

1. **shortcutwidget-1.0.0.plasmoid** - The widget package
2. **Screenshots** (at least 3):
   - Widget in action
   - Configuration dialog
   - Different layouts/styles
3. **Icon/Logo** - 256x256px PNG
4. **README** - Installation and usage instructions

---

## Step-by-Step Publication

### 1. Create KDE Store Account

1. Go to https://store.kde.org/
2. Click "Register" (top right)
3. Fill in account details
4. Verify email address
5. Complete profile information

### 2. Prepare Upload Package

The C++ plugin complicates things. You have two options:

#### Option A: Package Everything Together

Create a complete package with both QML and C++ plugin:

```bash
# Create a comprehensive package
mkdir -p shortcutwidget-complete/
cp -r package shortcutwidget-complete/
cp -r plugin shortcutwidget-complete/
cp CMakeLists.txt shortcutwidget-complete/
cp build-and-install.sh shortcutwidget-complete/
cp README.md shortcutwidget-complete/
cp LICENSE shortcutwidget-complete/

# Create tarball
tar -czf shortcutwidget-1.0.0-complete.tar.gz shortcutwidget-complete/
```

#### Option B: Separate Packages (Recommended)

1. **QML Widget Package** - The `.plasmoid` file (for KDE Store)
2. **Source Package** - Complete source with C++ plugin (link to GitHub)

This is cleaner and follows KDE Store conventions.

### 3. Submit to KDE Store

#### Navigate to Upload

1. Log in to https://store.kde.org/
2. Click your username → "Add Product"
3. Category: **Plasma 6 Add-Ons** → **Plasma Applets**

#### Fill Out Product Information

**Basic Information:**
- **Name**: Shortcut Widget
- **Short Description**: "Customizable widget for quick access to scripts, applications, and websites"
- **Full Description**: (Use your README.md as a guide)
  ```
  Shortcut Widget is a powerful and customizable KDE Plasma 6 widget that provides
  instant access to your most-used scripts, applications, and websites with just
  one click.

  Features:
  • Execute shell scripts with custom arguments
  • Launch applications
  • Open URLs in default browser
  • Customizable icons, colors, and layouts
  • Three layout modes (Grid, Row, Column)
  • Icon-only mode for minimalist appearance
  • Theme integration
  • 16 color presets
  • System icon picker
  
  Perfect for developers, system administrators, and power users who want quick
  access to their favorite tools and websites.
  ```

- **Version**: 1.0.0
- **License**: GPL-3.0-or-later
- **Homepage**: https://github.com/yourusername/shortcutwidget
- **Changelog**: (Copy from CHANGELOG.md)

**Tags/Keywords:**
```
plasma, plasma6, widget, plasmoid, launcher, shortcuts, scripts, 
productivity, kde, qt6, customizable, buttons
```

**Categories:**
- Plasma 6 Add-Ons
- Plasma Applets
- System

#### Upload Files

1. **Main File**: Upload `shortcutwidget-1.0.0.plasmoid`

2. **Additional Files**:
   - Source code tarball (if not linking to GitHub)
   - PDF documentation (optional)

3. **Screenshots** (required, at least 3):
   - Upload widget screenshots
   - Add captions describing each image

4. **Preview Image/Logo**:
   - 256x256px PNG
   - Shows in search results

#### Installation Instructions

Add detailed installation instructions in the "Installation" field:

```markdown
## Installation

### Important: Two-Part Installation Required

This widget consists of:
1. QML widget (this .plasmoid file)
2. C++ plugin for command execution (must be built separately)

### Method 1: Complete Installation from Source (Recommended)

For full functionality including script execution:

1. Install build dependencies:
   ```bash
   # Fedora
   sudo dnf install cmake extra-cmake-modules qt6-qtbase-devel \
                    kf6-kcoreaddons-devel kf6-ki18n-devel plasma-workspace-devel
   
   # Ubuntu
   sudo apt install cmake extra-cmake-modules qt6-base-dev \
                    libkf6coreaddons-dev libkf6-i18n-dev plasma-workspace-dev
   ```

2. Clone and build:
   ```bash
   git clone https://github.com/olaproeis/actionpad.git
   cd actionpad
   ./build-and-install.sh
   ```

3. Restart Plasma:
   ```bash
   killall plasmashell && plasmashell &
   ```

### Method 2: Quick Install (Limited Functionality)

Install just the .plasmoid file for basic functionality (URLs and applications work, 
scripts require C++ plugin from Method 1):

1. Download the .plasmoid file
2. Right-click panel → "Add Widgets"
3. Click "Install Widget From Local File"
4. Select the downloaded .plasmoid file
5. Find "Shortcut Widget" in widget list

### Method 3: Command Line

```bash
kpackagetool6 -t Plasma/Applet -i shortcutwidget-1.0.0.plasmoid
killall plasmashell && plasmashell &
```

## Usage

1. Add widget to panel or desktop
2. Right-click widget → "Configure Shortcut Widget"
3. Click "Add New Button" to create shortcuts
4. Customize icons, colors, and layouts

Full documentation: https://github.com/olaproeis/actionpad
```

### 4. Additional Information

**Dependencies:**
- KDE Plasma >= 6.0
- Qt >= 6.0
- (For full functionality) Build tools: CMake, C++ compiler

**Support:**
- GitHub Issues: https://github.com/olaproeis/actionpad/issues

**Source Code:**
- Repository: https://github.com/olaproeis/actionpad
- License: GPL-3.0-or-later

### 5. Submit for Review

1. Review all information
2. Accept KDE Store terms
3. Click "Submit"
4. Wait for moderator approval (usually 1-3 days)

---

## After Publication

### Managing Your Product

**Update the Widget:**
1. Create new version
2. Log in to KDE Store
3. Go to your product page
4. Click "Add File"
5. Upload new `.plasmoid` file
6. Update changelog and version number

**Respond to Comments:**
- Monitor product page for user feedback
- Answer questions
- Address issues

**Track Statistics:**
- View download counts
- See rating and reviews
- Monitor popularity

---

## Alternative: Plasma Store Integration

Users can install directly from Plasma:

1. Right-click panel → "Add Widgets"
2. Click "Get New Widgets" → "Download New Plasma Widgets"
3. Search for "Shortcut Widget"
4. Click "Install"

**Note**: This only installs the `.plasmoid` file. Users still need to build the C++ plugin separately for full functionality.

---

## Handling the C++ Plugin Issue

The C++ plugin requirement makes distribution more complex. Here are strategies:

### Strategy 1: Document Clearly

Make it very clear in:
- KDE Store description
- Installation instructions
- README
- First-run message in widget

That the C++ plugin must be built separately.

### Strategy 2: Provide Pre-Built Binaries

Create distribution-specific packages:
- `.rpm` for Fedora/RHEL
- `.deb` for Ubuntu/Debian
- AUR package for Arch
- Flatpak/Snap (if feasible)

### Strategy 3: Simplify to Pure QML

Consider creating a "Lite" version that works without C++ plugin:
- URLs work natively
- Applications can launch via desktop files
- Scripts could use limited shell integration (if available in Plasma 6)

### Strategy 4: Copr/PPA Repositories

Set up binary repositories:
- **Fedora**: Create Copr repository
- **Ubuntu**: Create PPA
- **Arch**: Submit to AUR

---

## Marketing Your Widget

### Announce on Social Media

**Reddit:**
- r/kde
- r/linux
- r/unixporn

**Twitter/Mastodon:**
- Tag: #KDE #Plasma #Linux
- Mention: @kdecommunity

**KDE Forums:**
- https://forum.kde.org/

### Blog Post

Write announcement post covering:
- What it does
- Why you built it
- How to install and use
- Screenshots/video demo
- Link to KDE Store and GitHub

### Video Demo

Create screencast showing:
- Installation process
- Basic configuration
- Real-world usage examples
- Upload to YouTube/PeerTube

---

## Checklist Before Submission

- [ ] Widget fully tested on Plasma 6
- [ ] `.plasmoid` package created and verified
- [ ] Screenshots taken (at least 3, high quality)
- [ ] Logo/icon created (256x256px)
- [ ] GitHub repository is public
- [ ] README has complete documentation
- [ ] Installation instructions are clear
- [ ] C++ plugin requirement is documented
- [ ] KDE Store account created
- [ ] Product description written
- [ ] Tags and categories selected
- [ ] License information correct

---

## Timeline

**Typical Publication Process:**
1. **Submit**: Day 1
2. **Review**: Day 1-3 (moderator review)
3. **Approval**: Day 3-5
4. **Live**: Immediately after approval
5. **Indexed**: 1-2 days (appears in search)

---

## Support and Questions

**KDE Store Support:**
- Forum: https://forum.kde.org/viewforum.php?f=74
- Email: support@kde.org

**Technical Questions:**
- KDE Developer mailing list
- #kde-devel on IRC/Matrix

---

## Success Metrics

Track your widget's success:
- **Downloads**: How many users install
- **Ratings**: User satisfaction (aim for 4.5+)
- **Comments**: User feedback and feature requests
- **GitHub Stars**: Community interest
- **Issues/PRs**: Active development

---

**Ready to publish? Follow this guide step-by-step and your widget will be available to millions of KDE users worldwide! 🚀**

