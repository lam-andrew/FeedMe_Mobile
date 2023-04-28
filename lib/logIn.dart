import 'package:feedme_mobile/signUp.dart';
import 'package:feedme_mobile/swipeScreen.dart';
import 'package:feedme_mobile/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'flashMessage.dart';

class MyLoginScreen extends StatefulWidget {
  const MyLoginScreen({super.key, required this.title});

  final String title;

  @override
  State<MyLoginScreen> createState() => _MyLoginScreenState();
}

class _MyLoginScreenState extends State<MyLoginScreen> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // function that switched to signup screen
  void _switchToSignUpScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MySignUpScreen(title: "Sign-Up Page")),
    );
  }

  // function that log's the user in and bring them to the home screen is credentials are valid
  void _logIn() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MySwipeScreen(title: "Discover")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
    ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Container(
              margin: const EdgeInsets.all(10),
              child: const Text(
                'Welcome',
                style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(116,	86,	74, 1)
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 100),
              child: const Text(
                'Glad to see you!',
                style: TextStyle(
                    fontSize: 30,
                    color: Color.fromRGBO(116,	86,	74, 1)
                ),
                textAlign: TextAlign.center,
              ),
            ),

            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: TextFormField(
                controller: usernameController,
                decoration: textInputDecoration.copyWith(
                  labelText: "Email",
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Color.fromRGBO(228, 119,	102, 1),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: TextFormField(
                controller: passwordController,
                decoration: textInputDecoration.copyWith(
                  labelText: "Password",
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Color.fromRGBO(228, 119,	102, 1),
                  ),
                ),
                obscureText: true,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10.0), // create space on the right
                  child: ElevatedButton(
                    style: style,
                    onPressed: () {
                      FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: usernameController.text, password: passwordController.text)
                          .then((value) {
                        print("Successfull Log-in!");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: FlashMessage(
                                messageText1: "Hurray!",
                                messageText2: "Successful Log-In!",
                                givenColor: Color(0xFF42A142)
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ),
                        );
                        _logIn();
                      }).catchError((error) {
                        print(error.toString());
                        print("Failed to Log-In");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: FlashMessage(
                                messageText1: "Oh No!",
                                // messageText2: "That Email Address is already in use! Please try again with a different one.",
                                messageText2: error.toString(),
                                givenColor: const Color(0xFFC72C41)
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ),
                        );
                      });
                    },

                    child: const Text('Log-In'),
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  style: style,
                  onPressed: _switchToSignUpScreen,
                  child: const Text('Sign-Up'),
                ),
              ],
            ),

          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
