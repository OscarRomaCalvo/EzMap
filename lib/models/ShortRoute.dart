import 'RoutePoint.dart';

class ShortRoute{
  String routeName;
  RouteWaypoint origin;
  RouteWaypoint destination;

  ShortRoute({required this.routeName, required this.origin, required this.destination});
}