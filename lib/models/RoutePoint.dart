import 'package:cloud_firestore/cloud_firestore.dart';

import 'RoutePointTypes.dart';

class RoutePoint{
  String name;
  RoutePointTypes type;
  String pointImage;
  GeoPoint location;

  RoutePoint({required this.name,this.type=RoutePointTypes.reference, required this.pointImage, required this.location});
}