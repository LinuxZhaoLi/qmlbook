If you want to test your compilation, you can now run the example with the default runtime that comes with Qt 5::

        $ qtbase/bin/qmlscene



.. code-block:: cpp

    // module or class includes
    #include <QtCore>

    // text stream is text-codec aware
    QTextStream cout(stdout, QIODevice::WriteOnly);

    int main(int argc, char** argv)
    {
        // avoid compiler warnings
        Q_UNUSED(argc)
        Q_UNUSED(argv)
        QString s1("Paris");
        QString s2("London");
        // string concatenation
        QString s = s1 + " " + s2 + "!";
        cout << s << endl;
    }

.. rubric:: Container Classes


.. code-block:: cpp

    QString s1("Hello");
    QString s2("Qt");
    QList<QString> list;
    // stream into containers
    list << s1 << s2;
    // Java and STL like iterators
    QListIterator<QString> iter(list);
    while(iter.hasNext()) {
        cout << iter.next();
        if(iter.hasNext()) {
            cout << " ";
        }
    }
    cout << "!" << endl;

这里有一个更高级的list函数，它允许您将一个字符串列表连接成一个字符串。当您需要继续基于行的文本输入时，这非常方便。使用`QString:：split（）``函数也可以进行反向操作（字符串到字符串列表）。

.. code-block:: cpp


    QString s1("Hello");
    QString s2("Qt");
    // convenient container classes
    QStringList list;
    list <<  s1 << s2;
    // join strings
    QString s = list.join(" ") + "!";
    cout << s << endl;   ---》 Hello Qt!




.. rubric:: File IO

在下一个代码片段中，我们从本地目录中读取一个CSV文件，并在行上循环以从每一行提取单元格。这样，我们从CSV文件中获取表数据，大约20行代码。文件读取为我们提供了一个字节流，为了能够将其转换为有效的Unicode文本，我们需要使用文本流并将文件作为较低级别的流传入。对于编写CSV文件，您只需要在write模式下打开文件，并将这些行通过管道传输到文本流中。

.. code-block:: cpp


    QList<QStringList> data;   定义一个列表
    // file operations
    QFile file("sample.csv");   文件对象
    if(file.open(QIODevice::ReadOnly)) {    打开文件
        QTextStream stream(&file);       文本流
        // loop forever macro
        forever {   === while(1)
            QString line = stream.readLine();
            // test for null string 'String()'
            if(line.isNull()) {
                break;
            }
            // test for empty string 'QString("")'
            if(line.isEmpty()) {
                continue;
            }
            QStringList row;
            // for each loop to iterate over containers
            foreach(const QString& cell, line.split(",")) {
                row.append(cell.trimmed());
            }
            data.append(row);
        }
    }
    // 无需清理

This concludes the section about console based applications with Qt.
在这个基于小部件的应用程序的第一个片段中，我们只需根据需要创建一个窗口并显示它。在Qt中，没有父对象的小部件是一个窗口。我们使用一个有作用域的指针来确保当指针超出范围时小部件被删除。application对象封装了Qt运行时，我们用`exec（）``调用启动事件循环。从那时起，应用程序只对由用户输入（如鼠标或键盘）或其他事件提供程序（如网络或文件IO）触发的事件作出反应。只有当事件循环退出时，应用程序才会退出。这可以通过在应用程序上调用“quit（）”或关闭窗口来完成。


QScopedPointer类存储指向动态分配对象的指针，并在销毁时将其删除。

手动管理堆分配的对象很难而且容易出错，常见的结果是代码泄漏内存并且很难维护。QScopedPointer是一个小型实用程序类，它通过将基于堆栈的内存所有权分配给堆分配，从而大大简化了这一过程，更一般地称为资源获取是初始化（resource acquisition is initialization，rai）。

QScopedPointer保证当当前作用域消失时，指向的对象将被删除。

考虑这个函数，它执行堆分配，并且有各种出口点：
    #include <QtGui>

    int main(int argc, char** argv)
    {
        QApplication app(argc, argv);
        QScopedPointer<QWidget> widget(new CustomWidget());
        widget->resize(240, 120);
        widget->show();
        return app.exec();
    }

小部件还具有如何处理键盘和鼠标输入以及如何对外部触发器做出反应的内部知识。要在Qt中实现这一点，我们需要从“QWidget”派生并重写几个用于绘制和事件处理的函数。

    #ifndef CUSTOMWIDGET_H
    #define CUSTOMWIDGET_H

    #include <QtWidgets>

    class CustomWidget : public QWidget
    {
        Q_OBJECT
    public:
        explicit CustomWidget(QWidget *parent = 0);
        void paintEvent(QPaintEvent *event);
        void mousePressEvent(QMouseEvent *event);
        void mouseMoveEvent(QMouseEvent *event);
    private:
        QPoint m_lastPos;
    };

    #endif // CUSTOMWIDGET_H


    #include "customwidget.h"

    CustomWidget::CustomWidget(QWidget *parent) :
        QWidget(parent)
    {
    }

    void CustomWidget::paintEvent(QPaintEvent *)
    {
        QPainter painter(this);
        QRect r1 = rect().adjusted(10,10,-10,-10);
        painter.setPen(QColor("#33B5E5"));
        painter.drawRect(r1);

        QRect r2(QPoint(0,0),QSize(40,40));
        if(m_lastPos.isNull()) {
            r2.moveCenter(r1.center());
        } else {
            r2.moveCenter(m_lastPos);
        }
        painter.fillRect(r2, QColor("#FFBB33"));
    }

    void CustomWidget::mousePressEvent(QMouseEvent *event)
    {
        m_lastPos = event->pos();
        update();
    }

    void CustomWidget::mouseMoveEvent(QMouseEvent *event)
    {
        m_lastPos = event->pos();
        update();
    }

这是一个所谓的widget容器的头文件。
    class CustomWidget : public QWidget
    {
        Q_OBJECT
    public:
        explicit CustomWidget(QWidget *parent = 0);
    private slots:
        void itemClicked(QListWidgetItem* item);
        void updateItem();
    private:
        QListWidget *m_widget;
        QLineEdit *m_edit;
        QPushButton *m_button;
    };

   

    CustomWidget::CustomWidget(QWidget *parent) :
        QWidget(parent)
    {
        QVBoxLayout *layout = new QVBoxLayout(this);
        m_widget = new QListWidget(this);
        layout->addWidget(m_widget);

        m_edit = new QLineEdit(this);
        layout->addWidget(m_edit);

        m_button = new QPushButton("Quit", this);
        layout->addWidget(m_button);
        setLayout(layout);

        QStringList cities;
        cities << "Paris" << "London" << "Munich";
        foreach(const QString& city, cities) {
            m_widget->addItem(city);
        }

        connect(m_widget, SIGNAL(itemClicked(QListWidgetItem*)), this, SLOT(itemClicked(QListWidgetItem*)));
        connect(m_edit, SIGNAL(editingFinished()), this, SLOT(updateItem()));
        connect(m_button, SIGNAL(clicked()), qApp, SLOT(quit()));
    }

    void CustomWidget::itemClicked(QListWidgetItem *item)
    {
        Q_ASSERT(item);
        m_edit->setText(item->text());
    }

    void CustomWidget::updateItem()
    {
        QListWidgetItem* item = m_widget->currentItem();
        if(item) {
            item->setText(m_edit->text());
        }
    }


首先是包含视图和场景声明的头文件。
    class CustomWidgetV2 : public QWidget
    {
        Q_OBJECT
    public:
        explicit CustomWidgetV2(QWidget *parent = 0);
    private:
        QGraphicsView *m_view;
        QGraphicsScene *m_scene;

    };

场景首先附加到视图。视图是一个小部件，它被安排在容器小部件中。最后，我们在场景中添加一个小矩形，然后在视图上进行渲染。
.. code-block:: cpp

    #include "customwidgetv2.h"

    CustomWidget::CustomWidget(QWidget *parent) :
        QWidget(parent)
    {
        m_view = new QGraphicsView(this);
        m_scene = new QGraphicsScene(this);
        m_view->setScene(m_scene);

        QVBoxLayout *layout = new QVBoxLayout(this);
        layout->setMargin(0);
        layout->addWidget(m_view);
        setLayout(layout);

        QGraphicsItem* rect1 = m_scene->addRect(0,0, 40, 40, Qt::NoPen, QColor("#FFBB33"));
        rect1->setFlags(QGraphicsItem::ItemIsFocusable|QGraphicsItem::ItemIsMovable);
    }

我们主要讨论了基本数据类型以及如何使用小部件和图形视图。在您的应用程序中，您通常需要大量的结构化数据，这些数据可能还需要持久地存储。最后，还需要显示数据。为此，Qt使用模型。一个简单的模型是字符串列表模型，它由字符串填充，然后附加到列表视图。
    m_view = new QListView(this);
    m_model = new QStringListModel(this);
    view->setModel(m_model);

    QList<QString> cities;
    cities << "Munich" << "Paris" << "London";
    m_model->setStringList(cities);

创建数据库

.. code-block:: sql

    CREATE TABLE city (name TEXT, country TEXT);
    INSERT INTO city value ("Munich", "Germany");
    INSERT INTO city value ("Paris", "France");
    INSERT INTO city value ("London", "United Kingdom");

使用sql
.. code-block:: cpp

    QT += sql

与之前的其他模型一样，生成的模型可以附加到列表视图。


    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("cities.db");
    if(!db.open()) {
        qFatal("unable to open database");
    }

    m_model = QSqlTableModel(this);
    m_model->setTable("city");
    m_model->setHeaderData(0, Qt::Horizontal, "City");
    m_model->setHeaderData(1, Qt::Horizontal, "Country");

    view->setModel(m_model);
    m_model->select();

排序文件代理模型，允许您对模型进行排序、筛选和转换。

    QSortFilterProxyModel* proxy = new QSortFilterProxyModel(this);
    proxy->setSourceModel(m_model);
    view->setModel(proxy);
    view->setSortingEnabled(true);
过滤器：

    proxy->setFilterKeyColumn(0);
    proxy->setFilterCaseSensitive(Qt::CaseInsensitive);
    proxy->setFilterFixedString(QString)


Qt Questy提供了一个声明性环境，其中用户界面（前端）被声明为HTML，后端是本机C++代码。这可以让你两全其美。

    import QtQuick 2.5

    Rectangle {
        width: 240; height: 1230
        Rectangle {
            width: 40; height: 40
            anchors.centerIn: parent
            color: '#FFBB33'
        }
    }

声明语言称为QML，它需要运行时来执行它。
    QQuickView* view = new QQuickView();
    QUrl source = QUrl::fromLocalFile("main.qml");
    view->setSource(source);
    view->show();

在本例中，前端需要一个名为“cityModel”的对象，我们可以在列表视图中使用它。

    import QtQuick 2.5

    Rectangle {
        width: 240; height: 120
        ListView {
            width: 180; height: 120
            anchors.centerIn: parent
            model: cityModel
            delegate: Text { text: model.city }
        }
    }

要启用“cityModel”，我们可以重用以前的模型，并在根上下文中添加一个context属性。根上下文是主文档中的另一个根元素。
    m_model = QSqlTableModel(this);
    ... // some magic code
    QHash<int, QByteArray> roles;
    roles[Qt::UserRole+1] = "city";
    roles[Qt::UserRole+2] = "country";
    m_model->setRoleNames(roles);
    view->rootContext()->setContextProperty("cityModel", m_model);

它在支持不同的应用程序模型方面也很丰富：控制台、经典桌面用户界面和触摸用户界面。