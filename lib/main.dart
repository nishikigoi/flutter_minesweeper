import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minesweeper',
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
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Minesweeper'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<String>> gridState = [
  ['', '0', '0', '', '', '', '', 'B'],
  ['', '', '', 'F', '', '', '', ''],
  ['1', '2', '', '', '', '3', '', ''],
  ['', '', '', '4', '', '', '', '2'],
  ['', '', '0', '', '', '1', '', ''],
  ['', '', '', '', '', '', '', 'B'],
  ['', '', '', '', 'F', '', '', ''],
  ['1', '', '', '', '', '', '3', ''],
  ];

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
      body:
        _buildGameBody(),
    );
  }

  Widget _buildGameBody() {
    int gridStateLength = gridState.length;
    return Column(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2.0)
              ),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridStateLength,
                ),
                itemBuilder: _buildGridItems,
                itemCount: gridStateLength * gridStateLength,
              ),
            ),
          ),
        ]);
  }

  Widget _buildGridItems(BuildContext context, int index) {
    int gridStateLength = gridState.length;
    int x, y = 0;
    x = (index / gridStateLength).floor();
    y = (index % gridStateLength);
    return GestureDetector(
      onTap: () => _gridItemTapped(x, y),
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5)
          ),
          child: Center(
            child: _buildGridItem(x, y),
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(int x, int y) {
    switch (gridState[x][y]) {
      case '':
        return Container(
          color: Colors.grey,
        );
        break;
      case '0':
        return Text('0');
        break;
      case '1':
        return Text('1');
        break;
      case '2':
        return Text('2');
        break;
      case '3':
        return Text('3');
        break;
      case '4':
        return Text('4');
        break;
      case '5':
        return Text('5');
        break;
      case '6':
        return Text('6');
        break;
      case '7':
        return Text('7');
        break;
      case '8':
        return Text('8');
        break;
      case 'F':
        return Container(
          color: Colors.red,
        );
        break;
      case 'B':
        return Container(
          color: Colors.black,
        );
        break;
      default:
        return Text(gridState[x][y].toString());
    }
  }

  void _gridItemTapped(int x, int y) {
  }
}
