TEMPLATE = app

QT += qml quick widgets

SOURCES += main.cpp \
    controller.cpp

RESOURCES += qml.qrc

LIBS += User32.lib

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    controller.h
