#include <QtQml>
#include <QtQml/QQmlContext>

#include "plugin.h"
#include "citysim.h"

void CitySimPlugin::registerTypes(const char *uri) {
    //@uri CitySim
    qmlRegisterSingletonType<CitySim>(uri, 1, 0, "CitySim", [](QQmlEngine*, QJSEngine*) -> QObject* { return new CitySim; });
}

void CitySimPlugin::initializeEngine(QQmlEngine *engine, const char *uri) {
    QQmlExtensionPlugin::initializeEngine(engine, uri);
}
