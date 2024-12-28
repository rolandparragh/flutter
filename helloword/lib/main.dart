import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}
// distributionUrl=https\://services.gradle.org/distributions/gradle-8.1.1-all.zip

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isProgressing = false;
  double progress = 0.0;
  int count = 0;
  double _stored = 0;

  @override
  void initState() {
    super.initState();
    _loadStored();
  }

  Future<void> _loadStored() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _stored = prefs.getDouble('stored') ?? 0;
    });
  }

  Future<void> _setStored() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _stored = progress;
      prefs.setDouble('stored', _stored);
    });
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

          startProgres();
        }
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
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Count: ${count.toString()}"),
                Text('Stored: ${_stored.toString()}'),
                ElevatedButton(
                  onPressed: () {
                    _setStored();
                    setState(() {
                      count = 0;
                      progress = 0.0;
                      isProgressing = false;
                    });
                  },
                  child: Text('Reset the counter'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
