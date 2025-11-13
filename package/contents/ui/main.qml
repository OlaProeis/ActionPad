import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami
import com.github.actionpad 1.0

PlasmoidItem {
    id: root

    // Prefer full representation (show buttons directly)
    preferredRepresentation: fullRepresentation
    
    // Detect if we're in panel or on desktop
    readonly property bool inPanel: [PlasmaCore.Types.TopEdge, PlasmaCore.Types.RightEdge, 
                                      PlasmaCore.Types.BottomEdge, PlasmaCore.Types.LeftEdge]
                                     .indexOf(plasmoid.location) !== -1
    
    readonly property bool isVertical: plasmoid.formFactor === PlasmaCore.Types.Vertical
    readonly property bool isHorizontal: plasmoid.formFactor === PlasmaCore.Types.Horizontal

    // Widget properties
    property var buttons: []
    
    // Theme-aware colors
    readonly property color backgroundColor: PlasmaCore.Theme.backgroundColor
    readonly property color textColor: PlasmaCore.Theme.textColor
    readonly property color highlightColor: PlasmaCore.Theme.highlightColor
    readonly property color buttonBackgroundColor: PlasmaCore.Theme.buttonBackgroundColor

    // C++ Command Executor
    CommandExecutor {
        id: commandExecutor
        
        onCommandStarted: function(command) {
            console.log("Command started:", command)
        }
        
        onCommandFinished: function(exitCode, output) {
            console.log("Command finished with exit code:", exitCode)
        }
        
        onCommandError: function(error) {
            console.error("Command error:", error)
        }
    }

    // Initialize with default button on first run
    Component.onCompleted: {
        loadButtons()
    }
    
    // Listen for theme changes
    Connections {
        target: PlasmaCore.Theme
        function onThemeChanged() {
            console.log("Theme changed, updating colors")
        }
    }
    
    // Watch for configuration changes
    Connections {
        target: plasmoid.configuration
        function onButtonsDataChanged() {
            console.log("Buttons configuration changed, reloading...")
            loadButtons()
        }
    }

    function loadButtons() {
        try {
            let data = plasmoid.configuration.buttonsData
            if (data && data !== "[]") {
                buttons = JSON.parse(data)
            } else {
                // Create default "Hello World" button on first install
                buttons = [{
                    id: generateUniqueId(),
                    label: "Hello World",
                    tooltip: "Run a simple hello world script",
                    actionType: "script",
                    actionTarget: "echo 'Hello World from Shortcut Widget!'",
                    icon: "dialog-information",
                    iconOnly: false,
                    color: "",
                    arguments: "",
                    runInTerminal: true,
                    workingDirectory: ""
                }]
                saveButtons()
            }
        } catch (e) {
            console.error("Error loading buttons:", e)
            buttons = []
        }
    }

    function saveButtons() {
        plasmoid.configuration.buttonsData = JSON.stringify(buttons)
    }
    
    // Generate unique ID for buttons
    function generateUniqueId() {
        return "btn_" + Date.now() + "_" + Math.floor(Math.random() * 1000)
    }
    
    // Add a new button
    function addButton(buttonData) {
        // Ensure button has all required fields with defaults
        let newButton = {
            id: buttonData.id || generateUniqueId(),
            label: buttonData.label || "New Button",
            tooltip: buttonData.tooltip || buttonData.label || "New Button",
            actionType: buttonData.actionType || "script",
            actionTarget: buttonData.actionTarget || "",
            icon: buttonData.icon || "application-default-icon",
            iconOnly: buttonData.iconOnly || false,
            color: buttonData.color || "",
            arguments: buttonData.arguments || "",
            runInTerminal: buttonData.runInTerminal !== undefined ? buttonData.runInTerminal : false,
            workingDirectory: buttonData.workingDirectory || ""
        }
        
        buttons.push(newButton)
        buttons = buttons // Trigger property change
        saveButtons()
        console.log("Button added:", newButton.label)
        return newButton.id
    }
    
    // Update an existing button
    function updateButton(buttonId, buttonData) {
        let index = buttons.findIndex(btn => btn.id === buttonId)
        if (index !== -1) {
            // Merge new data with existing button (manually, since spread operator not supported)
            let existingButton = buttons[index]
            buttons[index] = {
                id: buttonId, // Preserve ID
                label: buttonData.label !== undefined ? buttonData.label : existingButton.label,
                tooltip: buttonData.tooltip !== undefined ? buttonData.tooltip : existingButton.tooltip,
                actionType: buttonData.actionType !== undefined ? buttonData.actionType : existingButton.actionType,
                actionTarget: buttonData.actionTarget !== undefined ? buttonData.actionTarget : existingButton.actionTarget,
                icon: buttonData.icon !== undefined ? buttonData.icon : existingButton.icon,
                iconOnly: buttonData.iconOnly !== undefined ? buttonData.iconOnly : existingButton.iconOnly,
                color: buttonData.color !== undefined ? buttonData.color : existingButton.color,
                arguments: buttonData.arguments !== undefined ? buttonData.arguments : existingButton.arguments,
                runInTerminal: buttonData.runInTerminal !== undefined ? buttonData.runInTerminal : existingButton.runInTerminal,
                workingDirectory: buttonData.workingDirectory !== undefined ? buttonData.workingDirectory : existingButton.workingDirectory
            }
            buttons = buttons // Trigger property change
            saveButtons()
            console.log("Button updated:", buttonId)
            return true
        }
        console.error("Button not found:", buttonId)
        return false
    }
    
    // Delete a button by ID
    function deleteButton(buttonId) {
        let index = buttons.findIndex(btn => btn.id === buttonId)
        if (index !== -1) {
            let label = buttons[index].label
            buttons.splice(index, 1)
            buttons = buttons // Trigger property change
            saveButtons()
            console.log("Button deleted:", label)
            return true
        }
        console.error("Button not found:", buttonId)
        return false
    }
    
    // Move button to new position
    function moveButton(fromIndex, toIndex) {
        if (fromIndex < 0 || fromIndex >= buttons.length || 
            toIndex < 0 || toIndex >= buttons.length) {
            console.error("Invalid move indices:", fromIndex, toIndex)
            return false
        }
        
        let button = buttons.splice(fromIndex, 1)[0]
        buttons.splice(toIndex, 0, button)
        buttons = buttons // Trigger property change
        saveButtons()
        console.log("Button moved from", fromIndex, "to", toIndex)
        return true
    }
    
    // Get button by ID
    function getButton(buttonId) {
        return buttons.find(btn => btn.id === buttonId)
    }
    
    // Get all buttons
    function getAllButtons() {
        return buttons
    }
    
    // Clear all buttons
    function clearAllButtons() {
        buttons = []
        saveButtons()
        console.log("All buttons cleared")
    }
    
    // Import buttons from JSON string
    function importButtons(jsonString) {
        try {
            let importedButtons = JSON.parse(jsonString)
            if (Array.isArray(importedButtons)) {
                // Ensure all buttons have IDs
                let processedButtons = []
                for (let i = 0; i < importedButtons.length; i++) {
                    let btn = importedButtons[i]
                    processedButtons.push({
                        id: btn.id || generateUniqueId(),
                        label: btn.label || "New Button",
                        tooltip: btn.tooltip || "",
                        actionType: btn.actionType || "script",
                        actionTarget: btn.actionTarget || "",
                        icon: btn.icon || "application-default-icon",
                        iconOnly: btn.iconOnly || false,
                        color: btn.color || "",
                        arguments: btn.arguments || "",
                        runInTerminal: btn.runInTerminal || false,
                        workingDirectory: btn.workingDirectory || ""
                    })
                }
                buttons = processedButtons
                saveButtons()
                console.log("Buttons imported:", buttons.length)
                return true
            }
        } catch (e) {
            console.error("Error importing buttons:", e)
        }
        return false
    }
    
    // Export buttons as JSON string
    function exportButtons() {
        return JSON.stringify(buttons, null, 2)
    }

    fullRepresentation: Item {
        id: mainView

        // Dynamic sizing based on button count and layout
        Layout.minimumWidth: getMinimumWidth()
        Layout.minimumHeight: getMinimumHeight()
        Layout.preferredWidth: buttonGrid.implicitWidth + (Kirigami.Units.smallSpacing * 2)
        Layout.preferredHeight: buttonGrid.implicitHeight + (Kirigami.Units.smallSpacing * 2)

        // Main layout container
        GridLayout {
            id: buttonGrid
            anchors.fill: parent
            anchors.margins: Kirigami.Units.smallSpacing
            
            columns: getColumns()
            rows: getRows()
            
            columnSpacing: plasmoid.configuration.spacing
            rowSpacing: plasmoid.configuration.spacing
            
            flow: getLayoutFlow()

            Repeater {
                model: root.buttons

                PlasmaComponents.Button {
                    id: button
                    
                    required property var modelData
                    required property int index
                    
                    Layout.fillWidth: shouldFillWidth()
                    Layout.fillHeight: shouldFillHeight()
                    Layout.preferredWidth: shouldFillWidth() ? -1 : getButtonWidth()
                    Layout.preferredHeight: shouldFillHeight() ? -1 : getButtonHeight()
                    Layout.maximumWidth: getButtonWidth() * 2
                    Layout.maximumHeight: getButtonHeight() * 2

                    text: modelData.iconOnly ? "" : modelData.label
                    icon.name: modelData.icon && !modelData.icon.startsWith("/") ? modelData.icon : ""
                    icon.source: modelData.icon && modelData.icon.startsWith("/") ? modelData.icon : ""
                    
                    // Larger icon size when icon-only mode
                    icon.width: modelData.iconOnly ? getButtonSize() * 0.6 : Kirigami.Units.iconSizes.medium
                    icon.height: modelData.iconOnly ? getButtonSize() * 0.6 : Kirigami.Units.iconSizes.medium
                    
                    display: modelData.iconOnly ? PlasmaComponents.AbstractButton.IconOnly : 
                             PlasmaComponents.AbstractButton.TextBesideIcon

                    // Enhanced tooltip with more info
                    PlasmaComponents.ToolTip {
                        text: {
                            let tip = modelData.tooltip || modelData.label
                            if (modelData.actionType === "script") {
                                tip += "\n" + i18n("Script: %1", modelData.actionTarget)
                            } else if (modelData.actionType === "application") {
                                tip += "\n" + i18n("Application: %1", modelData.actionTarget)
                            } else if (modelData.actionType === "url") {
                                tip += "\n" + i18n("URL: %1", modelData.actionTarget)
                            }
                            return tip
                        }
                    }

                    onClicked: {
                        console.log("==========================================")
                        console.log("BUTTON CLICKED!")
                        console.log("Label:", modelData.label)
                        console.log("Action Type:", modelData.actionType)
                        console.log("Action Target:", modelData.actionTarget)
                        console.log("==========================================")
                        
                        // Visual feedback animation
                        clickAnimation.start()
                        executeAction(modelData)
                    }

                    // Custom background with theme colors and optional override
                    background: Rectangle {
                        id: buttonBg
                        
                        color: {
                            if (modelData.color && modelData.color !== "") {
                                return modelData.color
                            }
                            return button.pressed ? Qt.darker(root.buttonBackgroundColor, 1.2) : 
                                   button.hovered ? Qt.lighter(root.buttonBackgroundColor, 1.1) :
                                   root.buttonBackgroundColor
                        }
                        
                        border.color: button.activeFocus ? root.highlightColor :
                                     button.hovered ? Qt.lighter(root.highlightColor, 1.5) :
                                     "transparent"
                        border.width: 2
                        radius: Kirigami.Units.cornerRadius
                        
                        // Smooth color transitions
                        Behavior on color {
                            ColorAnimation { duration: Kirigami.Units.shortDuration }
                        }
                        
                        Behavior on border.color {
                            ColorAnimation { duration: Kirigami.Units.shortDuration }
                        }
                        
                        // Click feedback animation
                        SequentialAnimation {
                            id: clickAnimation
                            PropertyAnimation {
                                target: buttonBg
                                property: "scale"
                                to: 0.95
                                duration: Kirigami.Units.shortDuration
                            }
                            PropertyAnimation {
                                target: buttonBg
                                property: "scale"
                                to: 1.0
                                duration: Kirigami.Units.shortDuration
                            }
                        }
                    }
                    
                    // Ensure text color is always visible and handle icon sizing
                    contentItem: Item {
                        implicitWidth: button.width
                        implicitHeight: button.height
                        
                        // Large centered icon for icon-only mode
                        Kirigami.Icon {
                            id: buttonIconOnly
                            anchors.centerIn: parent
                            source: button.icon.name || button.icon.source
                            width: Math.min(parent.width, parent.height) * 0.6
                            height: Math.min(parent.width, parent.height) * 0.6
                            visible: button.modelData.iconOnly && source != ""
                            color: getContrastColor(buttonBg.color)
                        }
                        
                        // Icon + text layout (only visible when NOT icon-only)
                        RowLayout {
                            anchors.centerIn: parent
                            width: parent.width - Kirigami.Units.smallSpacing * 2
                            spacing: Kirigami.Units.smallSpacing
                            visible: !button.modelData.iconOnly
                            
                            Kirigami.Icon {
                                id: textModeIcon
                                source: button.icon.name || button.icon.source
                                Layout.preferredWidth: Kirigami.Units.iconSizes.smallMedium
                                Layout.preferredHeight: Kirigami.Units.iconSizes.smallMedium
                                visible: source != ""
                                color: getContrastColor(buttonBg.color)
                            }
                            
                            PlasmaComponents.Label {
                                text: button.text
                                color: getContrastColor(buttonBg.color)
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                                // Align left if icon exists, center if no icon
                                horizontalAlignment: textModeIcon.visible ? Text.AlignLeft : Text.AlignHCenter
                            }
                        }
                    }
                }
            }
        }

        // Placeholder when no buttons
        PlasmaComponents.Label {
            anchors.centerIn: parent
            visible: root.buttons.length === 0
            text: i18n("Right-click to configure buttons")
            color: root.textColor
            opacity: 0.6
            font.italic: true
            
            PlasmaComponents.ToolTip {
                text: i18n("Add custom buttons for quick access to scripts, applications, and websites")
            }
        }
    }

    function getButtonWidth() {
        return plasmoid.configuration.buttonWidth || 80
    }
    
    function getButtonHeight() {
        return plasmoid.configuration.buttonHeight || 60
    }
    
    // Get contrasting text color based on background brightness
    function getContrastColor(bgColor) {
        // If it's the default theme color, use theme text color
        if (bgColor === root.buttonBackgroundColor || !bgColor || bgColor.toString() === "#00000000") {
            return root.textColor
        }
        
        // Calculate relative luminance
        let r = bgColor.r
        let g = bgColor.g
        let b = bgColor.b
        
        // Calculate perceived brightness
        let brightness = (r * 299 + g * 587 + b * 114) / 1000
        
        // Return white for dark backgrounds, black for light backgrounds
        return brightness > 0.5 ? "#000000" : "#ffffff"
    }
    
    function getColumns() {
        let layoutType = plasmoid.configuration.layoutType
        if (layoutType === "row") {
            return root.buttons.length || 1
        } else if (layoutType === "column") {
            return 1
        } else {
            // Grid layout
            return plasmoid.configuration.gridColumns || 3
        }
    }
    
    function getRows() {
        let layoutType = plasmoid.configuration.layoutType
        if (layoutType === "column") {
            return root.buttons.length || 1
        } else if (layoutType === "row") {
            return 1
        } else {
            // Grid layout - calculate based on button count and columns
            return Math.ceil((root.buttons.length || 1) / (plasmoid.configuration.gridColumns || 3))
        }
    }
    
    function getLayoutFlow() {
        // GridLayout.LeftToRight is the default (0)
        return GridLayout.LeftToRight
    }
    
    function shouldFillWidth() {
        return plasmoid.configuration.layoutType === "column" || root.inPanel
    }
    
    function shouldFillHeight() {
        return plasmoid.configuration.layoutType === "row" && root.inPanel
    }
    
    function getMinimumWidth() {
        if (root.buttons.length === 0) return Kirigami.Units.gridUnit * 10
        
        let layoutType = plasmoid.configuration.layoutType
        let btnWidth = getButtonWidth()
        let spacing = plasmoid.configuration.spacing
        
        if (layoutType === "row") {
            return btnWidth * root.buttons.length + spacing * (root.buttons.length - 1) + Kirigami.Units.smallSpacing * 2
        } else if (layoutType === "column") {
            return btnWidth + Kirigami.Units.smallSpacing * 2
        } else {
            // Grid
            let cols = plasmoid.configuration.gridColumns || 3
            return btnWidth * Math.min(cols, root.buttons.length) + spacing * (Math.min(cols, root.buttons.length) - 1) + Kirigami.Units.smallSpacing * 2
        }
    }
    
    function getMinimumHeight() {
        if (root.buttons.length === 0) return Kirigami.Units.gridUnit * 5
        
        let layoutType = plasmoid.configuration.layoutType
        let btnHeight = getButtonHeight()
        let spacing = plasmoid.configuration.spacing
        
        if (layoutType === "column") {
            return btnHeight * root.buttons.length + spacing * (root.buttons.length - 1) + Kirigami.Units.smallSpacing * 2
        } else if (layoutType === "row") {
            return btnHeight + Kirigami.Units.smallSpacing * 2
        } else {
            // Grid
            let cols = plasmoid.configuration.gridColumns || 3
            let rows = Math.ceil(root.buttons.length / cols)
            return btnHeight * rows + spacing * (rows - 1) + Kirigami.Units.smallSpacing * 2
        }
    }

    function executeAction(buttonData) {
        console.log("Executing action:", buttonData.actionType, buttonData.actionTarget)
        
        if (!buttonData.actionTarget || buttonData.actionTarget.trim() === "") {
            showNotification(i18n("Error"), i18n("No action target specified for button: %1", buttonData.label), "error")
            return
        }
        
        try {
            switch (buttonData.actionType) {
                case "url":
                    executeUrl(buttonData)
                    break
                    
                case "application":
                    executeApplication(buttonData)
                    break
                    
                case "script":
                    executeScript(buttonData)
                    break
                    
                default:
                    console.error("Unknown action type:", buttonData.actionType)
                    showNotification(i18n("Error"), i18n("Unknown action type: %1", buttonData.actionType), "error")
            }
        } catch (e) {
            console.error("Error executing action:", e)
            showNotification(i18n("Error"), i18n("Failed to execute: %1", e.toString()), "error")
        }
    }
    
    function executeUrl(buttonData) {
        let url = buttonData.actionTarget.trim()
        
        // Add https:// if no protocol specified
        if (!url.match(/^[a-zA-Z]+:\/\//)) {
            url = "https://" + url
        }
        
        console.log("==========================================")
        console.log("OPENING URL:", url)
        console.log("==========================================")
        
        let result = Qt.openUrlExternally(url)
        console.log("Qt.openUrlExternally result:", result)
    }
    
    function executeApplication(buttonData) {
        let appCommand = buttonData.actionTarget.trim()
        let args = buttonData.arguments ? buttonData.arguments.trim() : ""
        
        console.log("Launching application:", appCommand, "with args:", args)
        
        commandExecutor.launchApplication(appCommand, args)
    }
    
    function executeScript(buttonData) {
        let scriptPath = buttonData.actionTarget.trim()
        let args = buttonData.arguments ? buttonData.arguments.trim() : ""
        
        // Build command
        let fullCommand = scriptPath
        if (args) {
            fullCommand += " " + args
        }
        
        console.log("Executing script:", fullCommand)
        
        executeCommand(fullCommand, buttonData.workingDirectory, buttonData.runInTerminal)
    }

    function executeCommand(command, workingDir, useTerminal) {
        if (!command || command.trim() === "") {
            console.error("Empty command")
            return
        }
        
        console.log("=== COMMAND EXECUTION ===")
        console.log("Command:", command)
        console.log("Working Dir:", workingDir || "default")
        console.log("Use Terminal:", useTerminal)
        console.log("=========================")
        
        if (useTerminal) {
            commandExecutor.executeInTerminal(command, workingDir || "")
        } else {
            commandExecutor.executeCommand(command, workingDir || "")
        }
    }
    
    function escapeForDesktopFile(text) {
        return text.replace(/\\/g, '\\\\').replace(/"/g, '\\"')
    }
    
    function escapeForBash(text) {
        return text.replace(/\\/g, '\\\\').replace(/"/g, '\\"').replace(/\$/g, '\\$').replace(/`/g, '\\`').replace(/'/g, "'\\''")
    }
    
    function escapeShellArg(arg) {
        // Escape single quotes by replacing ' with '\''
        return arg.replace(/'/g, "'\\''")
    }
    
    function buildTerminalCommand(command, workingDir) {
        let terminalCmd = ""
        let scriptContent = command
        
        // Add working directory change if specified
        if (workingDir && workingDir.trim() !== "") {
            scriptContent = "cd \"" + escapeShellArg(workingDir) + "\" && " + command
        }
        
        // Konsole (KDE default)
        terminalCmd = "konsole --hold -e bash -c '" + escapeShellArg(scriptContent) + "; echo; echo Press any key to close...; read -n1'"
        
        return terminalCmd
    }
    
    function showNotification(title, message, iconName) {
        console.log("Notification:", title, "-", message)
        // Notifications disabled for now - need proper Plasma 6 API
    }
}

