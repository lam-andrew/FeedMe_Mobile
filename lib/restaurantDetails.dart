import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'matches.dart';

class MyDetailsScreen extends StatefulWidget {

  const MyDetailsScreen({super.key, required this.title, required this.matchItem});
  final Matches matchItem;
  final String title;
  // widget.foodItem['name'].toString() <-- to get the item from the previous page
  // Flutter http library to call third party API like Yelp
  //jsonDecode(value.body) <-- convert json string file into a list for foodItems[]
  @override
  State<MyDetailsScreen> createState() => _MyDetailsScreenState();
}

class _MyDetailsScreenState extends State<MyDetailsScreen> {
  late List menuItems = List.empty();

  // Get each matched restaurant's info
  Future getMatchInfo() async {
    // Load the data from the restaurants collection
    CollectionReference collectionRef2 = FirebaseFirestore.instance.collection("restaurants");
    await collectionRef2.get().then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        // loop through and check for the correct restaurant
        if(element['resID'] == widget.matchItem.id) {
          // convert the resMenuItems array into the menuItems List
          menuItems = element['resMenuItems'];
        }
        setState(() {});
      }
    });
  } // end getMatchInfo

  @override
  void initState() {
    super.initState();
    setState(() {});
    getMatchInfo().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color.fromRGBO(244,	244,	244	, 1),
      appBar: AppBar(
      ),

      body: Center(
        child: Column (
          children: [
            Expanded(
              flex: 25,
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    // image: NetworkImage(widget.matchItem['imageURL'].toString()),
                    image: NetworkImage(widget.matchItem.imageURL.toString()),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),


            Expanded(
              flex: 40,
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      // widget.matchItem['name'].toString(),
                      widget.matchItem.name,
                      style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(
                        // widget.matchItem['description'].toString(),
                        widget.matchItem.description,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const Text(
                        "Info",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            height: 25,
                            child: const Text("Hours"),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(widget.matchItem.hours),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            height: 25,
                            child: const Text("Rating"),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(widget.matchItem.rating),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),


            Expanded(
              flex: 35,
              child: Container(
                margin: const EdgeInsets.only(bottom: 50),
                child: Column(
                  children: [
                    if(menuItems.isNotEmpty) ...[
                      const Text(
                        "Menu Items",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        height: 175,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            SizedBox(
                              child: Image(
                                image: NetworkImage(menuItems[0]),
                              ),
                            ),
                            SizedBox(
                              child: Image(
                                image: NetworkImage(menuItems[1]),
                              ),
                            ),
                            SizedBox(
                              child: Image(
                                image: NetworkImage(menuItems[2]),
                              ),
                            ),
                            SizedBox(
                              child: Image(
                                image: NetworkImage(menuItems[3]),
                              ),
                            ),
                            SizedBox(
                              child: Image(
                                image: NetworkImage(menuItems[4]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}