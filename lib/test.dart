import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'pagingDemo02.dart';

main() {
  runApp(MyApp3());
}

class MyApp3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MsgListState(),
        child: MaterialApp(
          title: 'test',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          ),
          home: MyHomePage(),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {

    List<Msg> listMsg = [];
    for(int i = 0; i < titleList.length; i++){
      listMsg.add(Msg(titleList[i], subTitleList[i], timeList[i]));
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('TEST'),
      ),
      drawer:  GFDrawer(
        child: Column(
          children: <Widget>[
            GFDrawerHeader(
              currentAccountPicture: GFAvatar(
                radius: 80.0,
                backgroundImage: AssetImage("image/test.jpg"),
              ),
              otherAccountsPictures: <Widget>[
                Image(
                  image: AssetImage("image/test.jpg"),
                  fit: BoxFit.cover,
                ),
                GFAvatar(
                  child: Text("ab"),
                )
              ],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('user name'),
                  Text('user@userid.com'),
                ],
              ),
            ),
            Expanded(
                child: MessageWidget(list: listMsg, currentPageCount: 3,),
            )
          ],
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Text('Open Drawer'),
        ),
      ),
    );
  }
}
