
import QtQuick 2.5
import QtTest 1.1

Showcase {
    id: root

// 表示单元测试用例
    TestCase {
        id: testCase
        name: 'showcase'
        when: windowShown

        property int shots: 0;


        function test_shoot() {
            var shoot = false;  // 将项目抓取到内存映像中。
            root.grabToImage(function(result) {
                result.saveToFile("../../assets/1.png");
                print("111111111111")
                shots++;
            });

            // function mouseClick(item, x, y, button, modifiers, delay)
            mouseClick(root);
             wait(1000);
            mouseClick(root);
             wait(1000);
            mouseClick(root);
             wait(1000);
            mouseClick(root);
            wait(1000);
            root.grabToImage(function(result) {
                result.saveToFile("../../assets/showcase2.png");
                shots++;
            });
            wait(100);
            root.grabToImage(function(result) {
                result.saveToFile("../../assets/showcase3.png");
                shots++;
            });
            wait(100);
            root.grabToImage(function(result) {
                result.saveToFile("../../assets/showcase4.png");
                shots++;
            });

            /*
如果obj上指定的属性与预期的不同，则当前测试用例失败，并显示可选消息。将多次重试测试，直到达到超时（毫秒）。
此函数用于测试属性基于异步事件更改值的应用程序。使用compare（）测试同步属性更改。
*/
            tryCompare(testCase, "shots", 5);


        }
    }

    // 下面的代码片段演示如何获取项并将结果存储到文件中。
}

/*
    function tryCompare(obj, prop, value, timeout, msg) {
        if (arguments.length == 1 || (typeof(prop) != "string" && typeof(prop) != "number")) {
            qtest_results.fail("A property name as string or index is required for tryCompare",
                        util.callerFile(), util.callerLine())
            throw new Error("QtQuickTest::fail")
        }
        if (arguments.length == 2) {
            qtest_results.fail("A value is required for tryCompare",
                        util.callerFile(), util.callerLine())
            throw new Error("QtQuickTest::fail")
        }
        if (timeout !== undefined && typeof(timeout) != "number") {
            qtest_results.fail("timeout should be a number",
                        util.callerFile(), util.callerLine())
            throw new Error("QtQuickTest::fail")
        }
        if (!timeout)
            timeout = 5000
        if (msg === undefined)
            msg = "property " + prop
        if (!qtest_compareInternal(obj[prop], value))
            wait(0)
        var i = 0
        while (i < timeout && !qtest_compareInternal(obj[prop], value)) {
            wait(50)
            i += 50
        }
        var actual = obj[prop]
        var act = qtest_results.stringify(actual)
        var exp = qtest_results.stringify(value)
        var success = qtest_compareInternal(actual, value)
        if (!qtest_results.compare(success, msg, act, exp, util.callerFile(), util.callerLine()))
            throw new Error("QtQuickTest::fail")
    }

*/
