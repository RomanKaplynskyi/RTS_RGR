import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _State createState() => _State();
}

class ItemByDeadline {
  const ItemByDeadline(this.time);
  final double time;
}

double dp(double val, int places) {
  double mod = pow(10.0, places);
  var result = ((val * mod).round().toDouble() / mod);
  return result;
}

bool checkFit(List<List<int>> points, double W1, double W2, int P) {
  var border = (points.length / 2).round();

  var beforeBorderCheck = points.sublist(0, border).firstWhere(
      (point) => (W1 * point[0] + W2 * point[1]) <= P,
      orElse: () => []);
  var afterBorderCheck = points.sublist(border).firstWhere(
      (point) => (W1 * point[0] + W2 * point[1]) > P,
      orElse: () => []);
  return beforeBorderCheck.length == 0 && afterBorderCheck.length == 0;
}

count(
    {double deadlineTime = 0.5,
    int itterationCount = -1,
    double learningSpeed = 0.1}) {
  var points = [
    [0, 6],
    [1, 5],
    [3, 3],
    [2, 4]
  ];

  var P = 4;
  var W1 = 0.0;
  var W2 = 0.0;
  var Delta = 0;
  var iterations = 1;
  var timeDeadline = new DateTime.now();

  while (itterationCount != -1
      ? (iterations < itterationCount)
      : (new DateTime.now().difference(timeDeadline).inMilliseconds.toDouble() <
          deadlineTime * 1000)) {
    for (int i = 0; i < points.length; i++) {
      var y = W1 * points[i][0] + W2 * points[i][1];
      Delta = (P - y).round();
      W1 += Delta * points[i][0] * learningSpeed;
      W2 += Delta * points[i][1] * learningSpeed;
      if (checkFit(points, W1, W2, P) && itterationCount != -1) {
        print(iterations);
        return [
          W1,
          W2,
          new DateTime.now().difference(timeDeadline),
          iterations
        ];
      }
    }
    iterations++;
  }
  return [
    W1,
    W2,
    new DateTime.now().difference(timeDeadline).inMilliseconds,
    iterations
  ];
}

List<ItemByDeadline> timeValues = <ItemByDeadline>[
  const ItemByDeadline(0.5),
  const ItemByDeadline(1.0),
  const ItemByDeadline(2.0),
  const ItemByDeadline(5.0),
];

class ItemByItteration {
  const ItemByItteration(this.iterations);
  final int iterations;
}

List<ItemByItteration> itterationValues = <ItemByItteration>[
  const ItemByItteration(100),
  const ItemByItteration(200),
  const ItemByItteration(500),
  const ItemByItteration(1000),
];

class ItemLearningSpeed {
  const ItemLearningSpeed(this.speed);
  final double speed;
}

List<ItemLearningSpeed> learningSpeed = <ItemLearningSpeed>[
  const ItemLearningSpeed(0.001),
  const ItemLearningSpeed(0.01),
  const ItemLearningSpeed(0.05),
  const ItemLearningSpeed(0.1),
  const ItemLearningSpeed(0.2),
  const ItemLearningSpeed(0.3),
];

enum SingingCharacter { isByDeadline, isByItteration }
bool deadline = true;

class _State extends State<MyApp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  SingingCharacter _character = SingingCharacter.isByDeadline;
  ItemByDeadline selectedDeadlineType;
  ItemByItteration selectedItterationType;
  ItemLearningSpeed selectedLearningSpeed;

  @override
  Widget build(BuildContext context) {
    var learningSpeedDropDown = DropdownButton<ItemLearningSpeed>(
      hint: Text("Select deadline"),
      value: selectedLearningSpeed,
      onChanged: (ItemLearningSpeed Value) {
        setState(() {
          selectedLearningSpeed = Value;
        });
      },
      items: learningSpeed.map((ItemLearningSpeed user) {
        return DropdownMenuItem<ItemLearningSpeed>(
          value: user,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Text(
                user.speed.toString(),
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        );
      }).toList(),
    );
    var timeDeadLineDropDown = DropdownButton<ItemByDeadline>(
      hint: Text("Select deadline"),
      value: selectedDeadlineType,
      onChanged: (ItemByDeadline Value) {
        setState(() {
          selectedDeadlineType = Value;
        });
      },
      items: timeValues.map((ItemByDeadline user) {
        return DropdownMenuItem<ItemByDeadline>(
          value: user,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Text(
                user.time.toString(),
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        );
      }).toList(),
    );
    var iterationListDropDown = DropdownButton<ItemByItteration>(
      hint: Text("Select itteration count"),
      value: selectedItterationType,
      onChanged: (ItemByItteration Value) {
        setState(() {
          selectedItterationType = Value;
        });
      },
      items: itterationValues.map((ItemByItteration user) {
        return DropdownMenuItem<ItemByItteration>(
          value: user,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Text(
                user.iterations.toString(),
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        );
      }).toList(),
    );
    var deadLineRadioButton = ListTile(
      title: const Text('By deadline'),
      leading: Radio<SingingCharacter>(
        value: SingingCharacter.isByDeadline,
        groupValue: _character,
        onChanged: (SingingCharacter value) {
          setState(() {
            _character = value;
          });
        },
      ),
    );
    var iterationRadioButton = ListTile(
      title: const Text('By itteration'),
      leading: Radio<SingingCharacter>(
        value: SingingCharacter.isByItteration,
        groupValue: _character,
        onChanged: (SingingCharacter value) {
          setState(() {
            _character = value;
          });
        },
      ),
    );
    return Scaffold(
        appBar: AppBar(
          title: Text('Parciptrone'),
        ),
        body: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Text(
                  'A(0,6), B(1,5), C(3,3), D(2,4)',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Select learning speed:',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                learningSpeedDropDown,
                deadLineRadioButton,
                timeDeadLineDropDown,
                iterationRadioButton,
                iterationListDropDown,
                TextButton(
                  onPressed: () {
                    var iterationDropDownValue =
                        iterationListDropDown.value != null
                            ? iterationListDropDown.value.iterations
                            : -1;
                    var learningSpeedDropDownValue =
                        learningSpeedDropDown.value != null
                            ? learningSpeedDropDown.value.speed
                            : 0.01;
                    var timeDeadLineDropDownValue =
                        timeDeadLineDropDown.value != null
                            ? timeDeadLineDropDown.value.time
                            : -1.0;
                    var radioButtonValue = _character.index;
                    /*var content = radioButtonValue == 0
                        ? count(
                            learningSpeed: learningSpeedDropDownValue,
                            deadlineTime: timeDeadLineDropDownValue)
                        : count(
                            learningSpeed: learningSpeedDropDownValue,
                            itterationCount: iterationDropDownValue);*/
                    var content1 =
                        count(learningSpeed: 0.001, itterationCount: 10000);
                    var content2 =
                        count(learningSpeed: 0.01, itterationCount: 10000);
                    var content3 =
                        count(learningSpeed: 0.015, itterationCount: 10000);
                    var content4 =
                        count(learningSpeed: 0.03, itterationCount: 10000);
                    var content5 =
                        count(learningSpeed: 0.05, itterationCount: 10000);

                    var dialog = AlertDialog(
                      title: Text("Result"),
                      content: new Text("LearningSpeed: 0.001 -----\nW1: ${content1[0].toString()}\nW2: ${content1[1].toString()}\nTime: ${content1[2].toString()}\nIterations: ${content1[3].toString()};\n\n" +
                          "LearningSpeed: 0.01 -----\nW1: ${content2[0].toString()}\nW2: ${content2[1].toString()}\nTime: ${content2[2].toString()}\nIterations: ${content2[3].toString()};\n\n" +
                          "LearningSpeed: 0.015 -----\nW1: ${content3[0].toString()}\nW2: ${content3[1].toString()}\nTime: ${content3[2].toString()}\nIterations: ${content3[3].toString()};\n\n" +
                          "LearningSpeed: 0.03 -----\nW1: ${content4[0].toString()}\nW2: ${content4[1].toString()}\nTime: ${content4[2].toString()}\nIterations: ${content4[3].toString()};\n\n" +
                          "LearningSpeed: 0.05 -----\nW1: ${content5[0].toString()}\nW2: ${content5[1].toString()}\nTime: ${content5[2].toString()}\nIterations: ${content5[3].toString()};\n\n"),
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
                  child: Text('Launch parciptron'),
                )
              ],
            )));
  }
}
