#include "commandexecutor.h"
#include <QDebug>
#include <QDir>
#include <QStandardPaths>

CommandExecutor::CommandExecutor(QObject *parent)
    : QObject(parent)
{
}

CommandExecutor::~CommandExecutor()
{
}

void CommandExecutor::executeCommand(const QString &command, const QString &workingDirectory)
{
    qDebug() << "CommandExecutor: Executing command:" << command;
    qDebug() << "CommandExecutor: Working directory:" << workingDirectory;
    
    QProcess *process = new QProcess(this);
    
    // Set working directory if specified
    if (!workingDirectory.isEmpty()) {
        process->setWorkingDirectory(workingDirectory);
    }
    
    // Execute in background (detached)
    process->startDetached("/bin/bash", QStringList() << "-c" << command);
    
    emit commandStarted(command);
    
    // Clean up
    process->deleteLater();
}

void CommandExecutor::executeInTerminal(const QString &command, const QString &workingDirectory)
{
    qDebug() << "CommandExecutor: Executing in terminal:" << command;
    qDebug() << "CommandExecutor: Working directory:" << workingDirectory;
    
    QString fullCommand = command;
    
    // Add working directory change if specified
    if (!workingDirectory.isEmpty()) {
        fullCommand = QString("cd '%1' && %2").arg(workingDirectory, command);
    }
    
    // Build terminal command with proper escaping
    QString terminalCommand = QString("konsole -e bash -c \"%1; echo ''; echo 'Press Enter to close...'; read\"")
                              .arg(QString(fullCommand).replace("\"", "\\\""));
    
    QProcess *process = new QProcess(this);
    process->startDetached("/bin/bash", QStringList() << "-c" << terminalCommand);
    
    emit commandStarted(command);
    
    // Clean up
    process->deleteLater();
}

void CommandExecutor::launchApplication(const QString &application, const QString &arguments)
{
    qDebug() << "CommandExecutor: Launching application:" << application;
    qDebug() << "CommandExecutor: Arguments:" << arguments;
    
    QProcess *process = new QProcess(this);
    
    // Check if it's a .desktop file
    if (application.endsWith(".desktop")) {
        // Use gtk-launch or kde-open
        process->startDetached("gtk-launch", QStringList() << application);
    } else {
        // Launch application directly
        QStringList args;
        if (!arguments.isEmpty()) {
            // Split arguments properly (simple split by space)
            args = arguments.split(' ', Qt::SkipEmptyParts);
        }
        process->startDetached(application, args);
    }
    
    emit commandStarted(application);
    
    // Clean up
    process->deleteLater();
}

