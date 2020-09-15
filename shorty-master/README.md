Shorty可用于从QML创建屏幕截图/屏幕截图序列。目的是生成屏幕快照或屏幕快照序列以进行测试和记录。
Building
-------- `qmake && make`
 
最后生成 `bin/shorty`.
运行： short.exe main.qml

Simply specify a qml-file to short. From within the qml-file, the global 
`shorty` object provides the following functions:

  - `shorty.shootFull( filename )` - grab a screenshot and save it as 
    `filename`.
  - `shorty.shoot( filename )` - grab a screenshot, scale it to 96x96 pixels
     and save it as `filename`.
  - `shorty.sendKeyPress( key )` - send a key press event for `key` to the 
     scene.
  - `shorty.sendMouseClick( x, y )` - send a left mouse button click at the 
     coordinate `x`, `y` to the scene.

该example目录包含两个简单的示例。main.qml演示如何获取屏幕截图。
FilmStrip.qml用于创建一系列屏幕截图的幻灯片（恰好非常适合shorty.shoot()输出格式）。

架构：
	1 定义一个类，需要一个类，提供截屏方法。
	2 命令行参数传入： 文件名
	3 界面对象传入自定义类中
	4 qml界面调用自定义类的方法
	5 开启定时器，动画。