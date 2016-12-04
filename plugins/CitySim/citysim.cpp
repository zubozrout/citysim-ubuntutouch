#include <QDebug>
#include <QStandardPaths>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>
#include <QFile>
#include <QDir>
#include <QVariant>

#include "citysim.h"

CitySim::CitySim() :
    m_settings()
{
    m_dataDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    m_saveFile = m_dataDir + "/save.json";
    m_settingsFile = m_dataDir + "/settings.json";

    if (!QDir(m_dataDir).exists()) {
        QDir().mkdir(m_dataDir);
    }

    m_canLoad = QFile(m_saveFile).exists();
    canLoadChanged(m_canLoad);

    loadSettings();
}

void CitySim::save(QVariantMap data) {
    qDebug() << "saving";

    QJsonDocument doc;
    QJsonObject object = QJsonObject::fromVariantMap(data);
    doc.setObject(object);

    QFile save(m_saveFile);
    save.open(QFile::WriteOnly | QFile::Text | QFile::Truncate);
    save.write(doc.toJson());
    save.close();

    qDebug() << "saved";
}

QVariantMap CitySim::load() {
    qDebug() << "loading";

    QFile save(m_saveFile);
    save.open(QFile::ReadOnly);

    QJsonDocument doc = QJsonDocument::fromJson(save.readAll());
    QJsonObject object = doc.object();

    qDebug() << "loaded";
    return object.toVariantMap();
}

void CitySim::setMuted(const bool muted) {
    m_settings["muted"] = QVariant(muted);
    saveSettings(); //TODO When there are more settings it'll be smart to deffer this until a button is hit or something
}

bool CitySim::getMuted() const {
    return m_settings.value("muted", QVariant(false)).toBool();
}

void CitySim::setShowViability(const bool showViability) {
    m_settings["showViability"] = QVariant(showViability);
    saveSettings();
}

bool CitySim::getShowViability() const {
    return m_settings.value("showViability", QVariant(false)).toBool();
}

void CitySim::saveSettings() {
    qDebug() << "saving settings";

    QJsonDocument doc;
    QJsonObject object = QJsonObject::fromVariantMap(m_settings);
    doc.setObject(object);

    QFile file(m_settingsFile);
    file.open(QFile::WriteOnly | QFile::Text | QFile::Truncate);
    file.write(doc.toJson());
    file.close();

    qDebug() << "settings saved";
    Q_EMIT settingsChanged();
}

void CitySim::loadSettings() {
    if (QFile(m_saveFile).exists()) {
        qDebug() << "loading settings";

        QFile file(m_settingsFile);
        file.open(QFile::ReadOnly);

        QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
        QJsonObject object = doc.object();
        m_settings = object.toVariantMap();

        qDebug() << "settings loaded";
        Q_EMIT settingsChanged();
    }
    else {
        qDebug() << "no settings to load";
    }
}
