import 'package:cloud_firestore/cloud_firestore.dart';

class RoutePoint {
  String name;
  String type;
  String pointImage;
  GeoPoint location;

  RoutePoint(
      {required this.name,
      required this.type,
      required this.pointImage,
      required this.location});
}
