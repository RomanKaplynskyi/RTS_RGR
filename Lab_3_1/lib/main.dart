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

class FermaCounter {
  int x;

  static bool perfectSquare(int n) {
    int x = n;

    if (n < 1) {
      return false;
    } else {
      for (int i = 0; i < (n / 2).floor() + 1; i++) {
        if ((i * i) == n) return true;
      }
    }
    return pow((pow(x, 0.5)), 2) == x;
  }

  List<int> methodFerma(int n) {
    var s = pow(n, 0.5).floor() + 1;
    var k = 0;
    while (!perfectSquare(pow(s + k, 2) - n)) {
      k += 1;
    }
    var y_sqrt = pow((pow(s + k, 2) - n).floor(), 0.5).floor();
    var a = ((s + k) - y_sqrt).floor();
    var b = ((s + k) + y_sqrt).floor();
    return [a, b];
  }
}

class _State extends State<MyApp> {
  TextEditingController numberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Ferma Function'),
        ),
        body: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    controller: numberController,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter number',
                      hintText: 'Number',
                    ),
                  ),
                ),
                RaisedButton(
                  textColor: Colors.white,
                  color: Colors.blue,
                  child: Text('Ferma transormation'),
                  onPressed: () {
                    return showDialog(
                      context: context,
                      builder: (context) {
                        var ferma = new FermaCounter();
                        String content;
                        try {
                          int number = int.parse(numberController.text);
                          var fermaResult = ferma.methodFerma(number);
                          content = "${fermaResult[0]} ${fermaResult[1]}";
                        } catch (e) {
                          content = "Invalid input";
                        }
                        var dialog = AlertDialog(
                          title: Text("Result"),
                          content: new Text(content),
                          actions: <Widget>[
                            new TextButton(
                              child: new Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                        return dialog;
                      },
                    );
                  },
                )
              ],
            )));
  }
}
