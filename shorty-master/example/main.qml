
import QtQuick 2.0

Rectangle {                         // 主界面
    width: 200
    height: 200
    color: 'red'
    property int index: 0

    Rectangle {                    // 控件
        x: 20; y: 30
        width: 20; height: 20
        color: 'green'      
        NumberAnimation on x {          // 动画 x 值变化
            to: 160; duration: 10000
        }
    }

    Timer {                             // 定时器
        id: delay
        interval: 10000/4 // 5 frames, each 96x96 px
        repeat: true                    
        triggeredOnStart: true
        onTriggered: shoot()    // 调用组件的方法
    }

    function shoot() {              // 截屏
        shorty.shoot('sample'+index+'.png')     // 
        if(index == 4) {    
            delay.stop()
            Qt.quit()
        }
        index += 1
    }



    Component.onCompleted: {   //  组件构建完成后开启定时器
        delay.start()
    }
}
