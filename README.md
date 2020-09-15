Dependencies  //依赖
============

* git (http://git-scm.com/) - scm tool
* sphinx (http://sphinx.pocoo.org/) - book engine
* sphinx-bootstrap-theme (https://github.com/ryan-roemer/sphinx-bootstrap-theme) - bootstrap HTML theme
* graphviz (http://www.graphviz.org/) - diagram tool
* shorty (https://github.com/qmlbook/shorty) - QML screenshot tool

Setup
=====

理想情况下，您使用python虚拟环境并在其内部安装依赖项
    cd qmlbook
    virtualenv -p python3 venv
    source venv/bin/activate

这将为您提供一个干净的python3设置。现在您需要安装依赖项：    
    source venv/bin/activate
    pip install -r requirements.txt

这将安装需求文档中列出的所有包。

或者重建文档，我们还使用一个叫做shorty的屏幕截图工具。它从正在运行的Qt应用程序获取屏幕截图。要构建它，请克隆repo并用一个像样的Qt版本构建工具。

    git clone git@github.com:qmlbook/shorty.git
    cd shorty
    mkdir build && cd build
    qmake .. && make

确定shorty在你的搜索路径上，什么时候 
