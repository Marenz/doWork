import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.0

ApplicationWindow
{
    visible: true
    width: 600
    height: 600
    title: qsTr("Do Work Reminder v1.0")
    id: main
    objectName: "main"

    flags: Qt.FramelessWindowHint
    color: "#7F99CE"

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
    }

    Column
    {
        anchors.fill: parent
        anchors.margins: 50
        //anchors.verticalCenter: parent.verticalCenter
        spacing: 10
        id: column

        property var escaped: 0

        Keys.onEscapePressed:
        {
            if ( ++escaped > 2 )
                return;

            console.log("Giving you 2 minutes of peace.");

            hide(2*60);
        }

        Row
        {
            //width: 400
            //height: 40

            anchors.horizontalCenter: parent.horizontalCenter

            Text
            {
                id: taskLabel
                text: qsTr("I will ");
            }

            TextField
            {
                id: taskInput

                focus: true

                placeholderText: "make a list"

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
            }

            TextField
            {
                id: timeInput
                focus: false
                width: 30
                placeholderText: "20"
                onTextChanged: timeInput.textColor = "black";

                onAccepted:
                {
                    var time = parseInt(text);

                    if (taskInput.text == "")
                    {
                        taskInput.focus = true;
                        return;
                    }

                    if ( isNaN(time) || time <= 0 )
                    {
                        timeInput.textColor = "red";
                        return;
                    }

                    console.log("Sleeping for " +
                                time
                                + " minutes");

                    var date = new Date;

                    if (listModel.count == 0 ||
                        listModel.get(0).task != taskInput.text)
                    {
                        listModel.insert(0,
                                         { 'task' : taskInput.text,
                                           'time' : date.toTimeString()});
                    }

                    column.escaped = 0;

                    hide(time*60);
                }
            }

            Text
            {
                id: labelTime
                text: qsTr(" minutes")
                visible: true
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
                width: 97
            }
        }
    }

}
