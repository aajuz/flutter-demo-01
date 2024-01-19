import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

main() {
  runApp(const Pager());
}

class Pager extends StatefulWidget {
  const Pager({Key? key}) : super(key: key);

  @override
  State<Pager> createState() => _PagerState();
}

class _PagerState extends State<Pager> {
  List _list = []; //存放页码的列表
  int _total = 10; //页面数量(总数据数/一页有多少数据)
  int _pageIndex = 1; //当前页面

  void managePage() {
    _list = [];
    if (_total <= 1) {
      return;
    }
    if (_total <= 5) {
      for (int i = 0; i < _total; i++) {
        _list.add(i + 1);
      }
    } else if (_pageIndex <= 3) {
      _list = [1, 2, 3, 4, "...", _total];
    } else if (_pageIndex >= 5) {
      _list = [
        1,
        "...",
        _pageIndex - 2,
        _pageIndex - 1,
        _pageIndex,
        _pageIndex + 1,
        _pageIndex + 2,
        "...",
        _total
      ];
    }
    _list.insert(0, "上一页");
    _list.add("下一页");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _list.mapIndexed((index, ele) {
          if (index == 0) {
            //第一个索引(上一页)
            return GestureDetector(
              onTap: () {
                //点击
                if (_pageIndex > 1) {
                  setState(() {
                    //通知框架重新构建ui
                    _pageIndex--;
                    // 改变页码在这里发送事件通知
                  });
                }
              },
              child: buildPagerItem(child: ele),
            );
          }
          if (index == _list.length - 1) {
            //最后一个索引(下一页)
            return GestureDetector(
              onTap: () {
                if (_pageIndex < _total) {
                  setState(() {
                    _pageIndex++;
                    // 改变页码在这里发送事件通知
                  });
                }
              },
              child: buildPagerItem(child: ele),
            );
          }
          return GestureDetector(
            onTap: () {
              if (ele != "...") {
                setState(() {
                  if (_pageIndex != ele) {
                    _pageIndex = ele;
                    // 改变页码在这里发送事件通知
                  }
                });
              }
            },
            child: buildPagerItem(
                child: Text("$ele",
                    // 当前页码对应的组件的样式
                    style: ele == _pageIndex ? TextStyle() : TextStyle())),
          );
        }).toList(),
      ),
    );
  }

  Widget buildPagerItem({required Widget child}) {
    return Container(
      width: 100,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(),
      margin: EdgeInsets.symmetric(),
      child: child,
    );
  }
}
