#include "pianokee.h"
#include <QApplication>
#include <QQuickView>
#include <QQmlContext>
#include <QQmlEngine>
#include <QtQuick>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QQuickView view;

    pianokee pk;
    view.engine()->rootContext()->setContextProperty("_pd", &pk);
    view.setSource(QUrl("qrc:main.qml"));
    view.show();
    return app.exec();
}
