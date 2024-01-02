import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/global/global_var.dart';
import 'package:final_project/map/googlepam.dart';
import 'package:final_project/pages/profile.dart';
import 'package:final_project/pages/setting.dart';
import 'package:final_project/pages/share_location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: btnav());
  }
}

class btnav extends StatefulWidget {
  const btnav({super.key});

  @override
  State<btnav> createState() => _btnavState();
}

class _btnavState extends State<btnav> {
  PageController _controller = PageController();
  int _selectedIndex = 0;

  //////////////////////////////////////////////////
  ///add to mygoup set in global variables

  void initState() {
    super.initState();
    checkAndReadMyGroupKey();
  }

  Future<void> checkAndReadMyGroupKey() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String collectionPath = 'location/${currentUser!.uid}/mygroupkey';
    bool myGroupKeyExists = await doesCollectionExist(collectionPath);

    if (myGroupKeyExists) {
      // Collection exists, read data and save to mygroup set
      await readAndSaveMyGroupKey(collectionPath);
    } else {
      // Collection does not exist
      print('MyGroupKey collection does not exist.');
    }
  }

  Future<void> readAndSaveMyGroupKey(String collectionPath) async {
    try {
      // read all data in the key doc
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection(collectionPath)
              .doc('keys')
              .get();

      if (documentSnapshot.exists) {
        // Read data and save to mygroup set
        Map<String, dynamic> data = documentSnapshot.data() ?? {};
        mygroup.addAll(Set<String>.from(data['stringValue'] ?? []));
        // for (String element in mygroup) {
        //   print('Element: $element');
        // }
      } else {
        print('Document "keys" does not exist in MyGroupKey collection.');
      }
    } catch (error) {
      print('Error reading and saving MyGroupKey data: $error');
    }
  }

  // check if the collection exist meaning do i have a shared key availible
  Future<bool> doesCollectionExist(String collectionPath) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(collectionPath)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (error) {
      print('Error checking collection existence: $error');
      return false;
    }
  }

  ///////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: PageView(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [sharelocation(), googlemap(), profile(), setting()],
      )),
      bottomNavigationBar: Container(
        color: const Color.fromRGBO(0, 226, 193, 1),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
              gap: 8,
              backgroundColor: Color.fromRGBO(0, 226, 193, 1),
              color: Colors.white,
              activeColor: Color.fromRGBO(255, 255, 255, 1),
              tabBackgroundColor: Colors.black,
              padding: EdgeInsets.all(15),
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                  _controller.animateToPage(index,
                      duration: Duration(microseconds: 300),
                      curve: Curves.ease);
                });
              },
              tabs: [
                GButton(icon: Icons.search, text: "Search"),
                GButton(icon: Icons.location_on_outlined, text: "Map"),
                GButton(icon: Icons.person_2_outlined, text: "Profile"),
                GButton(icon: Icons.settings_outlined, text: "Setting"),
              ]),
        ),
      ),
    );
  }
}
