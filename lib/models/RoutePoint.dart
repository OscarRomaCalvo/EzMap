import 'package:cloud_firestore/cloud_firestore.dart';

class RouteWaypoint {
  String name;
  String type;
  String pointImage;
  GeoPoint location;

  RouteWaypoint({
    required this.name,
    required this.type,
    required this.pointImage,
    required this.location,
  });

  RouteWaypoint.fromLongAndLat(
      String name,
      String type,
      String pointImage,
      double longitude,
      double latitude,
      ) : this(
    name: name,
    type: type,
    pointImage: pointImage,
    location: GeoPoint(latitude, longitude),
  );
}
