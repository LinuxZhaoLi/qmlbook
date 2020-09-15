

// showcase.qml

import QtQuick 2.5
import QtGraphicalEffects 1.0
// 降低颜色的饱和度

Image {
    id: root
    source: "images/background.png"

    property int blurRadius: 0

    Image {
        id: pole
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        source: "images/pole.png"
    }

    /*
保持应用于此层的效果。

该效果通常是ShaderEffect组件，尽管可以指定任何项组件。该效果应具有名称匹配的源纹理属性layer.samplerName.

另请参见layer.samplerName和项目层。

*/
    Image {
        id: wheel
        anchors.centerIn: parent
        source: "images/pinwheel.png"
        Behavior on rotation {              // 动画作用于
            NumberAnimation {
                duration: 250
            }
        }

        /*
FastBlur提供的模糊质量低于GaussianBlur，但渲染速度更快。
FastBlur效果通过使用源内容降尺度和双线性滤波的算法对源内容进行模糊处理，
从而软化源内容。在源内容快速变化且不需要最高模糊质量的情况下使用此效果。
*/    // item
        layer.effect: FastBlur {  // 层
            id: blur
            radius: root.blurRadius

            Behavior on radius {

                NumberAnimation {
                    duration: 250
                }
            }
        }
        layer.enabled: true
    }

    MouseArea {
        anchors.fill: parent
        onPressed: {
            wheel.rotation += 90
            root.blurRadius = 16   //不透明度
        }
        onReleased: {
            root.blurRadius = 0
        }
    }
}
