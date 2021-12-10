import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _counter = 0;

  Future<String> getLocalPath() async {
    var dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> getLocalFile() async {
    String path = await getLocalPath();
    var dir = Directory(path);

    print(dir.toString());
    print(await dir.list().length);

    await for (var entity in dir.list(recursive: true, followLinks: false)) {
      print('* ' + entity.path);
    }

    print('$path/counter.txt');
    return File('$path/counter.txt');
  }

  Future<File> writeCounter(int c) async {
    File file = await getLocalFile();
    return file.writeAsString('$c');
  }

  Future<int> readCounter() async {
    try {
      final file = await getLocalFile();
      String content = await file.readAsString();
      return int.parse(content);
    } catch (e) {
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    readCounter().then((data) {
      setState(() {
        _counter = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Read/Write From File'),
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
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          setState(() {
            _counter++;
          });
          writeCounter(_counter);
        },
      ),
    );
  }
}
