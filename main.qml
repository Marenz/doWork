import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.0

ApplicationWindow
{
    visible: true
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    title: qsTr("Do Work Reminder v0.3")
    id: main

    flags: Qt.WindowFullScreen | Qt.WindowStaysOnTopHint

    Component.onDestruction: controller.lockScreen(false)

    function hide ( seconds )
    {
        lockTimer.interval = 1000 * seconds;
        lockTimer.start();
        controller.lockScreen(false);

        main.visible = false;
    }

    Timer
    {
        id: lockTimer

        running: false

        triggeredOnStart: false

        repeat: false

        onTriggered:
        {
            console.log("locking..");
            controller.lockScreen(true);
            main.visible = true;
            taskInput.focus = true;
            taskInput.selectAll();
        }
    }


    ListModel
    {
        id: listModel

        ListElement
        {
            task: "example"
            time: "20"
        }
    }

    Column
    {
        anchors.fill: parent
        anchors.margins: 100
        //anchors.verticalCenter: parent.verticalCenter
        spacing: 25
        id: column

        property var escaped: 0

        Keys.onEscapePressed:
        {
            if ( ++escaped > 2 )
                return;

            console.log("Giving you 2 minutes of peace.");

            hide(2*60);
        }
        //height: parent.height

        Row
        {
            //color: "red"
            //width: 400
            //height: 40

            //anchors.horizontalCenter: parent.horizontalCenter

            Text
            {
                id: taskLabel
                text: qsTr("I will ");

                //anchors.left: parent.left
            }

            TextField
            {
                id: taskInput

                focus: true

                placeholderText: "make a list"

                //anchors.left: taskLabel.right
                //anchors.leftMargin: 3

                onAccepted:
                {
                    taskInput.focus = false;
                    timeInput.focus = true;
                    timeInput.selectAll();
                }
            }

            Text
            {
                id: labelFor
                text: " for "
                visible: true

                //anchors.left: taskInput.right
                //anchors.leftMargin: 3
            }

            TextField
            {
                id: timeInput

                focus: false

                //anchors.left: labelFor.right
                //anchors.leftMargin: 3

                width: 30

                placeholderText: "20"

                onTextChanged: timeInput.textColor = "black";

                onAccepted:
                {
                    var time = parseInt(text);

                    if ( isNaN(time) || time <= 0 )
                    {
                        timeInput.textColor = "red";
                        return;
                    }

                    console.log("Sleeping for " +
                                time
                                + " minutes");

                    var date = new Date;

                    if (listModel.get(0).task != taskInput.text)
                        listModel.insert(0,
                                         { 'task' : taskInput.text,
                                           'time' : date.toTimeString()});



                    column.escaped = 0;

                    hide(time);
                }
            }

            Text
            {
                id: labelTime
                text: qsTr(" minutes")
                visible: true

                //anchors.left: timeInput.right
                //anchors.leftMargin: 0
            }
        }


        TableView
        {
            id: taskTable
            model: listModel

            height: parent.height
            width: 500

            anchors.horizontalCenter: parent.horizontalCenter

            TableViewColumn {
                role: "task"
                title: "Task"
                width: 400
            }
            TableViewColumn {
                role: "time"
                title: "Time"
                width: 100
            }
            /*delegate: Text {
                    text: task + ": " + time
                }*/
        }
    }

}
