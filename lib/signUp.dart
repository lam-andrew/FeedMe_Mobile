import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedme_mobile/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'flashMessage.dart';
import 'logIn.dart';

class MySignUpScreen extends StatefulWidget {
  const MySignUpScreen({super.key, required this.title});

  final String title;

  @override
  State<MySignUpScreen> createState() => _MySignUpScreenState();
}

const List<Widget> genders = <Widget>[
  Text('Male'),
  Text('Female'),
  Text('Other')
];

class _MySignUpScreenState extends State<MySignUpScreen> {

  TextEditingController fullNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String uid = "";
  String genderController = "";
  final List<bool> _selectedGender = <bool>[false, false, false];

  Future<void> _logOut() async {
    await FirebaseAuth.instance.signOut();
    print("logging out");
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

    var userId;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Expanded(
              flex: 30,
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Create an Account',
                      style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(116,	86,	74, 1)
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'get started now!',
                      style: TextStyle(
                          fontSize: 30,
                          color: Color.fromRGBO(116,	86,	74, 1)
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
                flex: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                      child: TextFormField(
                        controller: fullNameController,
                        decoration: textInputDecoration.copyWith(
                          labelText: "Full Name",
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Color.fromRGBO(228, 119,	102, 1),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                      child: TextFormField(
                        controller: usernameController,
                        decoration: textInputDecoration.copyWith(
                          labelText: "Email Address",
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
                    // ToggleButtons for gender selection
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 50),
                      child: ToggleButtons(
                        direction: Axis.horizontal,
                        onPressed: (int index) {
                          switch(index) {
                            case 0:
                              genderController = "Male";
                              break;
                            case 1:
                              genderController = "Female";
                              break;
                            case 2:
                              genderController = "Other";
                              break;
                            default:
                              genderController = "Other";
                          }

                          setState(() {
                            // The button that is tapped is set to true, and the others to false.
                            for (int i = 0; i < _selectedGender.length; i++) {
                              _selectedGender[i] = i == index;
                            }
                          });
                        },
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        selectedBorderColor: Colors.red[700],
                        selectedColor: Colors.white,
                        fillColor: Colors.red[200],
                        color: Colors.red[400],
                        constraints: const BoxConstraints(
                          minHeight: 40.0,
                          minWidth: 80.0,
                        ),
                        isSelected: _selectedGender,
                        children: genders,
                      ),
                    ),
                  ],
                )
            ),

            Expanded(
              flex: 20,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                    children: [
                      ElevatedButton(
                        style: style,
                        onPressed: () {
                          print(usernameController.text);
                          print(passwordController.text);
                          print(fullNameController.text);
                          print(genderController);

                          // Sign up a user and save to Firebase Authentication Service
                          FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: usernameController.text, password: passwordController.text)
                              .then((value) {
                            // assign the fullNameController text to the displayName data of auth instance
                            FirebaseAuth.instance.currentUser?.updateDisplayName(fullNameController.text);
                            // Display a FlashMessage of Successful or Unsuccessful sign-up
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: FlashMessage(
                                    messageText1: "Hurray!",
                                    messageText2: "Successful Sign-Up!",
                                    givenColor: Color(0xFF42A142)
                                ),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                              ),
                            );

                            // Log the user in right after sign-up
                            FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: usernameController.text, password: passwordController.text)
                                .then((value) {
                              print("Successful Log-in!");
                              _logOut();
                            }).catchError((error) {
                              print(error.toString());
                              print("Failed to Log-In");
                            });

                            // Get User profile information
                            final user = FirebaseAuth.instance.currentUser;
                            if(user != null) {
                              userId = user.uid;
                              print(userId);
                            }

                            // WRITE new user sign-up information into firebase [Don't know if this is needed]
                            FirebaseFirestore.instance.collection("users").add(
                                {
                                  "uid": userId,
                                  "fullName" : fullNameController.text,
                                  "email" : usernameController.text,
                                  "password" : passwordController.text,
                                  "gender" : genderController,
                                  "matches": [],
                                }
                            ).then((value)  {
                              print("Successfully added the user");
                            }).catchError((error) {
                              print("Failed to add the user: $error");
                            });

                            _switchToLogInScreen();
                          }).catchError((error) {
                            print("Failed to sign up the user: $error");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: FlashMessage(
                                    messageText1: "Oh No!",
                                    // messageText2: "There has been an Error Signing up. Please Try Again.",
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
                        child: const Text('Sign-Up'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        style: style,
                        onPressed: _switchToLogInScreen,
                        child: const Text('Log-In'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
