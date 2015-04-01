#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>

#include "controller.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    Controller controller(&app);

    QQmlApplicationEngine engine;

    auto a_type = qmlRegisterUncreatableType <Controller>
        ("main.controller", 1, 0, "Controller",
         "Controller is not creatable");
    Q_ASSERT(a_type != 0);

    engine.rootContext()->setContextProperty("controller", &controller);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));


    return app.exec();
}
