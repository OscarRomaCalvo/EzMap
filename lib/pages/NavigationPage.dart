import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:ez_maps/customWidgets/MLNavigation/MLNavigationWidget.dart';
import 'package:ez_maps/customWidgets/MetroNavigation/MetroNavigationWidget.dart';
import 'package:ez_maps/customWidgets/NavigationWidget.dart';

import 'package:provider/provider.dart';

import '../customWidgets/NextStepPopUp.dart';
import '../customWidgets/ProgressBar.dart';
import '../models/RoutePoint.dart';
import '../services/AuthService.dart';
import 'EndRoutePage.dart';

class NavigationPage extends StatefulWidget {
  NavigationPage({Key? key, required this.routeName, required this.iniLocation})
      : super(key: key);

  final String routeName;
  final Position iniLocation;

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Position _currentLocation;
  double _mapRotation = 0.0;
  late MapController _mapController;
  late Timer _locationTimer;

  bool _completedLoad = false;
  int _index = 0;
  List<RouteWaypoint> _routeWaypoints = [];
  var _routeSteps = [];
  PolylinePoints _polylinePoints = PolylinePoints();
  List<LatLng> _polylineCoordinates = [];
  StreamSubscription<Position>? _locationSubscription;
  StreamSubscription<CompassEvent>? _compassSubscription;
  bool _isOnWalkNavigation = false;
  bool _isNewStep = true;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getRouteInformation();
    setState(() {
      _currentLocation = widget.iniLocation;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _locationSubscription!.cancel();
    _compassSubscription!.cancel();
    _locationTimer.cancel();
  }

  void _getRouteInformation() {
    final AuthService authService =
        Provider.of<AuthService>(context, listen: false);
    User? user = authService.user;

    if (user != null) {
      List<RouteWaypoint> routeWaypoints = [];
      _firestore
          .collection("routes")
          .doc(user.email)
          .collection(widget.routeName)
          .doc("infoRoute")
          .get()
          .then((event) {
        _routeSteps = event.data()?["steps"];
        event.data()?["waypoints"].forEach((waypoint) {
          RouteWaypoint routePoint = RouteWaypoint(
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
  }

  void _subscribeToLocationChanges() {
    double distance = 0.0;
    _locationSubscription =
        Geolocator.getPositionStream().listen((Position newLocation) {
      setState(() {
        _currentLocation = newLocation;
        LatLng newLatLng =
            LatLng(_currentLocation.latitude, _currentLocation.longitude);
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
        "${_currentLocation.longitude}%2C${_currentLocation.latitude}%3B";
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
        setState(() {
          _mapRotation = newRotation;
          _mapController.rotate(newRotation);
        });
      }
    });
  }

  void _continueRoute() {
    if (_index == _routeSteps.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => EndRoutePage(
                _routeWaypoints[_index].pointImage,
                _routeWaypoints[_index].name)),
      );
    } else {
      setState(() {
        _index++;
        _isNewStep = true;
      });
    }
  }

  bool _isFarFromPoint() {
    LatLng currentLatLng =
        LatLng(_currentLocation.latitude, _currentLocation.longitude);
    LatLng nextStepLatLng = LatLng(_routeWaypoints[_index].location.latitude,
        _routeWaypoints[_index].location.longitude);
    double distance =
        const Distance().as(LengthUnit.Meter, currentLatLng, nextStepLatLng);
    return distance > 20;
  }

  Widget _renderPage() {
    RouteWaypoint actualPoint = _routeWaypoints[_index];
    switch (actualPoint.type) {
      case 'reference' || 'destination':
        if (_isNewStep == true) {
          _getRoute();
          setState(() {
            _isNewStep = false;
          });
        }
        if (!_isOnWalkNavigation) {
          setState(() {
            _isOnWalkNavigation = true;
          });
          _subscribeToLocationChanges();
          _suscribeToCompassChanges();
          _locationTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
            //TODO: quitar el comentario, solo está durante el desarrollo.
            //_getRoute();
            print("Coger Route");
          });
        }
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 25, left: 25, right: 25, bottom: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ProgressBar(
                    totalSteps: _routeWaypoints.length,
                    currentStep: _index,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: NavigationWidget(
                        completedLoad: _completedLoad,
                        index: _index,
                        routeSteps: _routeSteps,
                        routeWaypoints: _routeWaypoints,
                        continueRoute: _continueRoute,
                        mapController: _mapController,
                        polylineCoordinates: _polylineCoordinates,
                        currentLocation: _currentLocation,
                        mapRotation: _mapRotation,
                        destination:
                            _routeWaypoints[_routeWaypoints.length - 1]),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NextStepPopUp(
                  _routeWaypoints[_index].name,
                  _routeWaypoints[_index].pointImage,
                  _routeWaypoints[_index].type,
                  _isFarFromPoint(),
                  _continueRoute,
                ),
              ],
            ),
          ),
        );
      case 'metro':
        if (_isOnWalkNavigation) {
          _locationSubscription!.pause();
          _compassSubscription!.pause();
          _locationTimer.cancel();
          _isOnWalkNavigation = false;
        }
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ProgressBar(
                    totalSteps: _routeWaypoints.length,
                    currentStep: _index,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: MetroNavigationWidget(
                        actualPoint.name, _routeSteps[_index], _continueRoute),
                  ),
                ],
              ),
            ),
          ),
        );
      case 'ml':
        if (_isOnWalkNavigation) {
          _locationSubscription!.pause();
          _compassSubscription!.pause();
          _locationTimer.cancel();
          _isOnWalkNavigation = false;
        }
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ProgressBar(
                    totalSteps: _routeWaypoints.length,
                    currentStep: _index,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: MLNavigationWidget(
                        actualPoint.name, _routeSteps[_index], _continueRoute),
                  ),
                ],
              ),
            ),
          ),
        );
      default:
        return const Text("Allgo ha fallado");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_completedLoad) {
      return const Scaffold(
        body: Center(
            child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Color(0xFF4791DB)),
        )),
      );
    } else {
      return _renderPage();
    }
  }
}
