#include "controller.h"

#include <QDebug>
#include <QApplication>
#include <QWidget>
#include <QQmlApplicationEngine>

#include <QWindow>

extern QQmlApplicationEngine* engine;

Controller::Controller(const QApplication *app) :
    QObject(NULL)
{
    connect(app, &QApplication::applicationStateChanged,
            this, &Controller::emergencyUnlock);
}


void Controller::emergencyUnlock (Qt::ApplicationState state)
{
    if ( state != Qt::ApplicationActive )
    {
        qWarning() << "Warning: Application inactive, releasing controlls!";
        this->lockScreen(false);
    }
}

LRESULT CALLBACK LowLevelKeyboardProc(int nCode, WPARAM wParam, LPARAM lParam)
{
    if ( nCode < 0 )
        return CallNextHookEx(NULL, nCode, wParam, lParam);

    if (nCode == HC_ACTION &&
        (wParam == WM_KEYDOWN || wParam == WM_KEYUP ))
    {
        KBDLLHOOKSTRUCT *kbd = reinterpret_cast<KBDLLHOOKSTRUCT*>(lParam);

        switch (kbd->vkCode)
        {
            case VK_CONTROL:
            case VK_MENU:
            case VK_PAUSE:
            case VK_LWIN:
            case VK_RWIN:
                return 1;
            default:
                //qDebug() << "ncode:" << nCode << "vkcode: " << kbd->vkCode << "flgs: " << kbd->flags << "scanc: " << kbd->scanCode;
               return CallNextHookEx(NULL, nCode, wParam, lParam);
        }
    }

    return 1;
}

void Controller::lockScreen ( bool lock )
{
    if (lock)
    {
        QWindow *rootObject = (QWindow*)engine->rootObjects().first();

        auto h = rootObject->property(("height")).toInt();
        auto w = rootObject->property(("width")).toInt();
        auto x = rootObject->property(("x")).toInt();
        auto y = rootObject->property(("y")).toInt();

        RECT rect;

        rect.left = x;
        rect.top = y;
        rect.right = x+w;
        rect.bottom = y+h;

        ClipCursor(&rect);

        keyboard_hook_id = SetWindowsHookEx(WH_KEYBOARD_LL,
                                            LowLevelKeyboardProc, NULL, 0);
    }
    else
    {
        UnhookWindowsHookEx(mouse_hook_id);
        UnhookWindowsHookEx(keyboard_hook_id);
        ClipCursor(NULL);
    }
}
