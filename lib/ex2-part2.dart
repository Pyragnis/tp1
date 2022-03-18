import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.yellow,
      ),
      home: const MyHomePage(title: 'Flutter Demo date page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  DateTime _date = DateTime(2020, 11, 17 , DateTime.now().hour , DateTime.now().minute , DateTime.now().second);
  DateTime _date2 = DateTime(2020, 11, 17 , DateTime.now().hour , DateTime.now().minute , DateTime.now().second);
  String date_dif = "" ;
  void _calendar() async {
    final DateTime? Date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2001, 1),
      lastDate: DateTime(2022, 7),
      helpText: 'Select a date beautiful guy',

    );
    if (Date != null) {
      setState(() {
        _date = Date ;
        //_date.hour = DateTime.now().hour ;
        //_date.minute = DateTime.now().minute ;
        //_date.second = DateTime.now().second ;
      });
      //DateTime _birth = DateTime (DateTime.now().year - Date.year,DateTime.now().month - Date.month,DateTime.now().day - Date.day, DateTime.now().hour,DateTime.now().minute,DateTime.now().second );


    }
  }
  void _calendar2() async {
    final DateTime? Date = await showDatePicker(
      context: context,
      initialDate: _date2,
      firstDate: DateTime(2001, 1),
      lastDate: DateTime(2022, 7),
      helpText: 'Select a date beautiful guy',

    );
    if (Date != null) {
      setState(() {
        _date2 = Date;
        //_date.hour = DateTime.now().hour ;
        //_date.minute = DateTime.now().minute ;
        //_date.second = DateTime.now().second ;
      });
      //DateTime _birth = DateTime (DateTime.now().year - Date.year,DateTime.now().month - Date.month,DateTime.now().day - Date.day, DateTime.now().hour,DateTime.now().minute,DateTime.now().second );


    }
  }
   _diff(_date,_date2){
    DateTime _diffe = DateTime(_date.year - _date2.year,_date.month - _date2.month, _date.day - _date2.day , _date.hour - _date2.hour , _date.minute - _date2.minute, _date.second - _date2.second);
    setState(() {
      date_dif = _diffe.toString();
    });

  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _calendar,
              child: Text('calendar'),
            ),
            ElevatedButton(
              onPressed: _calendar2,
              child: Text('calendar2'),
            ),
            ElevatedButton(
              onPressed: _diff(_date,_date2),
              child: Text('calcule diff'),
            ),
            Text(

              'Difference entre les dates: $date_dif',
            ),
          ],
        ),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
