import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

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
 late SharedPreferences _prefs;

  @override
  void initState() async {
    super.initState();
    _prefs = await SharedPreferences.getInstance();
    _loadStored();
  }

  Future<void> _loadStored() async {
    setState(() {
      _stored = _prefs.getDouble('stored') ?? 0;
    });
  }

  Future<void> _setStored() async {
    setState(() {
      _prefs.setDouble('stored', progress);
      _stored = _prefs.getDouble('stored') ?? 0;
    });
  }

  void startProgress() {
    if (isProgressing) {
      Future.delayed(Duration(milliseconds: 100), () {
        if (isProgressing && progress <= 1.0) {
          setState(() {
            progress += 0.02;
          });
          startProgress();
        } else if (progress >= 1.0) {
          setState(() {
            count += 1;
            progress = 0.0;
          });

          startProgress();
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
                          startProgress();
                        }
                      });
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Count: ${count.toStringAsFixed(2)}"),
                Text('Stored: ${_stored.toStringAsFixed(2)}'),
                ElevatedButton(
                  onPressed: () {
                    _setStored();
                    setState(() {
                      count = 0;
                      // isProgressing = false;
                    });
                  },
                  child: Text('Reset the counter'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blue.withOpacity(0.1),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        hintText: "How long should it run?",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
