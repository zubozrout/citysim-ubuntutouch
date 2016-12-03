#include <QDebug>
#include <QStandardPaths>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>
#include <QFile>
#include <QDir>

#include "citysim.h"

CitySim::CitySim() {
    m_dataDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    m_saveFile = m_dataDir + "/save.json";

    m_canLoad = QFile(m_saveFile).exists();
    canLoadChanged(m_canLoad);
}

void CitySim::save(QVariantMap data) {
    qDebug() << "saving";

    QJsonDocument doc;
    QJsonObject object = QJsonObject::fromVariantMap(data);
    doc.setObject(object);

    if (!QDir(m_dataDir).exists()) {
        QDir().mkdir(m_dataDir);
    }

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
