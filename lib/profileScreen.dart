import 'package:feedme_mobile/mainScreen.dart';
import 'package:feedme_mobile/matchesScreen.dart';
import 'package:feedme_mobile/swipeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key, required this.title});

  final String title;

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch(_selectedIndex) {
      case 0:
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MySwipeScreen(title: "Discover")),
        );
        break;
      case 2:
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MyMatchesScreen(title: "My Matches")),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

    var userEmail;
    var userName;
    var userId;

    // Get User profile information
    final _user = FirebaseAuth.instance.currentUser;
    if(_user != null) {
      userName = _user.displayName;
      userEmail = _user.email;
      userId = _user.uid;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign-Out',
            onPressed: () async {
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => const MyMainPage(title: "Feed me")),
              );
              await FirebaseAuth.instance.signOut();
              print("logging out");
            },
          ),
        ],
      ),

      backgroundColor: const Color.fromRGBO(230, 210, 200, 1),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: NetworkImage('https://cdn-icons-png.flaticon.com/512/3135/3135768.png'),
              height: 150,
              width: 150,
            ),
            const Divider(
              height: 20,
              thickness: 3,
              indent: 125,
              endIndent: 125,
              color: Colors.black87,
            ),

            Text(
              userName,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),
            ),
            Text(
              userEmail,
            ),
          ],

        ),

      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Matches',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.brown[1],
        onTap: _onItemTapped,
      ),
    );
  }
}
