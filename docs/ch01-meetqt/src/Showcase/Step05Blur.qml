
// blur.qml

import QtQuick 2.5
import QtGraphicalEffects 1.0

Rectangle {
    id: window
    width: background.width
    height: background.height

    // M1>>
    Image {
        id: background
        source: "images/background.png"
    }
    Image {
        id: pole
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        source: "images/pole.png"
    }

    Image {
        id: pinwheel
        anchors.centerIn: parent
        source: "images/pinwheel.png"
        layer.effect: FastBlur {
            id: blur
            radius: 32
        }
        layer.enabled: true
    }
}
