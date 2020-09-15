#ifndef SHORTY_H
#define SHORTY_H

#include <QtCore/QtCore>

class QQuickView;  // 声明一个，未定义

class Shorty : public QObject  // 定义一个类
{
    Q_OBJECT
public:
    explicit Shorty(QQuickView *view, QObject *parent = 0);  // 构造函数
    Q_INVOKABLE void shoot(const QString& name);          //目的在于被修饰的成员函数能够被元对象系统所唤起。
                                                          // 抓取屏幕截图并将其另存为
    Q_INVOKABLE void shootFull(const QString &name);      // 抓取屏幕截图，将其缩放为96x96像素
    Q_INVOKABLE void sendKeyPress(int key);               //将按键事件发送key到场景。
    Q_INVOKABLE void sendMouseClick(int x, int y);        // 在发送一个鼠标左键点击坐标x，y到现场
private:
    QQuickView *_view;                                     // 定义一个指针
};

#endif // SHORTY_H
