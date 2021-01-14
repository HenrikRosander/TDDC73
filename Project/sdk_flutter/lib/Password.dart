import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

String passwordText;
double passwordStrength = 0.0;
double textStrength = 0.0;
int length = 0;

int minLength = 8;
int maxLength = 12;

bool lengthdummy = false;
int feedbackStrength = 0;
double widthStrength = 0;

void main() {
  testWidgets('MyWidget has a title and message', (WidgetTester tester) async {
    // Test code goes here.
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

@override
Scaffold passwordWidget;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final passwordController = TextEditingController();

  void initState() {
    super.initState();
    passwordController.addListener(() {
      checkPassword();
    });
  }

  Color colorcheck() {
    if (passwordStrength < .40) return Colors.red;
    if (passwordStrength > .40 && passwordStrength < .70) return Colors.yellow;
    if (passwordStrength > .70 && passwordText.length >= minLength)
      return Colors.green;
  }

  void checkPassword() {
    setState(() {
      passwordStrength = 0.0;
      textStrength = 0.0;
      passwordText = passwordController.text;
      //Amount of characters (1/24 per letter, maximum 12/24 = 50%)
      if (passwordText.length <= maxLength) {
        textStrength += (1 / (maxLength * 2)) * passwordText.length;
        if (passwordText.length == maxLength) lengthdummy = true;
      }
      if (passwordText.length > maxLength && lengthdummy) textStrength = 0.5;

      //If there is a special character, add 16% more to the strength.
      if (passwordText.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]')))
        passwordStrength += .16;
      //If there is a capital letter, add 17% more to the strength. (17% because of even rounding).
      if (passwordText.contains(new RegExp(r'[A-Z]'))) passwordStrength += 0.17;
      //If there is a number, add 16% more to the strength.
      if (passwordText.contains(new RegExp(r'[0-9]'))) passwordStrength += 0.17;

      passwordStrength += textStrength;
    });
    double b = passwordStrength * 100;
    feedbackStrength = b.round();
    widthStrength = (feedbackStrength * 3).toDouble();
  }

  final passwordWidget = Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 300,
            child: TextFormField(
              // controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Container(
              child: LinearPercentIndicator(
                width: 300,
                animateFromLastPercent: true,
                lineHeight: 20,
                animation: true,
                animationDuration: 500,
                alignment: MainAxisAlignment.center,
                percent: passwordStrength,
                center: Text(
                  feedbackStrength.toString() + '%',
                ),
                // progressColor: colorcheck(),
                linearStrokeCap: LinearStrokeCap.roundAll,
              ),
            ),
          ),
        ],
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return passwordWidget;
  }
}
