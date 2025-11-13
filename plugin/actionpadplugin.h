#ifndef ACTIONPADPLUGIN_H
#define ACTIONPADPLUGIN_H

#include <QQmlExtensionPlugin>

class ActionPadPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char *uri) override;
};

#endif // ACTIONPADPLUGIN_H

