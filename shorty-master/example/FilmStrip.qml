/*
  重复器的使用。
  
*/
import QtQuick 2.0

Rectangle {                     // 界面
    width: 512
    height: 96+32
    color: 'black'
    property int imageCount: 5
    property string imagePrefix: 'sample'


    Row {                       // 布局器
        anchors.centerIn: parent 
        spacing: 4
        Repeater {
            model: imageCount    // 传参到重复器中     

            Rectangle {
                width: 96; height: 96
                Image {                                     // 传参到重复器中
                    source: imagePrefix + index + '.png'
                   Component.onCompleted:{

                   console.log(imagePrefix + index + '.png')
                   }
                }
            }
        }
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 4
        spacing: 4
        Repeater {
            model: 32
            Rectangle {
                width: 12; height: 8
                color: '#fefefe'
                border.color: Qt.darker(color)
                smooth: true
            }
        }
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height-4-height
        spacing: 4
        Repeater {
            model: 32
            Rectangle {
                width: 12; height: 8
                color: '#fefefe'
                border.color: Qt.darker(color)
                smooth: true
            }
        }
    }
}
