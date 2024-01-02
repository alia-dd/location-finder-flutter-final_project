import 'dart:ui';

import 'package:final_project/global/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class poly {
  Future<Polyline> getRoutePolyline({
    required LatLng start,
    required LatLng finish,
    Color myColor = Colors.red,
    required String id,
    int width = 6,
  }) async {
    // Generates every polyline between start and finish
    final polylinePoints = PolylinePoints();
    // Holds each polyline coordinate as Lat and Lng pairs
    final List<LatLng> polylineCoordinates = [];

    final startPoint = PointLatLng(start.latitude, start.longitude);
    final finishPoint = PointLatLng(finish.latitude, finish.longitude);
    print("[[[[[[[[[[[[[[[[[[[[[[[[[[[object]]]]]]]]]]]]]]]]]]]]]]]]]]]");
    print(",,,,,$startPoint");
    print(",,,,,$finishPoint");
    final result = await polylinePoints.getRouteBetweenCoordinates(
      directionkey, // Replace with your actual API key
      startPoint,
      finishPoint,
    );
    print("Result Points: ${result.points}");
    print("API Request: ${result.errorMessage}");
    if (result.points.isNotEmpty) {
      print("[-------------------[object]]]]------------------------]");
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      });
    }
    final polyline = Polyline(
      polylineId: PolylineId(id),
      color: myColor,
      // points: polylineCoordinates,
      width: width,
    );
    return polyline;
  }
}
