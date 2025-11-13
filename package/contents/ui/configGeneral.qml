import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import QtQuick.Dialogs
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import org.kde.plasma.plasmoid
import org.kde.iconthemes as KIconThemes

KCM.SimpleKCM {
    id: configPage

    property alias cfg_layoutType: layoutTypeCombo.currentValue
    property alias cfg_buttonSize: buttonSizeCombo.currentValue
    property alias cfg_buttonWidth: buttonWidthSlider.value
    property alias cfg_buttonHeight: buttonHeightSlider.value
    property alias cfg_spacing: spacingSpinBox.value
    property alias cfg_gridColumns: gridColumnsSpinBox.value
    property string cfg_buttonsData: plasmoid.configuration.buttonsData
    
    // Local button model for editing
    property var buttonList: []
    
    Component.onCompleted: {
        loadButtons()
    }
    
    function loadButtons() {
        try {
            if (cfg_buttonsData && cfg_buttonsData !== "[]") {
                buttonList = JSON.parse(cfg_buttonsData)
            } else {
                buttonList = []
            }
        } catch (e) {
            console.error("Error loading buttons in config:", e)
            buttonList = []
        }
    }
    
    function saveButtons() {
        cfg_buttonsData = JSON.stringify(buttonList)
    }
    
    function addNewButton() {
        let newButton = {
            id: "btn_" + Date.now() + "_" + Math.floor(Math.random() * 1000),
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
        buttonList.push(newButton)
        buttonList = buttonList // Trigger update
        buttonListView.model = buttonList
        saveButtons()
        
        // Edit the new button immediately
        editButtonDialog.currentButtonId = newButton.id
        editButtonDialog.loadButton(newButton)
        editButtonDialog.open()
    }
    
    function deleteButton(buttonId) {
        let index = buttonList.findIndex(btn => btn.id === buttonId)
        if (index !== -1) {
            buttonList.splice(index, 1)
            buttonList = buttonList // Trigger update
            buttonListView.model = buttonList
            saveButtons()
        }
    }
    
    function moveButtonUp(index) {
        if (index > 0) {
            let temp = buttonList[index]
            buttonList[index] = buttonList[index - 1]
            buttonList[index - 1] = temp
            buttonList = buttonList // Trigger update
            buttonListView.model = buttonList
            saveButtons()
        }
    }
    
    function moveButtonDown(index) {
        if (index < buttonList.length - 1) {
            let temp = buttonList[index]
            buttonList[index] = buttonList[index + 1]
            buttonList[index + 1] = temp
            buttonList = buttonList // Trigger update
            buttonListView.model = buttonList
            saveButtons()
        }
    }

    ColumnLayout {
        spacing: Kirigami.Units.largeSpacing
        
        Kirigami.FormLayout {
            
            // Layout Settings Section
            Kirigami.Separator {
                Kirigami.FormData.isSection: true
                Kirigami.FormData.label: i18n("Layout Settings")
            }

            QQC2.ComboBox {
                id: layoutTypeCombo
                Kirigami.FormData.label: i18n("Layout Type:")
                model: [
                    { text: i18n("Grid"), value: "grid" },
                    { text: i18n("Row"), value: "row" },
                    { text: i18n("Column"), value: "column" }
                ]
                textRole: "text"
                valueRole: "value"
                
                Component.onCompleted: {
                    currentIndex = indexOfValue(plasmoid.configuration.layoutType)
                }
            }

            QQC2.SpinBox {
                id: gridColumnsSpinBox
                Kirigami.FormData.label: i18n("Grid Columns:")
                from: 1
                to: 10
                visible: layoutTypeCombo.currentValue === "grid"
            }

            QQC2.ComboBox {
                id: buttonSizeCombo
                Kirigami.FormData.label: i18n("Button Size:")
                model: [
                    { text: i18n("Tiny (40x30)"), value: "tiny" },
                    { text: i18n("Small (60x45)"), value: "small" },
                    { text: i18n("Medium (80x60)"), value: "medium" },
                    { text: i18n("Large (100x75)"), value: "large" },
                    { text: i18n("Extra Large (120x90)"), value: "xlarge" },
                    { text: i18n("Custom"), value: "custom" }
                ]
                textRole: "text"
                valueRole: "value"
                
                Component.onCompleted: {
                    currentIndex = indexOfValue(plasmoid.configuration.buttonSize)
                }
                
                onCurrentValueChanged: {
                    // Update sliders when preset is selected
                    if (currentValue === "tiny") {
                        buttonWidthSlider.value = 40
                        buttonHeightSlider.value = 30
                    } else if (currentValue === "small") {
                        buttonWidthSlider.value = 60
                        buttonHeightSlider.value = 45
                    } else if (currentValue === "medium") {
                        buttonWidthSlider.value = 80
                        buttonHeightSlider.value = 60
                    } else if (currentValue === "large") {
                        buttonWidthSlider.value = 100
                        buttonHeightSlider.value = 75
                    } else if (currentValue === "xlarge") {
                        buttonWidthSlider.value = 120
                        buttonHeightSlider.value = 90
                    }
                    // For "custom", don't change slider values
                }
            }
            
            RowLayout {
                Kirigami.FormData.label: i18n("Button Width:")
                visible: buttonSizeCombo.currentValue === "custom"
                
                QQC2.Slider {
                    id: buttonWidthSlider
                    Layout.fillWidth: true
                    from: 30
                    to: 200
                    stepSize: 5
                    
                    onMoved: {
                        buttonSizeCombo.currentIndex = buttonSizeCombo.indexOfValue("custom")
                    }
                }
                
                QQC2.Label {
                    text: buttonWidthSlider.value + "px"
                    Layout.minimumWidth: 50
                }
            }
            
            RowLayout {
                Kirigami.FormData.label: i18n("Button Height:")
                visible: buttonSizeCombo.currentValue === "custom"
                
                QQC2.Slider {
                    id: buttonHeightSlider
                    Layout.fillWidth: true
                    from: 25
                    to: 150
                    stepSize: 5
                    
                    onMoved: {
                        buttonSizeCombo.currentIndex = buttonSizeCombo.indexOfValue("custom")
                    }
                }
                
                QQC2.Label {
                    text: buttonHeightSlider.value + "px"
                    Layout.minimumWidth: 50
                }
            }

            QQC2.SpinBox {
                id: spacingSpinBox
                Kirigami.FormData.label: i18n("Spacing:")
                from: 0
                to: 50
            }
        }

        // Buttons Management Section
        Kirigami.Separator {
            Layout.fillWidth: true
        }
        
        RowLayout {
            Layout.fillWidth: true
            
            Kirigami.Heading {
                text: i18n("Buttons")
                level: 2
            }
            
            Item { Layout.fillWidth: true }
            
            QQC2.Button {
                text: i18n("Add Button")
                icon.name: "list-add"
                onClicked: addNewButton()
            }
        }

        QQC2.ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 200

            ListView {
                id: buttonListView
                clip: true
                model: buttonList

                delegate: Kirigami.SwipeListItem {
                    id: listItem
                    
                    required property var modelData
                    required property int index
                    
                    contentItem: RowLayout {
                        spacing: Kirigami.Units.smallSpacing
                        
                        Kirigami.Icon {
                            source: listItem.modelData.icon
                            Layout.preferredWidth: Kirigami.Units.iconSizes.small
                            Layout.preferredHeight: Kirigami.Units.iconSizes.small
                        }
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0
                            
                            QQC2.Label {
                                text: listItem.modelData.label
                                font.bold: true
                                Layout.fillWidth: true
                            }
                            
                            QQC2.Label {
                                text: {
                                    let type = listItem.modelData.actionType
                                    let target = listItem.modelData.actionTarget
                                    if (target.length > 50) {
                                        target = target.substring(0, 47) + "..."
                                    }
                                    return type.charAt(0).toUpperCase() + type.slice(1) + ": " + target
                                }
                                opacity: 0.7
                                font.pointSize: Kirigami.Theme.smallFont.pointSize
                                Layout.fillWidth: true
                            }
                        }
                        
                        QQC2.ToolButton {
                            icon.name: "go-up"
                            enabled: listItem.index > 0
                            onClicked: moveButtonUp(listItem.index)
                            QQC2.ToolTip.text: i18n("Move Up")
                            QQC2.ToolTip.visible: hovered
                        }
                        
                        QQC2.ToolButton {
                            icon.name: "go-down"
                            enabled: listItem.index < buttonList.length - 1
                            onClicked: moveButtonDown(listItem.index)
                            QQC2.ToolTip.text: i18n("Move Down")
                            QQC2.ToolTip.visible: hovered
                        }
                        
                        QQC2.ToolButton {
                            icon.name: "document-edit"
                            onClicked: {
                                // Ensure button has an ID
                                let btnData = listItem.modelData
                                if (!btnData.id) {
                                    btnData.id = "btn_" + Date.now() + "_" + Math.floor(Math.random() * 1000)
                                }
                                editButtonDialog.currentButtonId = btnData.id || ""
                                editButtonDialog.loadButton(btnData)
                                editButtonDialog.open()
                            }
                            QQC2.ToolTip.text: i18n("Edit")
                            QQC2.ToolTip.visible: hovered
                        }
                        
                        QQC2.ToolButton {
                            icon.name: "delete"
                            onClicked: deleteButton(listItem.modelData.id)
                            QQC2.ToolTip.text: i18n("Delete")
                            QQC2.ToolTip.visible: hovered
                        }
                    }
                }
                
                Kirigami.PlaceholderMessage {
                    anchors.centerIn: parent
                    width: parent.width - (Kirigami.Units.largeSpacing * 4)
                    visible: buttonList.length === 0
                    text: i18n("No buttons yet")
                    explanation: i18n("Click 'Add Button' to create your first shortcut")
                    icon.name: "list-add"
                }
            }
        }
    }
    
    // Edit Button Dialog
    QQC2.Dialog {
        id: editButtonDialog
        
        title: i18n("Edit Button")
        modal: true
        standardButtons: QQC2.Dialog.Ok | QQC2.Dialog.Cancel
        
        property string currentButtonId: ""
        
        anchors.centerIn: parent
        width: Math.min(500, configPage.width * 0.9)
        
        function loadButton(buttonData) {
            labelField.text = buttonData.label || ""
            tooltipField.text = buttonData.tooltip || ""
            actionTypeCombo.currentIndex = actionTypeCombo.indexOfValue(buttonData.actionType || "script")
            actionTargetField.text = buttonData.actionTarget || ""
            iconField.text = buttonData.icon || ""
            iconOnlyCheck.checked = buttonData.iconOnly || false
            colorField.text = buttonData.color || ""
            argumentsField.text = buttonData.arguments || ""
            runInTerminalCheck.checked = buttonData.runInTerminal || false
            workingDirectoryField.text = buttonData.workingDirectory || ""
        }
        
        function saveButton() {
            let index = buttonList.findIndex(btn => btn.id === currentButtonId)
            if (index !== -1) {
                buttonList[index] = {
                    id: currentButtonId,
                    label: labelField.text,
                    tooltip: tooltipField.text,
                    actionType: actionTypeCombo.currentValue,
                    actionTarget: actionTargetField.text,
                    icon: iconField.text,
                    iconOnly: iconOnlyCheck.checked,
                    color: colorField.text,
                    arguments: argumentsField.text,
                    runInTerminal: runInTerminalCheck.checked,
                    workingDirectory: workingDirectoryField.text
                }
                buttonList = buttonList // Trigger update
                buttonListView.model = buttonList
                configPage.saveButtons()
            }
        }
        
        onAccepted: saveButton()
        
        contentItem: QQC2.ScrollView {
            Kirigami.FormLayout {
                QQC2.TextField {
                    id: labelField
                    Kirigami.FormData.label: i18n("Label:")
                    placeholderText: i18n("Button text")
                }
                
                QQC2.TextField {
                    id: tooltipField
                    Kirigami.FormData.label: i18n("Tooltip:")
                    placeholderText: i18n("Hover text")
                }
                
                QQC2.ComboBox {
                    id: actionTypeCombo
                    Kirigami.FormData.label: i18n("Action Type:")
                    model: [
                        { text: i18n("Script"), value: "script" },
                        { text: i18n("Application"), value: "application" },
                        { text: i18n("URL"), value: "url" }
                    ]
                    textRole: "text"
                    valueRole: "value"
                }
                
                RowLayout {
                    Kirigami.FormData.label: i18n("Action Target:")
                    
                    QQC2.TextField {
                        id: actionTargetField
                        Layout.fillWidth: true
                        placeholderText: {
                            switch (actionTypeCombo.currentValue) {
                                case "script": return i18n("/path/to/script.sh")
                                case "application": return i18n("application-name")
                                case "url": return i18n("https://example.com")
                                default: return ""
                            }
                        }
                    }
                    
                    QQC2.Button {
                        text: i18n("Browse...")
                        visible: actionTypeCombo.currentValue === "script"
                        onClicked: scriptFileDialog.open()
                    }
                }
                
                ColumnLayout {
                    Kirigami.FormData.label: i18n("Icon:")
                    spacing: Kirigami.Units.smallSpacing
                    
                    RowLayout {
                        spacing: Kirigami.Units.smallSpacing
                        
                        // Icon preview
                        Kirigami.Icon {
                            id: iconPreview
                            source: iconField.text || "application-default-icon"
                            Layout.preferredWidth: Kirigami.Units.iconSizes.medium
                            Layout.preferredHeight: Kirigami.Units.iconSizes.medium
                            Layout.alignment: Qt.AlignVCenter
                        }
                        
                        QQC2.TextField {
                            id: iconField
                            Layout.fillWidth: true
                            placeholderText: i18n("icon-name or /path/to/icon.png")
                        }
                    }
                    
                    RowLayout {
                        spacing: Kirigami.Units.smallSpacing
                        
                        QQC2.Button {
                            text: i18n("Pick System Icon...")
                            icon.name: "preferences-desktop-icons"
                            onClicked: iconPickerDialog.open()
                        }
                        
                        QQC2.Button {
                            text: i18n("Browse Custom File...")
                            icon.name: "document-open"
                            onClicked: iconFileDialog.open()
                        }
                        
                        Item { Layout.fillWidth: true } // Spacer
                    }
                }
                
                RowLayout {
                    Kirigami.FormData.label: i18n("Button Color:")
                    
                    QQC2.TextField {
                        id: colorField
                        Layout.fillWidth: true
                        Layout.preferredWidth: 150
                        placeholderText: i18n("Leave empty for theme color")
                        
                        // Show color preview
                        Rectangle {
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: 5
                            width: 30
                            height: 30
                            radius: 3
                            color: colorField.text || "transparent"
                            border.color: Kirigami.Theme.textColor
                            border.width: 1
                            visible: colorField.text !== ""
                        }
                    }
                    
                    QQC2.Button {
                        text: i18n("Clear")
                        icon.name: "edit-clear"
                        onClicked: colorField.text = ""
                    }
                }
                
                // Color Presets
                GridLayout {
                    Kirigami.FormData.label: i18n("Color Presets:")
                    columns: 8
                    columnSpacing: 5
                    rowSpacing: 5
                    
                    Repeater {
                        model: [
                            "#e74c3c", "#e67e22", "#f39c12", "#f1c40f",  // Reds, oranges, yellows
                            "#2ecc71", "#1abc9c", "#3498db", "#9b59b6",  // Greens, blues, purples
                            "#34495e", "#95a5a6", "#7f8c8d", "#2c3e50",  // Grays, dark
                            "#ff6b6b", "#4ecdc4", "#45b7d1", "#96ceb4"   // Pastels
                        ]
                        
                        Rectangle {
                            required property string modelData
                            required property int index
                            
                            width: 30
                            height: 30
                            radius: 3
                            color: modelData
                            border.color: colorField.text === modelData ? Kirigami.Theme.highlightColor : Kirigami.Theme.textColor
                            border.width: colorField.text === modelData ? 3 : 1
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: colorField.text = parent.modelData
                                
                                QQC2.ToolTip {
                                    text: parent.parent.modelData
                                    visible: parent.containsMouse
                                }
                            }
                        }
                    }
                }
                
                QQC2.CheckBox {
                    id: iconOnlyCheck
                    Kirigami.FormData.label: i18n("Icon Only:")
                    text: i18n("Hide text, show only icon")
                }
                
                QQC2.TextField {
                    id: argumentsField
                    Kirigami.FormData.label: i18n("Arguments:")
                    placeholderText: i18n("Additional arguments")
                }
                
                QQC2.CheckBox {
                    id: runInTerminalCheck
                    Kirigami.FormData.label: i18n("Run in Terminal:")
                    text: i18n("Show terminal output")
                    visible: actionTypeCombo.currentValue === "script"
                }
                
                QQC2.TextField {
                    id: workingDirectoryField
                    Kirigami.FormData.label: i18n("Working Directory:")
                    placeholderText: i18n("/path/to/directory")
                }
            }
        }
    }
    
    // File dialogs
    FileDialog {
        id: scriptFileDialog
        title: i18n("Choose Script File")
        currentFolder: "file://" + (workingDirectoryField.text || "/home")
        onAccepted: {
            actionTargetField.text = selectedFile.toString().replace("file://", "")
        }
    }
    
    FileDialog {
        id: iconFileDialog
        title: i18n("Choose Icon File")
        nameFilters: [i18n("Image files (*.png *.svg *.jpg)")]
        currentFolder: "file:///usr/share/icons"
        onAccepted: {
            iconField.text = selectedFile.toString().replace("file://", "")
        }
    }
    
    // Icon Picker Dialog
    KIconThemes.IconDialog {
        id: iconPickerDialog
        onIconNameChanged: function() {
            if (iconPickerDialog.iconName) {
                iconField.text = iconPickerDialog.iconName
            }
        }
    }
}
