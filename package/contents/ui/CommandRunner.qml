import QtQuick
import org.kde.plasma.core as PlasmaCore

Item {
    id: commandRunner
    
    property string command: ""
    
    PlasmaCore.DataEngine {
        id: execEngine
        dataEngine: "executable"
        
        property var service: execEngine.serviceForSource(command)
        
        Component.onCompleted: {
            if (command) {
                service.startOperationCall(service.operationDescription("run"))
                Qt.callLater(commandRunner.destroy)
            }
        }
    }
}

