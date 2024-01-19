import 'dart:core';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

main() {
  runApp(MyApp2());
}

class MyApp2 extends StatelessWidget {
  const MyApp2({super.key});

  @override
  Widget build(BuildContext context) {
    List<Msg> listMsg = [];
    for (int i = 0; i < titleList.length; i++) {
      listMsg.add(Msg(titleList[i], subTitleList[i], timeList[i]));
    }

    return ChangeNotifierProvider(
      create: (context) => MsgListState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: SizedBox(
            width: 400,
            height: 600,
            child: MessageWidget(
              list: listMsg,
              currentPageCount: 3,
            )),
      ),
    );
  }
}

class MsgListState extends ChangeNotifier {
//当前页码
  int pageIndex = 1;

//总数据数
  int _dataCount = titleList.length;

//一页有多少数据
  int _correntPageCount = 4;
  List<Widget> currentPageWidget = [];

  //全部数据
  List<Msg> listMsg = [];

  //当前页的数据
  List<Msg> correctList = [];

//总页数
  int get pageCount {
    return (_dataCount / _correntPageCount).ceil();
  }

  void pageUp() {
    if (pageIndex == 1) {
      return;
    }
    pageIndex--;
    notifyListeners();
  }

  void pageDown() {
    if (pageIndex == pageCount) {
      return;
    }
    pageIndex++;
    notifyListeners();
  }

  void pageFirst() {
    pageIndex = 1;
    notifyListeners();
  }

  void pageLast() {
    pageIndex = pageCount;
    notifyListeners();
  }

  void pageChange(int correctPage) {
    pageIndex = correctPage;
    notifyListeners();
  }

  List<Msg> getMsgList() {
    correctList.clear();
    int startIndex = (pageIndex - 1) * _correntPageCount;
    int endIndex = (pageIndex - 1) * _correntPageCount + _correntPageCount;
    int actualEndIndex = _correntPageCount > (_dataCount - startIndex) /*剩余的页数*/
        ? startIndex + (_dataCount - startIndex)
        : endIndex;
    for (int i = startIndex; i < actualEndIndex; i++) {
      correctList.add(listMsg[i]);
    }
    return correctList;
  }
}

class MessageWidget extends StatelessWidget {
  late List<Msg> list;
  late int currentPageCount;

  MessageWidget({Key? key, required this.list, required this.currentPageCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var msgState = context.watch<MsgListState>();
    msgState._dataCount = list.length;
    msgState._correntPageCount = currentPageCount;
    msgState.listMsg = list;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 0.3)),
              width: double.infinity,
              child: Container(
                margin: EdgeInsets.only(left: 20, bottom: 10),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    child: Text(
                      "消息列表",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
            ),
          ),
          //一连串消息
          Expanded(
            flex: 20,
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 0.2)),
                child: MessageList()),
          ),

          //分页的按钮
          Expanded(
            flex: 2,
            child: Pager(),
          )
        ],
      ),
    );
  }
}

class MessageList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MessageListState();
  }
}

class _MessageListState extends State<MessageList> {
  @override
  Widget build(BuildContext context) {
    return listViewSeparated(context);
  }

  Widget listViewSeparated(BuildContext context) {
    var msgState = context.watch<MsgListState>();
    var _correctList = msgState.getMsgList();
    int startIndex = (msgState.pageIndex - 1) * msgState._correntPageCount;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double _itemHeight = constraints.maxHeight / msgState._correntPageCount;
        return ListView.separated(
          padding: const EdgeInsets.all(0),
          itemBuilder: (context, i) {
            return buildListData(_correctList[i], _itemHeight);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              height: 0,
            );
          },
          itemCount:
              msgState._correntPageCount > (msgState._dataCount - startIndex)
                  ? msgState._dataCount - startIndex
                  : msgState._correntPageCount,
        );
      },
    );
  }

  Widget buildListData(Msg msg, double _itemHeight) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black, width: 0.2)),
      width: double.maxFinite,
      height: _itemHeight,
      child: Column(
        children: [
          Expanded(
              flex: 3,
              child: Container(
                margin: EdgeInsets.only(left: 20),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      msg.title,
                      style: TextStyle(fontSize: 15.0),
                    )),
              )),
          Expanded(
              flex: 5,
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(msg.content),
                ),
              )),
          Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                      flex: 4,
                      child: SizedBox(
                        width: 1,
                      )),
                  Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.only(right: 5, bottom: 5),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            msg.time.toString().substring(0,19),
                            style: TextStyle(fontSize: 12),
                          )),
                      ),
                      )
                ],
              ))
        ],
      ),
    );
  }
}

class Message extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [],
    );
  }
}

class Pager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PagerState();
}

class _PagerState extends State<Pager> {
  //存放页数的列表
  List _pageList = [];

  @override
  Widget build(BuildContext context) {
    var msgState = context.watch<MsgListState>();
    _pageList = buildPagerItem(msgState.pageCount, msgState.pageIndex);

    return Scaffold(body: Scrollbar(child: pager()));
  }

  Widget pager() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, i) {
        return buildPagerItemWidget(_pageList[i].toString(), context);
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
      itemCount: _pageList.length,
    );
  }

  Widget buildPagerItemWidget(String pageItem, BuildContext context) {
    var msgState = context.watch<MsgListState>();
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black, width: 0.1)),
      child: TextButton(
        onPressed: () {
          try {
            if (pageItem == "上一页") {
              msgState.pageUp();
            } else if (pageItem == "下一页") {
              msgState.pageDown();
            } else if (pageItem == "首页") {
              msgState.pageFirst();
            } else if (pageItem == "尾页") {
              msgState.pageLast();
            } else {
              msgState.pageChange(int.parse(pageItem));
            }
          } catch (e) {
            print(e);
          }
        },
        child: Text(pageItem),
      ),
    );
  }

  List buildPagerItem(int pageCount, int pageIndex) {
    List _pageList = [];
    // if (pageCount < 1) {
    //   _pageList = [];
    // } else if (pageCount == 1) {
    //   _pageList = [1];
    // } else if (pageCount <= 5) {
    //   for (int i = 1; i <= pageCount; i++) {
    //     _pageList.add(i);
    //   }
    // } else if (pageIndex <= (pageCount / 2) && pageCount <= 12) {
    //   for (int i = 1; i <= pageIndex; i++) {
    //     _pageList.add(i);
    //   }
    //   _pageList.add(pageIndex + 1);
    //   _pageList.add(pageIndex + 2);
    //   _pageList.add("...");
    //   _pageList.add(pageCount);
    // } else if (pageIndex > (pageCount / 2) && pageCount <= 12) {
    //   _pageList.add(1);
    //   _pageList.add("...");
    //   _pageList.add(pageIndex - 2);
    //   _pageList.add(pageIndex - 1);
    //   for (int i = pageIndex; i <= pageCount; i++) {
    //     _pageList.add(i);
    //   }
    // } else if (pageIndex <= 3 && pageCount > 12) {
    //   for (int i = 1; i <= pageIndex; i++) {
    //     _pageList.add(i);
    //   }
    //   _pageList.add(pageIndex + 1);
    //   _pageList.add(pageIndex + 2);
    //   _pageList.add("...");
    //   _pageList.add(pageCount);
    // } else if (pageIndex >= (pageCount - 3) && pageCount > 12) {
    //   _pageList.add(1);
    //   _pageList.add("...");
    //   _pageList.add(pageIndex - 2);
    //   _pageList.add(pageIndex - 1);
    //   for (int i = pageIndex; i <= pageCount; i++) {
    //     _pageList.add(i);
    //   }
    // } else if (pageCount > 12) {
    //   _pageList = [
    //     1,
    //     "...",
    //     pageIndex - 2,
    //     pageIndex - 1,
    //     pageIndex,
    //     pageIndex + 1,
    //     pageIndex + 2,
    //     "...",
    //     pageCount
    //   ];
    // }

    _pageList.add("首页");
    _pageList.add("上一页");
    _pageList.add(pageIndex);
    _pageList.add("下一页");
    _pageList.add("尾页");

    return _pageList;
  }
}

List<String> titleList = [
  '春节放假通知1',
  '春节放假通知2',
  '春节放假通知3',
  '春节放假通知4',
  '春节放假通知5',
  '春节放假通知6',
];

List<String> subTitleList = <String>[
  '放假通知放假通知放假通知放假通知放假通知1',
  '放假通知放假通知放假通知放假通知放假通知2',
  '放假通知放假通知放假通知放假通知放假通知3',
  '放假通知放假通知放假通知放假通知放假通知4',
  '放假通知放假通知放假通知放假通知放假通知5',
  '放假通知放假通知放假通知放假通知放假通知6',
];

List<DateTime> timeList = <DateTime>[
  DateTime.now(),
  DateTime.now(),
  DateTime.now(),
  DateTime.now(),
  DateTime.now(),
  DateTime.now(),
];

class Msg {
  String title;
  String content;
  DateTime time;

  Msg(this.title, this.content, this.time);
}
