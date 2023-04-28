import 'package:feedme_mobile/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'Feed Me',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
// ATTEMPT AT CUSTOM COLOR [NOT IMPLEMENTED]
Map<int, Color> color =
{
  50:const Color.fromRGBO(228, 119,	102, .1),
  100:const Color.fromRGBO(228, 119,	102, .2),
  200:const Color.fromRGBO(228, 119,	102, .3),
  300:const Color.fromRGBO(228, 119,	102, .4),
  400:const Color.fromRGBO(228, 119,	102, .5),
  500:const Color.fromRGBO(228, 119,	102, .6),
  600:const Color.fromRGBO(228, 119,	102, .7),
  700:const Color.fromRGBO(228, 119,	102, .8),
  800:const Color.fromRGBO(228, 119,	102, .9),
  900:const Color.fromRGBO(228, 119,	102, 1),
};

MaterialColor customColor = MaterialColor(0xFFE47766, color);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feed Me',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        // primarySwatch: Colors.brown,
        primarySwatch: customColor,
      ),
      home: const MySplashScreen(title: ''),  // empty title
    );
  }
}

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key, required this.title});
  final String title;
  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyMainPage(title: "My Main Page")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // backgroundColor: Color.fromRGBO(240, 179, 87, 1),  // old picture
      backgroundColor: Color.fromRGBO(244,	244,	244	, 1),
      body: Center(
        child: Image(
          // image: NetworkImage('https://img.freepik.com/premium-vector/cartoon-burger-illustration-vector-sticker_581871-129.jpg?w=826'), // old picture
          image: NetworkImage('https://www.creativefreedom.co.uk/wp-content/uploads/2016/03/burger-icon.jpg'),
          height: 250,
          width: 450,
        ),
      ),
    );
  }
}