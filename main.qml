import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.0

ApplicationWindow {
    visible: true
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    title: qsTr("Do Work Reminder")
    id: main

    flags: Qt.WindowFullScreen | Qt.WindowStaysOnTopHint

    Component.onCompleted: controller.lockScreen(true)

    Component.onDestruction: controller.lockScreen(false)

    onVisibilityChanged: console.log(visibility)

    MouseArea
    {
        anchors.fill: parent

        hoverEnabled: true

        onContainsMouseChanged:
        {
            if ( containsMouse )
                return;

        }
    }

    Column
    {
        anchors.fill: parent
        anchors.margins: 100
        anchors.verticalCenter: parent.verticalCenter

        height: 200

        ListView
        {

        }

        Timer
        {
            id: lockTimer

            running: false

            triggeredOnStart: false

            repeat: false

            onTriggered:
            {
                console.log("Unlocking..");
                controller.lockScreen(true);
                input.state = ""
            }
        }

        Item
        {
            id: input

            width: 200
            anchors.horizontalCenter: parent.horizontalCenter

            states:
            [
                State
                {
                    name: "time"

                    PropertyChanges  {
                        target: taskInput; visible: true
                    }

                    PropertyChanges  {
                        target: labelFor; visible: true
                    }

                    PropertyChanges {
                        target: inputField;
                        onAccepted:
                        {
                            timeInput.text = text;
                            text = "";
                            input.state = "confirm";
                            lockTimer.interval = timeInput.text * 1000 * 60;
                            lockTimer.start();
                            controller.lockScreen(false);
                        }
                    }

                    AnchorChanges
                    {
                        target: inputField
                        anchors.left: labelFor.right
                    }
                },

                State
                {
                    name: "confirm"

                    PropertyChanges {
                        target: main
                        visible: false
                    }

                    PropertyChanges  {
                        target: taskInput; visible: true
                    }

                    PropertyChanges  {
                        target: labelFor; visible: true
                    }

                    PropertyChanges  {
                        target: timeInput; visible: true
                    }

                    PropertyChanges {
                        target: inputField
                        visible: false
                        text: ""
                    }

                    AnchorChanges  {
                        target: labelTime
                        anchors.left: timeInput.right
                    }

                }

            ]

            Text
            {
                id: label
                text: "I want to "

                anchors.left: parent.left

            }

            Text
            {
                id: taskInput
                text: ""
                visible: false

                anchors.left: label.right
                anchors.leftMargin: 3
            }

            Text
            {
                id: labelFor
                text: " for "
                visible: false

                anchors.left: taskInput.right
                anchors.leftMargin: 0
            }

            Text
            {
                id: timeInput
                text: ""
                visible: false

                anchors.left: labelFor.right
                anchors.leftMargin: 1
            }

            TextField
            {
                id: inputField

                focus: true

                onFocusChanged: console.log("No focus :o");

                anchors.left: label.right
                anchors.leftMargin: 3
                anchors.right: parent.right

                onAccepted:
                {
                    taskInput.text = text;
                    text = "";
                    input.state = "time";
                }
            }

            Text
            {
                id: labelTime
                text: " minutes"
                visible: true

                anchors.left: inputField.right
                anchors.leftMargin: 0
            }
        }
    }

}
