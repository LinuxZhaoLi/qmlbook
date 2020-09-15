// animate.qml

import QtQuick 2.5

Item {
    id: root
    width: background.width
    height: background.height

    property int rotationStep: 45

    Image {
        id: background
        source: "images/background.png"
    }

    Image {
        id: pole
        x: (root.width - width)/2+2
        y: root.height - height
        source: "images/pole.png"
    }

    Image {
        id: pinwheel
        anchors.centerIn: parent
        source: "images/pinwheel.png"
        // visible: false
        Behavior on rotation {
            NumberAnimation { duration: 125 }
        }
    }

    Image {
        id: blur
        opacity: 0
        anchors.centerIn: parent
        source: "images/blur.png"
        // visible: false
        Behavior on rotation {
            NumberAnimation { duration: 125 }
        }
        Behavior on opacity {
            NumberAnimation { duration: 125 }
        }

    }

    // M1>>
    focus: true
    Keys.onLeftPressed: {
        blur.opacity = 1
        pinwheel.rotation -= root.rotationStep
        blur.rotation -= root.rotationStep
    }
    Keys.onRightPressed: {
        blur.opacity = 0.5
        pinwheel.rotation += root.rotationStep
        blur.rotation += root.rotationStep
    }
    Keys.onReleased: {
        blur.opacity = 0
    }
    // <<M1
}
