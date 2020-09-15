本章概述QML，qt5中使用的声明性用户界面语言。我们将讨论QML语法，它是一个元素树，然后概述最重要的基本元素。稍后，我们将简要介绍如何创建我们自己的元素，称为组件，以及如何使用属性操作转换元素。最后，我们将研究如何在布局中将元素排列在一起，最后看一看用户可以提供输入的元素。


QML是一种声明性语言，用于描述应用程序的用户界面。它将用户界面分解成更小的元素，这些元素可以组合成组件。QML描述了这些用户界面元素的外观和行为。这个用户界面描述可以用JavaScript代码来丰富，以提供简单但也更复杂的逻辑。从这个角度来看，它遵循htmljavascript模式，但QML是从头开始设计的，用于描述用户界面，而不是文本文档。


警告：元素id只能用于引用文档中的元素（例如当前文件）。QML提供了一种称为动态作用域的机制，在这种机制中，稍后加载的文档覆盖先前加载的文档中的元素id。这使得可以引用以前加载的文档中的元素id，如果它们还没有被覆盖。就像创建全局变量一样。不幸的是，在实践中，这常常会导致非常糟糕的代码，程序依赖于执行的顺序。不幸的是，这个不能关闭。请小心使用，或者最好不要使用这个机制。最好使用文档根元素上的属性将要提供的元素导出到外部世界。

“Item”元素通常用作其他元素的容器，类似于HTML中的*div*元素。


有效的颜色值是SVG颜色名称中的颜色（请参见http://www.w3.org/TR/css3 color/#svg-颜色）。您可以用不同的方式在QML中提供颜色，但最常见的方式是RGB字符串（'#FF4444'）或作为颜色名称（例如'white'）。


可以使用“horizontalAlignment”和“verticalAlignment”属性将文本对齐到每一侧和中心。要进一步增强文本呈现，可以使用“style”和“styleColor”属性，这允许您以大纲、凸起和凹陷模式呈现文本。对于较长的文本，通常需要定义一个*中断*位置，例如*非常。。。长文本*，可以使用“elide”属性来实现。“elide”属性允许您将elide位置设置为文本的左、右或中间。如果您不希望出现elide模式的“…”但仍希望看到全文，您还可以使用“wrapMode”属性包装文本（仅当显式设置宽度时有效）：：



    Text {
        width: 40; height: 120
        text: 'A very long text'
        // '...' shall appear in the middle
        elide: Text.ElideMiddle
        // red sunken text styling
        style: Text.Sunken
        styleColor: '#FF4444'
        // align text to the top
        verticalAlignment: Text.AlignTop
        // only sensible when no elide mode
        // wrapMode: Text.WordWrap
    }

请注意，初始宽度（高度）取决于文本字符串和字体集。没有宽度设置和文本的“Text”元素将不可见，因为初始宽度为0。

除了提供图像URL的明显的“source”属性外，它还包含一个控制大小调整行为的“fillMode”。

这是Qt-Quick的一个重要方面，输入处理与视觉呈现分离。这样，您就可以向用户显示界面元素，但交互区域可以更大。

对于更复杂的交互，`Qt快速输入处理程序<https://doc-snapshots.qt.io/qt5-dev/qtquickhandlers-index.html>
    // minimal API for a button
    Button {
        text: "Click Me"
        onClicked: { /* do something */ }
    }

如果您愿意，您甚至可以进一步使用item作为根元素。这可以防止用户更改我们设计的按钮的颜色，并为我们提供对导出API的更多控制。目标应该是导出一个最小的API。实际上，这意味着我们需要将根“Rectangle”替换为“Item”，并使矩形成为根项中的嵌套元素。

    .. code-block:: js

        Item {
            id: root
            width: 116; height: 26

            property alias text: label.text
            signal clicked

            Rectangle {
                anchors.fill parent
                color: "lightsteelblue"
                border.color: "slategrey"
            }
            ...
        }

在展示这个例子之前，我想介绍一个小助手：``ClickableImage``元素。“ClickableImage”只是一个带有鼠标区域的图像。这就引出了一条有用的经验法则——如果你已经复制了一段代码三次，那么就把它提取到一个组件中。

请记住：*文件中元素的顺序很重要*。
在这个转发器示例中，我们使用了一些新的魔法。我们定义自己的颜色属性，将其用作颜色数组。中继器创建一系列矩形（16，由模型定义）。对于每个循环，他创建由中继器的子对象定义的矩形。在矩形中，我们使用JS数学函数选择颜色``数学地板(数学随机（）*3）``。这给了我们一个0到2范围内的随机数，我们用它来从颜色数组中选择颜色。如前所述，JavaScript是Qt-Quick的核心部分，因此我们可以使用标准库。


在自己的模型视图一章中介绍了更高级的处理大型模型和带有动态代理的动态视图。当需要呈现少量静态数据时，最好使用中继器。

 注意：我们的方块已经被增强以支持拖动。试试这个例子，拖动一些方块。您将看到（1）无法被拖动，因为它被锚定在所有边上，请确保您可以拖动（1）的父对象，因为它根本没有被锚定。（2） 可以垂直拖动，因为只有左侧被锚定。类似情况适用于（3）。（4） 只能垂直拖动，因为两个方块都是水平居中的。（5） 以父对象为中心，因此不能拖动，类似于（7）。拖动一个元素意味着改变它们的“x，y”位置。由于锚定比“x，y”等几何变化更强，拖动受锚定线的限制。我们将在稍后讨论动画时看到这种效果。


输入元素：
TextInput, TextEdit, FocusScope, focus, Keys, KeyNavigation

我们用新的“TLineEditV1”组件重写了“KeyNavigation”示例。

    Rectangle {
        ...
        TLineEditV1 {
            id: input1
            ...
        }
        TLineEditV1 {
            id: input2
            ...
        }
    }

尝试按tab键进行导航。您会发现焦点没有变为“input2”。仅仅使用“focus:true”是不够的。问题是在输入框的第1个元素上转移了焦点。为了防止这种情况，QML提供了“FocusScope”。


焦点作用域声明，如果焦点作用域接收焦点，最后一个带有“focus:true”的子元素将接收焦点。所以它将焦点转发到最后一个请求焦点的子元素。我们将使用focus作用域作为根元素创建名为TLineEditV2的TLineEdit组件的第二个版本。
.. code-block:: js

    Rectangle {
        ...
        TLineEditV2 {
            id: input1
            ...
        }
        TLineEditV2 {
            id: input2
            ...
        }
    }

QML和Javascript是解释语言。这意味着它们在被执行之前不必被编译器处理。相反，它们是在执行引擎中运行的。然而，由于口译是一项耗资巨大的工作，因此人们采用各种技术来提高口译水平。
QML引擎使用即时（JIT）编译来提高性能。它还缓存中间输出，以避免重新编译。作为开发人员，这对您来说是无缝的。唯一的线索是可以在源文件旁边找到以“qmlc”和“jsc”结尾的文件。
如果您想避免初始解析导致的初始启动代价，您还可以预编译QML和Javascript。这要求您将代码放入Qt资源文件中，并在“提前编译QML”中详细描述<http://doc.qt.io/qt-5/qtquick deployment.html编译-Qt文档中的ql-ahead-time>章节。