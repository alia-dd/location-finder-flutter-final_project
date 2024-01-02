import 'package:google_maps_flutter/google_maps_flutter.dart';

String googleMapKey = "AIzaSyCiQ-KBQaMce6ZIcHbboGnp5aXWh19DlqA";
String directionkey = "AIzaSyDpYqsG0931if57LWGKZ5XCelDpLhaSM5k";

const CameraPosition googlePlexInitialPosition = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414);

String useId = "";
String mapstyle = "";
String userName = "";
String email = "";
String fullName = "";
String phone = "";
String imageUrl = "";

String mylocationkey = "";
final Set<String> mygroup = {};
final Set<Polyline> polylines = {};
bool isDarkMode = true;
