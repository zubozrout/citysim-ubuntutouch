#ifndef UTILITIES_LIST_H
#define UTILITIES_LIST_H

#include <QObject>
#include <QString>
#include <QQmlListProperty>

class CitySim: public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool canLoad MEMBER m_canLoad NOTIFY canLoadChanged)

public:
    CitySim();
    ~CitySim() = default;

    Q_INVOKABLE void save(QVariantMap data);
    Q_INVOKABLE QVariantMap load();

Q_SIGNALS:
    void canLoadChanged(const bool &canLoad);

private:
    QString m_dataDir;
    QString m_saveFile;
    bool m_canLoad = false;
};

#endif
