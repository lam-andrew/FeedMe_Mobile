import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedme_mobile/profileScreen.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'matchesScreen.dart';
import 'matches.dart';

class MySwipeScreen extends StatefulWidget {
  const MySwipeScreen({super.key, required this.title});
  final String title;

  @override
  State<MySwipeScreen> createState() => _MySwipeScreenState();
}

List<SwipeItem> _swipeItems = <SwipeItem>[];
List<Restaurants> _restaurantList = <Restaurants>[];
List<Users> _userList = <Users>[];
late List userMatchesArr = List.empty();
List<Matches> matchesList = <Matches>[];
// List<MenuItems> menuItems = <MenuItems>[];
MatchEngine? _matchEngine;

class _MySwipeScreenState extends State<MySwipeScreen> {

  String userId = "";
  String userDatabaseID = "";
  String currentUserUID = "";

  // // Get each matched restaurant's info
  // Future getMatchInfo() async {
  //   // Load the data from the restaurants collection
  //   CollectionReference collectionRef2 = FirebaseFirestore.instance.collection("restaurants");
  //   await collectionRef2.get().then((QuerySnapshot querySnapshot) {
  //     for (var element in querySnapshot.docs) {
  //         // convert the resMenuItems array into the menuItems List
  //         menuItems.add(MenuItems(imageURL1: element['imageURL1'], imageURL2: element['imageURL2'], imageURL3: element['imageURL3'], imageURL4: element['imageURL4'], imageURL5: element['imageURL5']));
  //         print(menuItems);
  //       setState(() {});
  //     }
  //   });
  // } // end getMatchInfo

  // get user info and store its matches and uid in _userList
  Future<List<Users>> getUserData() async {
    await FirebaseFirestore.instance.collection("users").get()
      .then((querySnapshot) {
        for(var element in querySnapshot.docs) {
          print(element.id);
          // move the matches in the database into a dynamic List
          List<dynamic> tempMatches = <dynamic>[];
          tempMatches = element.data()['matches'];
          // move matches from dynamic List to String List
          List<String> userMatches = <String>[];
          for(int i = 0; i < tempMatches.length; i++) {
            userMatches.add(tempMatches[i].toString());
          }

          // check for duplicate Users in _userList and add the Users
          if(_userList.isNotEmpty) {
            for(int j = 0; j < _userList.length; j++) {
              if(!(_userList[j].uid == element.data()['uid'])) {
                Users newUser = Users(uid: element.data()['uid'], matches: userMatches);
                _userList.add(newUser);
              }
            }
          } else {
            Users newUser = Users(uid: element.data()['uid'], matches: userMatches);
            _userList.add(newUser);
          }

        }
      }).catchError((error) {
        print("failed to load the user info");
        print(error);
      });
    return _userList;
  }

  // get restaurant info and store in _restaurantList
  Future<List<Restaurants>> getRestaurantData() async {
    // Load all the Restaurants information from firebase
    // await will wait for a future to complete before executing the subsequent statement
    await FirebaseFirestore.instance.collection("restaurants").get()
        .then((querySnapshot) {
      for (var element in querySnapshot.docs) {
        // print(element.data());              // print all data
        // print(element.data()['resName']);   // print specific data
        _restaurantList.add(Restaurants(name: element.data()['resName'], rating: element.data()['resRating'], hours: element.data()['resHours'],
            type: element.data()['resType'], iconURL: element.data()['resIconURL'], imageURL: element.data()['resImageURL'],
            description: element.data()['resDescription'], pricing: element.data()['resPricing'], resID: element.data()['resID'], elementID: element.id));
      }
    }).catchError((error) {
      print("failed to load the restaurants");
      print(error);
    });
    return _restaurantList;
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
          userDatabaseID = element.id;
          // currentUserUID = element["uid"];
          userMatchesArr = element["matches"];
        }
      }
    });

    print("userMatchesArray");
    print(userMatchesArr);

    // // Load the data from the restaurants collection
    // CollectionReference collectionRef2 = FirebaseFirestore.instance.collection("restaurants");
    // await collectionRef2.get().then((QuerySnapshot querySnapshot) {
    //   for (var element in querySnapshot.docs) {
    //     // iterate through all the matches and check their Id's with the restaurants collection documents
    //     for(int i = 0; i < userMatchesArr.length; i++) {
    //       if(element.id == userMatchesArr[i]) {
    //         // Add a new Matches item into the matchesList List with all the restaurant info
    //         matchesList.add(Matches(name: element["resName"], rating: element["resRating"], hours: element["resHours"],
    //             type: element["resType"], iconURL: element["resIconURL"], imageURL:
    //             element["resImageURL"], description: element["resDescription"], pricing: element["resPricing"], id: element["resID"]));
    //       }
    //       setState(() {});
    //     }
    //   }
    // });

  } // end getMatchInfo

  // add each restaurant's content into _swipeItems List
  void initializeSwipeCards() {
    _swipeItems.clear();
    for (int i = 0; i < _restaurantList.length; i++) {
      _swipeItems.add(SwipeItem(
        content: Content(
          text: _restaurantList[i].name,
          imageURL: _restaurantList[i].imageURL,
        ),
        likeAction: () {
          // check if liked restaurant is already on User's matches list
          if(!userMatchesArr.contains(_restaurantList[i].elementID)) {
            // add liked Restaurant to User's matches list
            print(" USER ID: ${userId}");
            print("USER DOCUMENT ID: ${userDatabaseID}");
            FirebaseFirestore.instance.collection("users").doc(userDatabaseID).update({"matches": FieldValue.arrayUnion([_restaurantList[i].elementID])});
          }

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Liked ${_restaurantList[i].name}"),
            duration: const Duration(milliseconds: 500),
          ));
        },
        nopeAction: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Nope ${_restaurantList[i].name}"),
            duration: const Duration(milliseconds: 500),
          ));
        },
      ));
    }
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  } // end initializeSwipeCards

  @override
  void initState() {
    super.initState();
    _swipeItems.clear();
    _restaurantList.clear();
    getRestaurantData().then((value) {
      setState(() {});
    });
    getUserData().then((value) {
      setState(() {});
    });
    getMatchInfo().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // get the user info and store it in _user
    final user = FirebaseAuth.instance.currentUser;
    if(user != null) {
      userId = user.uid;
    }

    // this function is called in build because when called in initState it executes before restaurants collection is loaded
    initializeSwipeCards();

    ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
      ),
      body: Stack(children: [
        SizedBox(
          height: 625,
          width: 450,
          child: Container(
            margin: const EdgeInsets.all(10),
            // User the restaurant information initialized in _swipeItems (stored in _matchEngine) to construct swipe cards
            child: SwipeCards(
              matchEngine: _matchEngine!,
              itemBuilder: (BuildContext context, int index) {
                // ClipRRect makes SwipeCards with rounded corners
                return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    alignment: Alignment.center,
                    color: const Color.fromRGBO(230, 210, 200, 1),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 50,
                          child: Column(
                            children: [
                              Container(
                                width: 500,
                                height: 300,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(_restaurantList[index].imageURL),
                                      fit: BoxFit.fitHeight
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 50),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _restaurantList[index].name,
                                  style: const TextStyle(fontSize: 50),
                                  textAlign: TextAlign.center,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _restaurantList[index].type,
                                      style: const TextStyle(fontSize: 25),
                                      textAlign: TextAlign.center,
                                    ),
                                    const Text(
                                      "•    ",
                                      style: TextStyle(fontSize: 25),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      _restaurantList[index].pricing,
                                      style: const TextStyle(fontSize: 25),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                Text(
                                  _restaurantList[index].hours,
                                  style: const TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ) ,
                          ),
                        ),


                        // Expanded(
                        //   flex: 35,
                        //   child: Container(
                        //     margin: const EdgeInsets.only(bottom: 50),
                        //     child: Column(
                        //
                        //       children: [
                        //           // const Text(
                        //           //   "Menu Items",
                        //           //   style: TextStyle(
                        //           //       fontSize: 18,
                        //           //       fontWeight: FontWeight.bold
                        //           //   ),
                        //           // ),
                        //           Container(
                        //             margin: const EdgeInsets.only(top: 5),
                        //             height: 175,
                        //             child: ListView(
                        //               scrollDirection: Axis.horizontal,
                        //               children: <Widget>[
                        //                 if(menuItems.isNotEmpty)...[
                        //                   SizedBox(
                        //                     child: Image(
                        //                       image: NetworkImage(menuItems[index].imageURL1),
                        //                     ),
                        //                   ),
                        //                   SizedBox(
                        //                     child: Image(
                        //                       image: NetworkImage(menuItems[index].imageURL2),
                        //                     ),
                        //                   ),
                        //                   SizedBox(
                        //                     child: Image(
                        //                       image: NetworkImage(menuItems[index].imageURL3),
                        //                     ),
                        //                   ),
                        //                   SizedBox(
                        //                     child: Image(
                        //                       image: NetworkImage(menuItems[index].imageURL4),
                        //                     ),
                        //                   ),
                        //                   SizedBox(
                        //                     child: Image(
                        //                       image: NetworkImage(menuItems[index].imageURL5),
                        //                     ),
                        //                   ),
                        //                 ]
                        //
                        //               ],
                        //             ),
                        //           ),
                        //       ],
                        //     ),
                        //   ),
                        // ),


                      ],
                    ),
                  ),
                );
              },

              onStackFinished: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Stack Finished"),
                  duration: Duration(milliseconds: 500),
                ));
              },
              itemChanged: (SwipeItem item, int index) {
                print("item: ${item.content.text}, index: $index");
              },
              leftSwipeAllowed: true,
              rightSwipeAllowed: true,
              upSwipeAllowed: false,
              fillSpace: false,
              likeTag: Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey)
                ),
                child: const Text('Like'),
              ),
              nopeTag: Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey)
                ),
                child: const Text('Nope'),
              ),
            ),
          ),
        ),
      ],
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
  } // end build

  // Bottom Navigation bar code
  int _selectedIndex = 0; // Bottom navigation bar index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch(_selectedIndex) {
      case 1:
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MyProfileScreen(title: "My Profile")),
        );
        break;
      case 2:
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MyMatchesScreen(title: "My Matches")),
        );
        break;
    }
  }

} // end _MySwipeScreenState

// Class Content to store the contents of each swipe card
class Content {
  String text;
  String imageURL;
  Content({required this.text, required this.imageURL});
}

// Class Restaurants to create a new instances of the restaurants collection
class Restaurants {
  late String name;
  late String rating;
  late String hours;
  late String type;
  late String iconURL;
  late String imageURL;
  late String description;
  late String pricing;
  late String resID;
  late String elementID;

  Restaurants({required this.name, required this.rating, required this.hours, required this.type,
              required this.iconURL, required this.imageURL, required this.description, required this.pricing,
              required this.resID, required this.elementID});
}

class Users {
  late List<String> matches;
  late String uid;

  Users({required this.uid, required this.matches});
}

// // Class Content to store the contents of each swipe card
// class MenuItems {
//   late String imageURL1;
//   late String imageURL2;
//   late String imageURL3;
//   late String imageURL4;
//   late String imageURL5;
//
//   MenuItems({required this.imageURL1, required this.imageURL2, required this.imageURL3, required this.imageURL4, required this.imageURL5});
// }