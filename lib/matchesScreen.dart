import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedme_mobile/profileScreen.dart';
import 'package:feedme_mobile/restaurantDetails.dart';
import 'package:feedme_mobile/swipeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'matches.dart';

class MyMatchesScreen extends StatefulWidget {
  const MyMatchesScreen({super.key, required this.title});

  final String title;

  @override
  State<MyMatchesScreen> createState() => _MyMatchesScreenState();
}

class _MyMatchesScreenState extends State<MyMatchesScreen> {
  int _selectedIndex = 2;
  late List userMatchesArr = List.empty();
  String userEmail = "";
  String userName = "";
  String userId = "";
  List<Matches> matchesList = <Matches>[];

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
      case 1:
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MyProfileScreen(title: "My Profile")),
        );
        break;
    }
  }

  // Get each matched restaurant's info
  Future getMatchInfo() async {

    // Load the match data from the users collection
    CollectionReference collectionRef1 = FirebaseFirestore.instance.collection("users");
    // await will wait for this future to complete before executing subsequent statements
    await collectionRef1.get().then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        // if user id's match then access the matches array
        if(userId == element["uid"]) {
          userMatchesArr = element["matches"];
        }
      }
    });

    // Load the data from the restaurants collection
    CollectionReference collectionRef2 = FirebaseFirestore.instance.collection("restaurants");
    await collectionRef2.get().then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        // iterate through all the matches and check their Id's with the restaurants collection documents
        for(int i = 0; i < userMatchesArr.length; i++) {
          if(element.id == userMatchesArr[i]) {
            // Add a new Matches item into the matchesList List with all the restaurant info
            matchesList.add(Matches(name: element["resName"], rating: element["resRating"], hours: element["resHours"],
                type: element["resType"], iconURL: element["resIconURL"], imageURL:
                element["resImageURL"], description: element["resDescription"], pricing: element["resPricing"], id: element["resID"]));
          }
          setState(() {});
        }
      }
    });
  } // end getMatchInfo

  @override
  void initState() {
    super.initState();
    setState(() {});
    // WidgetsBinding.instance.addPostFrameCallback((_){
    //   getMatches();
    // });
    getMatchInfo().then((value) {
      setState(() {});
    });
  }

  BoxDecoration myBoxDeco() {
    return BoxDecoration(
      // color: const Color.fromRGBO(230, 210, 200, 1),
        color: const Color.fromRGBO(230, 210, 200, 1),
        border: Border.all(),
        borderRadius: const BorderRadius.all(
            Radius.circular(5.0)
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get User profile information
    final user = FirebaseAuth.instance.currentUser;
    if(user != null) {
      userName = user.displayName!;   // ! is a null check
      userEmail = user.email!;        // ! is a null check
      userId = user.uid;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
      ),

      body: ListView.builder(
          itemCount: matchesList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Container(
                height: 100,
                margin: const EdgeInsets.all(5),
                decoration: myBoxDeco(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 25,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Image(
                          image: NetworkImage(matchesList[index].iconURL),
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            matchesList[index].name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                            ),
                          ),
                          Text(
                            'Rating: ${matchesList[index].rating}',
                          ),
                          Text(
                            matchesList[index].hours,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 25,
                      child: Text(
                        matchesList[index].type,
                        style: const TextStyle(
                            fontSize: 20
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                var match = matchesList[index];
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyDetailsScreen(title: "DetailsPage", matchItem: match)),
                );
              },
            );
          }
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


