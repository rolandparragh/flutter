import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool isProgressing = false;
  double progress = 0.0;
  int count = 0;

  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void startProgres() {
    if (isProgressing) {
      Future.delayed(Duration(milliseconds: 100), () {
        if (isProgressing && progress <= 1.0) {
          setState(() {
            progress += 0.02;
          });
          startProgres();
        } else if (progress >= 1.0) {
          setState(() {
            count += 1;
            progress = 0.0;
          });
          itterationLimiter();
          startProgres();
        }
      });
    }
  }

  void itterationLimiter() {
    final int? limit = int.tryParse(controller.text);
    if (limit != null && count >= limit) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('You have reached the given limit'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      setState(() {
        isProgressing = false;
        count = 0;
        progress = 0.0;
      });
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Loading Bar')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FractionallySizedBox(
              widthFactor: 0.8,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Start Progress",
                ),
                Switch(
                    value: isProgressing,
                    onChanged: (bool value) {
                      setState(() {
                        isProgressing = value;
                        if (isProgressing) {
                          progress = 0.0;
                          startProgres();
                        }
                      });
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Count: ${count.toStringAsFixed(2)}"),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      count = 0;
                      isProgressing = false;
                      progress = 0.0;
                    });
                  },
                  child: Text('Reset the counter'),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
