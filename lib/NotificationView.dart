import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  //当前页码
  int pageIndex = 1;

//总数据数
  int dataCount = titleList.length;

//一页有多少数据
  int currentPageCount = 4;
  List<Widget> currentPageWidget = [];

  //全部数据
  List<Msg> listMsg = [];

  //当前页的数据
  List<Msg> correctList = [];

  //总页数
  int get pageCount {
    return (dataCount / currentPageCount).ceil();
  }

  void pageUp() {
    if (pageIndex == 1) {
      return;
    }
    pageIndex--;
    update();
  }

  void pageDown() {
    if (pageIndex == pageCount) {
      return;
    }
    pageIndex++;
    update();
  }

  void pageFirst() {
    pageIndex = 1;
    update();
  }

  void pageLast() {
    pageIndex = pageCount;
    update();
  }

  void pageChange(int correctPage) {
    pageIndex = correctPage;
    update();
  }

  List<Msg> getMsgList() {
    correctList.clear();
    int startIndex = (pageIndex - 1) * currentPageCount;
    int endIndex = (pageIndex - 1) * currentPageCount + currentPageCount;
    int actualEndIndex = currentPageCount > (dataCount - startIndex) /*剩余的页数*/
        ? startIndex + (dataCount - startIndex)
        : endIndex;
    for (int i = startIndex; i < actualEndIndex; i++) {
      correctList.add(listMsg[i]);
    }
    return correctList;
  }
}

class NotificationWidget extends StatelessWidget {
  late List<Msg> list;
  int currentPageCount;
  late NotificationController messageController;

  NotificationWidget({super.key, required this.list, this.currentPageCount = 6}) {
    messageController = Get.put<NotificationController>(NotificationController());
  }

  void loadData() {
    messageController.dataCount = list.length;
    messageController.currentPageCount = currentPageCount;
    messageController.listMsg = list;
  }
  Widget TextButton(int flex,String text,Function()? onTap) {
    return Expanded(
        flex:flex,
        child: Container(
          padding: const EdgeInsets.only(left: 3,right: 3),
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(width: 0.5)
          ),
          child: GestureDetector(
            onTap: onTap,
            child: Center(
              child: Text(text),
            ),
          ),
        ));
  }
  @override
  Widget build(BuildContext context) {
    loadData();
    return GetBuilder<NotificationController>(
      builder: (controller) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 8,
                child: Container(
                  width: double.infinity,
                  color: Colors.blue,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ClientInfo', style: TextStyle(fontSize: 20),),
                      Text('ClientInfo', style: TextStyle(fontSize: 20)),
                      Text('ClientInfo', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                )),
              Container(
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 0.3)),
                width: double.infinity,
                child: Container(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: Text(
                        "bell".tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange
                        ),
                        textAlign: TextAlign.left,
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
                    child: LayoutBuilder(builder: (context, constraints) {
                      double _itemHeight = constraints.maxHeight / controller.currentPageCount;
                      return ListView.builder(
                          itemCount: controller.getMsgList().length, itemBuilder: (context, index) {
                        return MessageItemView(msg: controller.getMsgList()[index], heiget: _itemHeight);
                      });
                    })),
              ),

              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    TextButton(2,'首页',(){
                      controller.pageFirst();
                    }),
                    TextButton(2,'上一页',(){
                      controller.pageUp();
                    }),
                    TextButton(2,'${controller.pageIndex}',(){

                    }),
                    TextButton(2,'下一页',(){
                      controller.pageDown();
                    }),
                    TextButton(2,'尾页',(){
                      controller.pageLast();
                    }),
                  ],

                ),
              )
            ],
          ),
        );
      },
    );
  }
}
class MessageItemView extends StatelessWidget {
  Msg msg;
  double heiget;
  MessageItemView({super.key, required this.msg, required this.heiget});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 0.2)),
      padding: const EdgeInsets.all(3),
      width: double.maxFinite,
      height: heiget,
      child: Column(
        children: [
          Expanded(
              flex: 3,
              child: Container(
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      msg.title,
                      style: const TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold),
                    )),
              )),
          Expanded(
              flex: 5,
              child: Container(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(msg.content,style: const TextStyle(fontSize: 10,),),
                ),
              )),
          Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            msg.time.toString().substring(0, 19),
                            style: const TextStyle(fontSize: 8),
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





List<String> titleList = [
  '春节放假通知1',
  '春节放假通知2',
  '春节放假通知3',
  '春节放假通知4',
  '春节放假通知5',
  '春节放假通知6',
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
  DateTime.now(),
  DateTime.now(),
];

class Msg {
  String title;
  String content;
  DateTime time;

  Msg(this.title, this.content, this.time);
}
