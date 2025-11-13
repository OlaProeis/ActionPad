# Screenshot Placeholders

To complete the documentation, please add screenshots in this directory:

## Required Screenshots

### 1. `logo.png`
- Widget logo/icon
- Recommended size: 256x256px
- Format: PNG with transparency

### 2. `widget-example.png`
- Widget in action on desktop or panel
- Show multiple buttons with different colors/icons
- Clear, high-resolution screenshot

### 3. `config-dialog.png`
- Configuration dialog open showing the General settings tab
- Show layout settings and button list

### 4. `add-button.png`
- Add/Edit button dialog showing all configuration options
- Demonstrate button customization interface
- Show icon picker, color presets, and all form fields

## How to Add Screenshots

1. Take screenshots using Spectacle:
   ```bash
   spectacle
   ```

2. Save screenshots to this directory with exact names listed above

3. Optimize images (optional):
   ```bash
   optipng widget-example.png
   ```

4. Update README.md if you want to change image paths

## Image Guidelines

- **Resolution**: At least 1920x1080 for desktop screenshots
- **Format**: PNG for best quality
- **Theme**: Use a popular KDE theme (Breeze recommended)
- **Content**: Show realistic use cases
- **Privacy**: Don't include personal information

## Temporary Logo

Until a custom logo is created, you can use a KDE system icon:

```bash
cp /usr/share/icons/breeze/apps/256/preferences-system-windows-actions.png logo.png
```

