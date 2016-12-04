#ifndef UTILITIES_LIST_H
#define UTILITIES_LIST_H

#include <QObject>
#include <QString>
#include <QQmlListProperty>

class CitySim: public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool canLoad MEMBER m_canLoad NOTIFY canLoadChanged)
    Q_PROPERTY(bool muted READ getMuted WRITE setMuted NOTIFY settingsChanged)
    Q_PROPERTY(bool showViability READ getShowViability WRITE setShowViability NOTIFY settingsChanged)

public:
    CitySim();
    ~CitySim() = default;

    Q_INVOKABLE void save(QVariantMap data);
    Q_INVOKABLE QVariantMap load();

    void setMuted(const bool muted);
    bool getMuted() const;

    void setShowViability(const bool showViability);
    bool getShowViability() const;

Q_SIGNALS:
    void canLoadChanged(const bool &canLoad);
    void settingsChanged();

private:
    void saveSettings();
    void loadSettings();

    QVariantMap m_settings;
    QString m_dataDir;
    QString m_saveFile;
    QString m_settingsFile;
    bool m_canLoad = false;
};

#endif
