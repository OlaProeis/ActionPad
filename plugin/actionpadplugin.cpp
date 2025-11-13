#include "actionpadplugin.h"
#include "commandexecutor.h"
#include <QQmlEngine>

void ActionPadPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(QString(uri) == QLatin1String("com.github.actionpad"));
    
    qmlRegisterType<CommandExecutor>(uri, 1, 0, "CommandExecutor");
}

