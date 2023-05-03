import 'package:feedme_mobile/signUp.dart';
import 'package:feedme_mobile/swipeScreen.dart';
import 'package:flutter/material.dart';
import 'logIn.dart';

class MyMainPage extends StatefulWidget {
  const MyMainPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {

  // function that switched to signup screen
  void _switchToSignUpScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MySignUpScreen(title: "Sign-Up Page")),
    );
  }

  // function that switches to login screen
  void _switchToLogInScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyLoginScreen(title: "Log-In Page")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
    ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      // backgroundColor: const Color.fromRGBO(244,	244,	244	, 1),
      backgroundColor: const Color.fromRGBO(255,	255,	255	, 1),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'FEED ME',
              style: TextStyle(
                  fontFamily: 'RobotoMono',
                  fontSize: 55,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(228, 119,	102, 1)
              ),
              textAlign: TextAlign.center,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: const Image(
                    // image: NetworkImage('https://img.freepik.com/premium-vector/cartoon-burger-illustration-vector-sticker_581871-129.jpg?w=826'),
                    // image: NetworkImage('https://www.creativefreedom.co.uk/wp-content/uploads/2016/03/burger-icon.jpg'),
                    image: NetworkImage('https://thehill.com/wp-content/uploads/sites/2/2021/07/ca_food_healthy_decision_illustration_istock-1200846987.jpg?w=1280&h=720&crop=1'),
                    height: 300,
                    width: 500,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 75), // creates space at the top of the text
                  child: ElevatedButton(
                    style: style,
                    onPressed: _switchToSignUpScreen,
                    child: const Text('Create An Account'),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 50), // creates space at the top of the text
              child: const Text(
                'Already have an account?',
              ),
            ),
            ElevatedButton(
              style: style,
              onPressed: _switchToLogInScreen,
              child: const Text('Log-In'),
            ),

          ],
        ),
      ),
    );
  }
}

