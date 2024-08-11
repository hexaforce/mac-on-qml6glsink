import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Window

import org.freedesktop.gstreamer.Qt6GLVideoItem 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 1920
    height: 1080
    x: (Screen.width - width) / 2
    y: (Screen.height - height) / 2
    color: "transparent"

    Item {
        anchors.fill: parent

        GstGLQt6VideoItem {
            id: video
            objectName: "videoItem"
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
        }

        // Rectangle {
        //     color: Qt.rgba(1, 1, 1, 0.7)
        //     border.width: 1
        //     border.color: "white"
        //     anchors.bottom: video.bottom
        //     anchors.bottomMargin: 15
        //     anchors.horizontalCenter: parent.horizontalCenter
        //     width : parent.width - 30
        //     height: parent.height - 30
        //     radius: 8

        //     MouseArea {
        //         id: mousearea
        //         anchors.fill: parent
        //         hoverEnabled: true
        //         onEntered: {
        //             parent.opacity = 1.0
        //             hidetimer.start()
        //         }
        //     }

        //     Timer {
        //         id: hidetimer
        //         interval: 5000
        //         onTriggered: {
        //             parent.opacity = 0.0
        //             stop()
        //         }
        //     }
        // }
    }
}
