import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'Password.dart';

void main() {
  runApp(MyApp());
}

String emailText;
String fullNameText;
String passwordText;
String usernameText;
String dateText;
String monthText;
String yearText;
String genderText;
bool passwordchecker = false;

bool checkMail() {
  if (emailText == null) {
    return false;
  }
  if (emailText.contains("@")) {
    int start = emailText.indexOf("@");
    String temp = emailText.substring(start, emailText.length);
    if (temp.contains(".")) {
      int st = temp.indexOf(".");
      String temp2 = temp.substring(st, temp.length);
      if (temp2.length > 1) {
        return true;
      }
      return false;
    }
    return false;
  } else
    return false;
}

bool checkName() {
  if (fullNameText == null) return false;
  if (fullNameText.contains(" ")) {
    if (fullNameText.length > 4) {
      return true;
    }
    return false;
  } else
    return false;
}

bool checkUserName() {
  if (usernameText == null)
    return false;
  else {
    if (usernameText.length > 3) return true;
  }
  return false;
}

bool checkPasswordText() {
  if (passwordText == null) return false;
  //@@TODO: This will be replaced by a "real" password checker.
  if (passwordText.length > 7) {
    if (passwordchecker) {
      return true;
    }
  }

  return false;
}

bool checkDay() {
  //Check if the string is between 01-31
  if (dateText == null) return false;
  if (dateText.length > 0) {
    int dateinInts = int.parse(dateText);
    if (dateinInts < 10 && dateText.characters.first != "0") {
      return false;
    }
    if (dateinInts >= 1 && dateinInts <= 31) {
      return true;
    }
  }
  return false;
}

bool checkMonth() {
  //Check if the string is between 01-12
  if (monthText == null) return false;
  if (monthText.length > 0) {
    int monthinInts = int.parse(monthText);
    if (monthinInts < 10 && monthText.characters.first != "0") {
      return false;
    }
    if (monthinInts >= 1 && monthinInts <= 12) {
      return true;
    }
  }
  return false;
}

bool checkYear() {
  //Check if the string is between 1900-2020
  if (yearText == null) return false;
  if (yearText.length > 0) {
    int yearinInts = int.parse(yearText);
    if (yearinInts >= 1900 && yearinInts <= 2020) {
      return true;
    }
  }

  return false;
}

bool checkGender() {
  if (genderText != null) {
    return true;
  }
  return false;
}

bool accept() {
  if (checkMail() &&
      checkName() &&
      checkUserName() &&
      checkPasswordText() &&
      checkDay() &&
      checkMonth() &&
      checkYear() &&
      checkedValue &&
      checkGender()) return true;
  return false;
}

void buttonPressed() {
  //@@TODO: Here we add what happens when we can, and have, pressed the create account button.
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Account registration SDK',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

bool checkedValue = false;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController dayController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  final passwordController = TextEditingController();

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
      if (passwordStrength > 0.7) {
        passwordchecker = true;
      } else
        passwordchecker = false;
    });
    double b = passwordStrength * 100;
    feedbackStrength = b.round();
    widthStrength = (feedbackStrength * 3).toDouble();
  }

  void initState() {
    super.initState();

    dayController.addListener(() {
      setState(() {
        dateText = dayController.text;
      });
    });
    monthController.addListener(() {
      setState(() {
        monthText = monthController.text;
      });
    });
    yearController.addListener(() {
      setState(() {
        yearText = yearController.text;
      });
    });

    emailController.addListener(() {
      // printemail();
      setState(() {
        emailText = emailController.text;
      });
    });

    fullNameController.addListener(() {
      setState(() {
        fullNameText = fullNameController.text;
      });
    });

    userNameController.addListener(() {
      setState(() {
        usernameText = userNameController.text;
      });
    });
    passwordController.addListener(() {
      setState(() {
        passwordText = passwordController.text;
      });
      checkPassword();
    });
  }

  String _dropDownValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter SDK Account Registration'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Transform.translate(
              offset: Offset(32, 270),
              child: Text(
                'Welcome to register your new account here! ',
                style: TextStyle(fontSize: 30),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: NetworkImage(
                    'https://cdn0.iconfinder.com/data/icons/simpline-mix/64/simpline_27-512.png',
                  ),
                  width: 300,
                  height: 150,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //Full name
                    Container(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 0, right: 0, top: 175),
                          child: SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: fullNameController,
                              keyboardType: TextInputType.name,
                              inputFormatters: [
                                FilteringTextInputFormatter(
                                    RegExp("[a-zA-Z]| "),
                                    allow: true),
                              ],
                              decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: checkName()
                                            ? Colors.green
                                            : Colors.lightBlue),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: checkName()
                                            ? Colors.green
                                            : Colors.red),
                                  ),
                                  labelText: 'Full Name',
                                  hintText: 'E.g. Lars Larsson'),
                            ),
                          )),
                    ),
                    //Username
                    Container(
                      child: Padding(
                          padding:
                              const EdgeInsets.only(left: 0, right: 0, top: 50),
                          child: SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: userNameController,
                              decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: checkUserName()
                                            ? Colors.green
                                            : Colors.lightBlue),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: checkUserName()
                                              ? Colors.green
                                              : Colors.red)),
                                  labelText: 'Username',
                                  hintText: 'E.g. Lars65'),
                            ),
                          )),
                    ),
                    //Email
                    Container(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 0, right: 0, top: 50, bottom: 10),
                          child: SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: emailController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: checkMail()
                                              ? Colors.green
                                              : Colors.lightBlue)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: checkMail()
                                              ? Colors.green
                                              : Colors.red)),
                                  labelText: 'Email',
                                  hintText: 'E.g. Lars.Larsson@gmail.com'),
                            ),
                          )),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 330),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 0, right: 215, top: 0, bottom: 5),
                        child: Text('Select Gender'),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0, right: 0),
                          child: SizedBox(
                            width: 300,
                            height: 52,
                            child: new DropdownButtonFormField(
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: checkGender()
                                            ? Colors.green
                                            : Colors.lightBlue)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: checkGender()
                                            ? Colors.green
                                            : Colors.red)),
                              ),
                              hint: _dropDownValue == null
                                  ? Text('Please Select')
                                  : Text(
                                      _dropDownValue,
                                      style: TextStyle(color: Colors.black),
                                    ),
                              items: ['Male', 'Female', 'Other'].map(
                                (val) {
                                  return DropdownMenuItem<String>(
                                    value: val,
                                    child: Text(val),
                                  );
                                },
                              ).toList(),
                              onChanged: (val) {
                                setState(
                                  () {
                                    _dropDownValue = val;
                                    genderText = val;
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      //Password
                      Container(
                        child: SizedBox(
                          width: 300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 0, right: 30, top: 0, bottom: 5),
                                child: Text(
                                    'The password must be at least 8 characters, contain a capital letter and a number.'),
                              ),
                              SizedBox(
                                width: 300,
                                child: TextFormField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: checkPasswordText()
                                                ? Colors.green
                                                : Colors.lightBlue)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: checkPasswordText()
                                                ? Colors.green
                                                : Colors.red)),
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
                                    progressColor: colorcheck(),
                                    linearStrokeCap: LinearStrokeCap.roundAll,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 0, right: 220, top: 10),
                              child: Text('Date of birth'),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 0, right: 0, top: 5),
                                child: SizedBox(
                                    width: 300,
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 16),
                                          child: SizedBox(
                                            width: 90,
                                            child: TextFormField(
                                              controller: dayController,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              textInputAction:
                                                  TextInputAction.next,
                                              maxLength: 2,
                                              decoration: InputDecoration(
                                                labelStyle: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: checkDay()
                                                          ? Colors.green
                                                          : Colors.lightBlue),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: checkDay()
                                                                ? Colors.green
                                                                : Colors.red)),
                                                labelText: 'DD',
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 12),
                                          child: SizedBox(
                                            width: 90,
                                            child: TextFormField(
                                              controller: monthController,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              maxLength: 2,
                                              decoration: InputDecoration(
                                                labelStyle: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: checkMonth()
                                                          ? Colors.green
                                                          : Colors.lightBlue),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: checkMonth()
                                                          ? Colors.green
                                                          : Colors.red),
                                                ),
                                                hintText: 'MM',
                                                labelText: 'MM',
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 0),
                                          child: SizedBox(
                                            width: 90,
                                            child: TextFormField(
                                              controller: yearController,
                                              maxLength: 4,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              decoration: InputDecoration(
                                                labelStyle: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: checkYear()
                                                          ? Colors.green
                                                          : Colors.lightBlue),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: checkYear()
                                                                ? Colors.green
                                                                : Colors.red)),
                                                hintText: 'YYYY',
                                                labelText: 'YYYY',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ))),
                            SizedBox(
                              width: 500,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 20,
                                            left: 90,
                                          ),
                                          child: Checkbox(
                                            value: checkedValue,
                                            onChanged: (bool newValue) {
                                              setState(
                                                () {
                                                  checkedValue = !checkedValue;
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 20,
                                            left: 10,
                                          ),
                                          child: Text(
                                            'I acknowledge that I have read and accept\nthe Terms of Use Agreement and consent\nto the Privacy Policy.',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.blueGrey),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 40),
                                    child: SizedBox(
                                      width: 300,
                                      height: 50,
                                      child: RaisedButton(
                                        disabledColor: Colors.grey,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0)),
                                        onPressed: accept()
                                            ? () => buttonPressed()
                                            : null,
                                        color: Colors.lightBlue,
                                        child: const Text('Create Account',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
