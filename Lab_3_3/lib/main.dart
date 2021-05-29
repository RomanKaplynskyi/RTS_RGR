import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

List<double> fitnessFunction(List<int> deltas) {
  List<double> reverseDeltas = deltas.map((delta) => 1 / delta).toList();
  double reversedDeltaSum =
      reverseDeltas.reduce((value, element) => value += element);
  List<double> fitnesses =
      reverseDeltas.map((deltas) => (deltas / reversedDeltaSum) * 100).toList();
  return fitnesses;
}

List<List<int>> diophant(
    {ax = 2, bx = 2, cx = 3, dx = 4, y = 45, mutantCoef = 2}) {
  int maxRange = (y / 2).round();
  List<List<int>> initVals = [];
  for (int i = 0; i < 5; i++) {
    initVals.add([
      Random().nextInt(maxRange) + 1,
      Random().nextInt(maxRange) + 1,
      Random().nextInt(maxRange) + 1,
      Random().nextInt(maxRange) + 1
    ]);
  }
  var successRes = 0;
  var iterations = 1;
  while (successRes != 1) {
    List<int> deltas = initVals
        .map<int>((gen) =>
            (y - (ax * gen[0] + bx * gen[1] + cx * gen[2] + dx * gen[3])).abs())
        .toList();
    var resultIndex = deltas.indexOf(0);
    if (resultIndex > -1) {
      successRes = 1;
      return [
        initVals[resultIndex],
        [iterations]
      ];
    }
    List<double> fitnesses = fitnessFunction(deltas);

    var bestParentArr = [];
    for (int i = 0; i < fitnesses.length; i++) {
      for (int j = 0; j < fitnesses[i].round(); j++) {
        bestParentArr.add(i);
      }
    }
    List<List<int>> parents = [];
    List<List<int>> newInitVals = [];

    for (int i = 0; i < 5; i++) {
      var firstParent;
      var secondParent;
      do {
        firstParent = bestParentArr[Random().nextInt(bestParentArr.length)];
        secondParent = bestParentArr[Random().nextInt(bestParentArr.length)];
      } while (firstParent == secondParent ||
          parents
                  .where((parent) =>
                      parent[0] == firstParent && parent[1] == secondParent)
                  .length >
              0);
      parents.add([firstParent, secondParent]);

      var devider = Random().nextInt(3);
      List<int> child = [];
      var mutant = Random().nextInt(mutantCoef);
      switch (devider) {
        case 0:
          if (mutant == 0) {
            child.addAll(initVals[firstParent].getRange(0, 1));
            child.addAll(initVals[secondParent].getRange(1, 4));
          } else {
            child.addAll(initVals[secondParent].getRange(1, 4));
            child.addAll(initVals[firstParent].getRange(0, 1));
          }
          break;
        case 1:
          if (mutant == 0) {
            child.addAll(initVals[firstParent].getRange(0, 2));
            child.addAll(initVals[secondParent].getRange(2, 4));
          } else {
            child.addAll(initVals[secondParent].getRange(2, 4));
            child.addAll(initVals[firstParent].getRange(0, 2));
          }
          break;
        case 2:
          if (mutant == 0) {
            child.addAll(initVals[firstParent].getRange(0, 3));
            child.addAll(initVals[secondParent].getRange(3, 4));
          } else {
            child.addAll(initVals[secondParent].getRange(3, 4));
            child.addAll(initVals[firstParent].getRange(0, 3));
          }
          break;
        default:
      }
      newInitVals.add(child);
    }
    List<int> newInitValsDelta = newInitVals
        .map<int>((gen) =>
            (y - (ax * gen[0] + bx * gen[1] + cx * gen[2] + dx * gen[3])).abs())
        .toList();
    double avgDelta =
        deltas.reduce((value, element) => value + element) / deltas.length;
    double avgNewValDelta =
        newInitValsDelta.reduce((value, element) => value + element) /
            newInitValsDelta.length;
    if (avgDelta > avgNewValDelta) {
      for (int i = 0; i < newInitVals.length; i++) {
        for (int j = 0; j < 4; j++) {
          var randomInt = Random().nextInt(10);
          if (randomInt > 4) {
            newInitVals[i][j] = Random().nextInt((y / 2).round());
          }
        }
      }
    }
    initVals = newInitVals.getRange(0, 5).toList();
    iterations++;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _aController = TextEditingController();
    TextEditingController _bController = TextEditingController();
    TextEditingController _cController = TextEditingController();
    TextEditingController _dController = TextEditingController();
    TextEditingController _resController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('A'),
            SizedBox(
              width: 20,
              child: TextField(
                controller: _aController,
              ),
            ),
            Text('+ B'),
            SizedBox(
              width: 20,
              child: TextField(
                controller: _bController,
              ),
            ),
            Text('+ C'),
            SizedBox(
              width: 20,
              child: TextField(
                controller: _cController,
              ),
            ),
            Text('+ D'),
            SizedBox(
              width: 20,
              child: TextField(
                controller: _dController,
              ),
            ),
            Text('='),
            SizedBox(
              width: 20,
              child: TextField(
                controller: _resController,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var x1 = _aController.text == "" ? 1 : int.parse(_aController.text);
          var x2 = _bController.text == "" ? 1 : int.parse(_bController.text);
          var x3 = _cController.text == "" ? 1 : int.parse(_cController.text);
          var x4 = _dController.text == "" ? 1 : int.parse(_dController.text);
          var y =
              _resController.text == "" ? 1 : int.parse(_resController.text);
          var dd1 =
              diophant(ax: x1, bx: x2, cx: x3, dx: x4, y: y, mutantCoef: 1);
          var dd2 =
              diophant(ax: x1, bx: x2, cx: x3, dx: x4, y: y, mutantCoef: 2);
          var dd3 =
              diophant(ax: x1, bx: x2, cx: x3, dx: x4, y: y, mutantCoef: 3);
          var dd4 =
              diophant(ax: x1, bx: x2, cx: x3, dx: x4, y: y, mutantCoef: 4);
          var dd5 =
              diophant(ax: x1, bx: x2, cx: x3, dx: x4, y: y, mutantCoef: 5);
          var dd6 =
              diophant(ax: x1, bx: x2, cx: x3, dx: x4, y: y, mutantCoef: 10);
          print('100%\n');
          print("IterationsCount = ${dd1[1][0]}\n");
          print('50%\n');
          print("IterationsCount = ${dd2[1][0]}\n");
          print('30%\n');
          print("IterationsCount = ${dd3[1][0]}\n");
          print('25%\n');
          print("IterationsCount = ${dd4[1][0]}\n");
          print('20%\n');
          print("IterationsCount = ${dd5[1][0]}\n");
          print('10%\n');
          print("IterationsCount = ${dd6[1][0]}\n");
          var dialog = AlertDialog(
            title: Text("Result"),
            content: new Text("Look in terminal for result!"),
            actions: <Widget>[
              new TextButton(
                child: new Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );

          return showDialog(
              context: context,
              builder: (context) {
                return dialog;
              });
        },
        tooltip: 'Diophant',
        child: Icon(Icons.equalizer),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
