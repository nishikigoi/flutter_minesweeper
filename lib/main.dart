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

class Cell {
  bool isOpened;
  bool hasBomb;
  int numNeighborBombs;
  Cell() {
    this.isOpened = false;
    this.hasBomb = false;
    numNeighborBombs = 0;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  static final numRows = 9;
  static final numCols = 9;
  List<List<Cell>> gridState =
      List<List<Cell>>.generate(numRows, (i) =>
      List<Cell>.generate(numCols, (j) {
        return Cell();
      }));

  @override
  void initState() {
    super.initState();
    initBombPosition();
    countNeighborBombsForAll();
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
    var cellState = gridState[x][y];
    if (!cellState.isOpened) {
      return Container(
        color: Colors.grey,
      );
    }
    if (cellState.hasBomb) {
      return Container(
        color: Colors.black,
      );
    }
    return Text(cellState.numNeighborBombs.toString());
  }

  void _gridItemTapped(int x, int y) {
    setState(() {
      bool updated = false;
      updated = openCell(x, y);
      scanOpenedCells(updated);
    });
  }

  bool openCell(int x, int y) {
    if (!gridState[x][y].isOpened) {
      gridState[x][y].isOpened = true;
      return true;
    }
    return false;
  }

  void scanOpenedCells(bool updated) {
    while (updated) {
      updated = false;
      for (int x = 0; x < numRows; x++) {
        for (int y = 0; y < numCols; y++) {
          if (gridState[x][y].isOpened &&
              gridState[x][y].numNeighborBombs == 0) {
            // upper left
            if (x > 0 && y > 0) {
              updated |= openCell(x - 1, y - 1);
            }
            // upper middle
            if (x > 0) {
              updated |= openCell(x - 1, y);
            }
            // upper right
            if (x > 0 && y < numCols - 1) {
              updated |= openCell(x - 1, y + 1);
            }
            // middle left
            if (y > 0) {
              updated |= openCell(x, y - 1);
            }
            // middle right
            if (y < numCols - 1) {
              updated |= openCell(x, y + 1);
            }
            // lower left
            if (x < numRows - 1 && y > 0) {
              updated |= openCell(x + 1, y - 1);
            }
            // lower middle
            if (x < numRows - 1) {
              updated |= openCell(x + 1, y);
            }
            // lower right
            if (x < numRows - 1 && y < numCols - 1) {
              updated |= openCell(x + 1, y + 1);
            }
          }
        }
      }
    }
  }

  void initBombPosition() {
    gridState[1][2].hasBomb = true;
    gridState[2][4].hasBomb = true;
    gridState[4][7].hasBomb = true;
    gridState[6][2].hasBomb = true;
    gridState[8][2].hasBomb = true;
  }

  void countNeighborBombsForAll() {
    gridState.asMap().forEach((x, cells) {
      cells.asMap().forEach((y, cell) {
        cell.numNeighborBombs = countNeighborBombs(x, y);
      });
    });
  }

  int countNeighborBombs(int x, int y) {
    int num = 0;
    // upper left
    if (x > 0 && y > 0 && gridState[x - 1][y - 1].hasBomb) {
      num++;
    }
    // upper middle
    if (x > 0 && gridState[x - 1][y].hasBomb) {
      num++;
    }
    // upper right
    if (x > 0 && y < numCols - 1 && gridState[x - 1][y + 1].hasBomb) {
      num++;
    }
    // middle left
    if (y > 0 && gridState[x][y - 1].hasBomb) {
      num++;
    }
    // middle right
    if (y < numCols - 1 && gridState[x][y + 1].hasBomb) {
      num++;
    }
    // lower left
    if (x < numRows - 1 && y > 0 && gridState[x + 1][y - 1].hasBomb) {
      num++;
    }
    // lower middle
    if (x < numRows - 1 && gridState[x + 1][y].hasBomb) {
      num++;
    }
    // lower right
    if (x < numRows - 1 && y < numCols - 1 && gridState[x + 1][y + 1].hasBomb) {
      num++;
    }

    return num;
  }
}
