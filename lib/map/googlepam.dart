import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/global/global_var.dart';
import 'package:final_project/map/polyline.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:final_project/utility/loading_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';

class googlemap extends StatefulWidget {
  const googlemap({super.key});

  @override
  State<googlemap> createState() => _googlemapState();
}

class _googlemapState extends State<googlemap> {
  final Completer<GoogleMapController> googleMapCompletedController =
      Completer<GoogleMapController>();
  poly pol = poly();
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;
  LatLng? currentPostionOfUserLatLng;
  GoogleMapController? controllerGoogleMap;
  late BuildContext loadingDialogContext;
  Position? currentPostionOfUser;
  final Set<Marker> _marker = {};
  bool isLoading = true;

  void updateMapTheme(GoogleMapController controller) {
    if (mapstyle != null &&
        mapstyle.isNotEmpty &&
        mapstyle != "standard_style") {
      getJsonFileFromThemes("themes/" + mapstyle + ".json")
          .then((value) => setGoogleMapStyle(value, controller));
    }
  }

  Future<String> getJsonFileFromThemes(String mapStylePath) async {
    ByteData byteData = await rootBundle.load(mapStylePath);
    var list = byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    return utf8.decode(list);
  }

  setGoogleMapStyle(String googleMapStyle, GoogleMapController controller) {
    controller.setMapStyle(googleMapStyle);
  }

  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) {
      setState(() {
        currentPostionOfUserLatLng =
            LatLng(currentlocation.latitude!, currentlocation.longitude!);
        getCurrentLiveLocationOfUser();
      });
      User? user = FirebaseAuth.instance.currentUser;
      String? uid = user?.uid;
      FirebaseFirestore.instance.collection('location').doc(uid).set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
      }, SetOptions(merge: true));
      print(
        currentlocation.latitude,
      );
      _marker.add(
        Marker(
          markerId: MarkerId(uid!),
          position:
              LatLng(currentlocation.latitude!, currentlocation.longitude!),
        ),
      );
      print(">>>>>>.-------${currentlocation.latitude}----------->>>>>>>>>>.");
      marker(currentlocation);
      if (isLoading) {
        print(">>>>>>>>>>>>>>>>>>>>>>>//");
        Navigator.of(loadingDialogContext).pop();
        isLoading = false;
      }
    });
  }

  // find friend shared key by adding it to the mygroup set and then saving it to the firestore so that the data isn't erased

  Future<void> showAlert(BuildContext context) async {
    String enteredString = '';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // backgroundColor: Colors.white,
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.949),
          title: Text('Enter Shared Key'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                'lib/images/vec5.png', // Replace with your image path
                width: 150, // Adjust image width as needed
              ),
              SizedBox(height: 16), // Adjust spacing as needed

              TextField(
                onChanged: (value) {
                  enteredString = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                mygroup.add(enteredString);

                saveSetToFirestore(mygroup);

                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Function to save the entire my group set to Firestore
  Future<void> saveSetToFirestore(Set<String> mygroup) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentReference documentRef = FirebaseFirestore.instance
          .collection('location')
          .doc(currentUser!.uid)
          .collection('mygroupkey')
          .doc('keys');

      // Update the document with the new set
      documentRef.set({'stringValue': mygroup.toList()});
    }
  }

  marker(LocationData currentlocation) {
    List<String> groupsToRemove = [];
    LatLng currentPostionOfUser = LatLng(
        currentlocation.latitude ?? 0.0, currentlocation.longitude ?? 0.0);
    print("------------------ll---lll");
    if (mygroup.isNotEmpty) {
      print("------kkkk------------ll---lll");
      for (String groupKey in mygroup) {
        print(";;;;;;;;;;;;;;;;;;;;;;;;;$groupKey");
        FirebaseFirestore.instance
            .collection('location')
            .doc(groupKey)
            .get()
            .then((DocumentSnapshot<Map<String, dynamic>> snapshot) async {
          if (snapshot.exists) {
            double latitude = snapshot.data()?['latitude'] ?? 0.0;
            double longitude = snapshot.data()?['longitude'] ?? 0.0;
            print("Element:}]]]]]]]]]]]]]]]]]]]]]]]]]pp");
            print(latitude);
            print(longitude);
            _marker.add(
              Marker(
                markerId: MarkerId(groupKey), // Using the groupKey directly
                position: LatLng(latitude, longitude),
              ),
            );

            // Polyline polyline = await pol.getRoutePolyline(
            //   start: LatLng(latitude, longitude),
            //   finish:
            //       LatLng(currentlocation.latitude!, currentlocation.longitude!),
            //   id: groupKey,
            // );
            // polylines.add(polyline);
          } else {
            print("Document does not exist for$groupKey");
            mygroup.remove(groupKey);
          }
        }).catchError((error) {
          print("Error getting document: $error");
        });
      }
      // delete mygroup data that is not available in the firestore
      // for (String groupKeyToRemove in groupsToRemove) {
      //   print("qqqqqqqqqqqqqqqqqqqqqq$groupKeyToRemove");
      //   mygroup.remove(groupKeyToRemove);
      // }
    } else {
      print(".............");
      // If mygroup is empty, delete the mygroupkey collection becouse there is no shared key available
      User? currentUser = FirebaseAuth.instance.currentUser;
      CollectionReference myGroupKeyCollection = FirebaseFirestore.instance
          .collection('location')
          .doc(currentUser!.uid)
          .collection('mygroupkey');

      Future<void> checkAndDeleteSubcollection() async {
        try {
          QuerySnapshot<Object?> snapshot = await myGroupKeyCollection.get();

          if (snapshot.docs.isNotEmpty) {
            // Subcollection exists, delete its documents
            for (QueryDocumentSnapshot<Object?> doc in snapshot.docs) {
              await doc.reference.delete();
            }
            print("Subcollection 'mygroupkey' deleted successfully.");
          } else {
            print("Subcollection 'mygroupkey' does not exist.");
          }
        } catch (error) {
          print("Error checking and deleting subcollection: $error");
        }
      }

// Call the function
      checkAndDeleteSubcollection();
    }
  }

  void initState() {
    super.initState();
    _listenLocation();
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          loadingDialogContext = context;
          return loadingDialiog(messageText: "Loading The Map...");
        },
      );
    });
  }

  getCurrentLiveLocationOfUser() {
    if (currentPostionOfUserLatLng != null) {
      try {
        CameraPosition cameraPosition =
            CameraPosition(target: currentPostionOfUserLatLng!, zoom: 17);
        controllerGoogleMap!
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      } catch (e) {
        print('Error in getCurrentLiveLocationOfUser: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
      children: [
        GoogleMap(
          padding: const EdgeInsets.only(bottom: 130),
          mapType: MapType.normal,
          myLocationEnabled: true,
          initialCameraPosition: googlePlexInitialPosition,
          markers: _marker,
          // polylines: polylines,
          onMapCreated: (GoogleMapController mapController) {
            controllerGoogleMap = mapController;
            updateMapTheme(controllerGoogleMap!);
            googleMapCompletedController.complete(controllerGoogleMap);
            getCurrentLiveLocationOfUser();
          },
        ),

        //add alert
        Positioned(
          left: 0,
          right: 0,
          bottom: 30,
          child: Container(
            height: 90,
            child: ElevatedButton(
              onPressed: () {
                showAlert(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(24),
              ),
              child: Icon(
                Icons.add_circle_outline,
                color: Colors.white,
                size: 45,
              ),
            ),
          ),
        )
      ],
    ));
  }
}
