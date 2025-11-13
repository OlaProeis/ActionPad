cmake_minimum_required(VERSION 3.16)
project(actionpad)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find required packages
find_package(ECM REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)

find_package(Qt6 REQUIRED COMPONENTS
    Core
    Qml
    Quick
)

# Plasma package installation (doesn't need KF6::Plasma for building)
# IMPORTANT: Use DOTS for package ID
install(DIRECTORY package/ DESTINATION ${KDE_INSTALL_DATADIR}/plasma/plasmoids/com.github.actionpad)

# Build the C++ plugin
set(actionpad_SRCS
    plugin/commandexecutor.cpp
    plugin/actionpadplugin.cpp
)

add_library(actionpadplugin SHARED ${actionpad_SRCS})

target_link_libraries(actionpadplugin
    Qt::Core
    Qt::Qml
    Qt::Quick
)

# Get Qt6's QML installation path
get_target_property(QT_QMAKE_EXECUTABLE Qt6::qmake IMPORTED_LOCATION)
execute_process(
    COMMAND ${QT_QMAKE_EXECUTABLE} -query QT_INSTALL_QML
    OUTPUT_VARIABLE QT_INSTALL_QML
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

# Install plugin to Qt6's QML path
# IMPORTANT: Use SLASHES for filesystem path
install(TARGETS actionpadplugin DESTINATION ${QT_INSTALL_QML}/com/github/actionpad)
install(FILES plugin/qmldir DESTINATION ${QT_INSTALL_QML}/com/github/actionpad)

