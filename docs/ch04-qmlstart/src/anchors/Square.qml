
// Square.qml   正方形

import QtQuick 2.5

Rectangle {
    width: 96
    height: width
    border.color: Qt.lighter(color)
    property alias text: label.text

    Text {
        id: label
        anchors.centerIn: parent
        color: "#f0f0f0"
    }
    MouseArea {
        anchors.fill: parent
        drag.target: parent
    }
}
