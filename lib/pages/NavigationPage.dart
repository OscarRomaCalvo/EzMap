import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:location/location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:ez_maps/customWidgets/EndRouteWidget.dart';
import 'package:ez_maps/customWidgets/MLNavigation/MLNavigationWidget.dart';
import 'package:ez_maps/customWidgets/MetroNavigation/MetroNavigationWidget.dart';
import 'package:ez_maps/customWidgets/NavigationWidget.dart';

import '../models/RoutePoint.dart';

class NavigationPage extends StatefulWidget {
  NavigationPage({Key? key, required this.routeName, required this.iniLocation})
      : super(key: key);

  final String routeName;
  final LocationData iniLocation;

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late LocationData _currentLocation;
  double _mapRotation = 0.0;
  late MapController _mapController;
  late Timer _locationTimer;

  final _routeOrigin = {
    'pointName': 'Casa',
    'latitude': 40.642825,
    'longitude': -3.159397
  };

  final _routeDestination = {
    "pointName": "Instituto Aguas Vivas",
    "latitude": 40.640210,
    "longitude": -3.159549,
    "image":
        "https://st.depositphotos.com/1001311/3411/i/450/depositphotos_34119767-stock-photo-3d-golden-number-collection-1.jpg"
  };

  bool _completedLoad = false;
  int _index = 0;
  List<RoutePoint> _routeWaypoints = [];
  var _routeSteps = [];
  PolylinePoints _polylinePoints = PolylinePoints();
  List<LatLng> _polylineCoordinates = [];
  StreamSubscription<LocationData>? _locationSubscription;
  StreamSubscription<CompassEvent>? _compassSubscription;
  bool _isOnWalkNavigation = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getRouteInformation();
    setState(() {
      _currentLocation = widget.iniLocation;
    });
  }

  void _getRouteInformation() {
    List<RoutePoint> routeWaypoints = [];
    _firestore
        .collection("routes")
        .doc("idUsuario1")
        .collection(widget.routeName)
        .doc("infoRoute")
        .get()
        .then((event) {
      _routeSteps = event.data()?["steps"];
      event.data()?["waypoints"].forEach((waypoint) {
        RoutePoint routePoint = RoutePoint(
            name: waypoint["name"],
            type: waypoint["type"],
            pointImage: waypoint["pointImage"],
            location: waypoint["location"]);

        routeWaypoints.add(routePoint);
      });

      setState(() {
        _routeSteps = _routeSteps;
        _routeWaypoints = routeWaypoints;
        _completedLoad = true;
      });

      _getRoute();
    });
  }

  void _subscribeToLocationChanges() {
    var locationService = Location();
    double distance = 0.0;
    _locationSubscription =
        locationService.onLocationChanged.listen((LocationData newLocation) {
      setState(() {
        _currentLocation = newLocation;
        LatLng newLatLng =
            LatLng(_currentLocation.latitude!, _currentLocation.longitude!);
        _currentLocation = newLocation;
        _mapController.move(newLatLng, 18);
        if (_polylineCoordinates.length > 1) {
          distance = const Distance()
              .as(LengthUnit.Meter, _polylineCoordinates[1], newLatLng);
          _polylineCoordinates[0] = newLatLng;
          if (distance < 10) {
            _polylineCoordinates.removeAt(1);
          }
        }
      });
    });
  }

  void _getRoute() {
    String currentLocationStr =
        "${_currentLocation.longitude!}%2C${_currentLocation.latitude!}%3B";
    String nextStepStr =
        "${_routeWaypoints[_index].location.longitude}%2C${_routeWaypoints[_index].location.latitude}";
    http
        .get(Uri.parse(
            "https://api.mapbox.com/directions/v5/mapbox/walking/$currentLocationStr$nextStepStr?alternatives=false&continue_straight=true&geometries=polyline&overview=full&steps=false&access_token=sk.eyJ1Ijoib3NjYXJybyIsImEiOiJjbHN4bGM2cWowNDlpMmpvNWZ4aHU5NnRnIn0.qd21NR_okn06OeHnjrhqFA"))
        .then((response) {
      var jsonResponse = jsonDecode(response.body);
      String routeGeometry = jsonResponse["routes"][0]["geometry"];
      List<LatLng> routeCoordinates = _decodePolyline(routeGeometry);
      setState(() {
        _polylineCoordinates = routeCoordinates;
      });
    });
  }

  List<LatLng> _decodePolyline(String routeGeometry) {
    List<PointLatLng> pointLatLngCoordinates =
        _polylinePoints.decodePolyline(routeGeometry);
    List<LatLng> convertedCoordinates = pointLatLngCoordinates
        .map((PointLatLng pointLatLng) =>
            LatLng(pointLatLng.latitude, pointLatLng.longitude))
        .toList();
    return convertedCoordinates;
  }

  void _suscribeToCompassChanges() {
    _compassSubscription = FlutterCompass.events?.listen((CompassEvent event) {
      var heading = event.heading ?? 0.0;
      double newRotation = 360 - heading;
      double diffRotation = (_mapRotation - newRotation).abs();
      if (diffRotation > 0.1) {
        print("ENTRA");
        setState(() {
          _mapRotation = newRotation;
          _mapController.rotate(newRotation);
        });
      }
    });
  }

  void _continueRoute() {
    setState(() {
      _index++;
    });
    if (_isOnWalkNavigation && _index < _routeWaypoints.length) {
      _getRouteInformation();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_completedLoad) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Color(0xFF4791DB)),
        )),
      );
    } else {
      if (_index < _routeWaypoints.length) {
        RoutePoint actualPoint = _routeWaypoints[_index];
        switch (actualPoint.type) {
          case 'reference' || 'destination':
            if (!_isOnWalkNavigation) {
              setState(() {
                _isOnWalkNavigation = true;
              });
              _getRouteInformation();
              _subscribeToLocationChanges();
              _suscribeToCompassChanges();
              _locationTimer =
                  Timer.periodic(const Duration(seconds: 30), (timer) {
                //TODO: quitar el comentario, solo está durante el desarrollo.
                //_getRoute();
                print("Coger Route");
              });
            }
            return NavigationWidget(
                completedLoad: _completedLoad,
                index: _index,
                routeSteps: _routeSteps,
                routeWaypoints: _routeWaypoints,
                continueRoute: _continueRoute,
                mapController: _mapController,
                polylineCoordinates: _polylineCoordinates,
                currentLocation: _currentLocation,
                mapRotation: _mapRotation,
                destination: _routeDestination);
          case 'metro':
            if (_isOnWalkNavigation) {
              _locationSubscription!.pause();
              _compassSubscription!.pause();
              _locationTimer.cancel();
              _isOnWalkNavigation = false;
            }
            return MetroNavigationWidget(
                actualPoint.name, _routeSteps[_index], _continueRoute);
          case 'ml':
            if (_isOnWalkNavigation) {
              _locationSubscription!.pause();
              _compassSubscription!.pause();
              _locationTimer.cancel();
              _isOnWalkNavigation = false;
            }
            return MLNavigationWidget(
                actualPoint.name, _routeSteps[_index], _continueRoute);
          default:
            return const Text("Allgo ha fallado");
        }
      } else {
        return EndRouteWidget(_routeDestination);
      }
    }
  }
}
