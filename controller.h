#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>

#include <windows.h>

class Controller : public QObject
{
    Q_OBJECT

    HHOOK mouse_hook_id, keyboard_hook_id;

private slots:
    void emergencyUnlock (Qt::ApplicationState state);
public:
    explicit Controller(const QApplication *app = 0);

    Q_INVOKABLE void lockScreen ( bool lock );

signals:

public slots:

};

#endif // CONTROLLER_H
