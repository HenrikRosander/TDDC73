import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
//@TODO: Add a text under the password form field that gives feedback to the user how the

void main() {
  runApp(MyApp());
}

bool checkPassword() {
  if (passwordText == null) return false;

  if (passwordText.length > 7) {
    return true;
  } else
    return false;
}

double passwordStrength() {
  double value = 0.0;
  if (passwordText == null) return 0.0;
  if (passwordText.length > 7) {
    value += 0.2;
  }

  return value;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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

String passwordText;
TextEditingController passwordController;
double value = 0;
String percentValue;

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController passwordController = TextEditingController();

  void initState() {
    super.initState();
    passwordController.addListener(() {
      setState(() {
        passwordText = passwordController.text;
      });
    });
  }

  double progress = passwordStrength();
  currentProgressColor() {
    if (progress >= 0.6 && progress < 0.8) {
      return Colors.orange;
    }
    if (progress >= 0.8) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.white,
              alignment: Alignment(0, 0),
              child: CircularPercentIndicator(
                animationDuration: 200,
                animateFromLastPercent: true,
                arcType: ArcType.FULL,
                arcBackgroundColor: Colors.black12,
                backgroundColor: Colors.white,
                progressColor: currentProgressColor(),
                percent: progress,
                animation: true,
                radius: 250.0,
                lineWidth: 12.0,
                circularStrokeCap: CircularStrokeCap.butt,
              ),
            ),
            Container(
              alignment: Alignment(0, 0),
              child: Text(
                "${this.progress * 100}%",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment(0.3, 0.5),
              child: RaisedButton(
                  color: Colors.green,
                  onPressed: () {
                    final updated =
                        ((this.progress + 0.1).clamp(0.0, 1.0) * 100);
                    setState(() {
                      this.progress = updated.round() / 100;
                    });
                    print(progress);
                  },
                  child: Text(
                    '+10%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
            ),
            Container(
              alignment: Alignment(-0.3, 0.5),
              child: RaisedButton(
                  color: Colors.red,
                  onPressed: () {
                    final updated =
                        ((this.progress - 0.1).clamp(0.0, 1.0) * 100);
                    setState(() {
                      this.progress = updated.round() / 100;
                    });
                    print(progress);
                  },
                  child: Text(
                    '-10%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
            ),
            Container(
              child: Padding(
                  padding: const EdgeInsets.only(left: 0, right: 0, top: 50),
                  child: SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: checkPassword()
                                    ? Colors.green
                                    : Colors.lightBlue)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  checkPassword() ? Colors.green : Colors.red),
                        ),
                        labelText: 'Password',
                      ),
                    ),
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(left: 490, top: 10),
              child: Container(
                child: new LinearPercentIndicator(
                  width: 300.0,
                  lineHeight: 20.0,
                  percent: 0.5,
                  center: new Text('50%'),
                  backgroundColor: Colors.grey,
                  progressColor: Colors.blue,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
