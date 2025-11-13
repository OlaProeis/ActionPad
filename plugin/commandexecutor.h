#ifndef COMMANDEXECUTOR_H
#define COMMANDEXECUTOR_H

#include <QObject>
#include <QProcess>
#include <QString>
#include <QVariantMap>

class CommandExecutor : public QObject
{
    Q_OBJECT

public:
    explicit CommandExecutor(QObject *parent = nullptr);
    ~CommandExecutor();

public slots:
    // Execute a command in the background
    void executeCommand(const QString &command, const QString &workingDirectory = QString());
    
    // Execute a command in a terminal
    void executeInTerminal(const QString &command, const QString &workingDirectory = QString());
    
    // Launch an application
    void launchApplication(const QString &application, const QString &arguments = QString());
    
signals:
    void commandStarted(const QString &command);
    void commandFinished(int exitCode, const QString &output);
    void commandError(const QString &error);
};

#endif // COMMANDEXECUTOR_H

