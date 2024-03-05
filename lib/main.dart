import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:location/location.dart';
import 'package:prueba_ezmaps_estatica/customWidgets/CustomButton.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:prueba_ezmaps_estatica/customWidgets/EndRouteWidget.dart';
import 'package:prueba_ezmaps_estatica/customWidgets/NavigationWidget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LocationData? _currentLocation;
  double _heading = 0.0;
  double _mapRotation = 0.0;
  late MapController _mapController;

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
  var _exampleRoute = [];
  var _exampleSteps = [];
  PolylinePoints _polylinePoints = PolylinePoints();
  List<LatLng> _polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getLocation();
      await _loadJSON();
      _getCompassHeading();
      _getRoute();
      _completedLoad = true;
      /*
      DESHABILITADO DURANTE EL DESARROLLO PARA NO HACER PETICIONES INNECESARIAS
      Timer _timer = Timer.periodic(Duration(seconds: 45), (timer) {
        _getRoute();
      });
      */
    });
  }

  Future<void> _loadJSON() async {
    String routeJsonString =
        await rootBundle.loadString('assets/routePoints.json');
    String stepsJsonString = await rootBundle.loadString('assets/steps.json');

    var routeData = json.decode(routeJsonString);
    var stepsData = json.decode(stepsJsonString);
    setState(() {
      _exampleRoute = routeData;
      _exampleSteps = stepsData;
    });
  }

  void _getRoute() {
    String currentLocationStr =
        "${_currentLocation!.longitude!}%2C${_currentLocation!.latitude!}%3B";
    String nextStepStr =
        "${_exampleRoute[_index]['longitude']}%2C${_exampleRoute[_index]['latitude']}";
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

  Future<void> _getLocation() async {
    var locationService = Location();
    _currentLocation = await locationService.getLocation();

    locationService.onLocationChanged.listen((LocationData newLocation) {
      setState(() {
        _currentLocation = newLocation;
        LatLng newLatLng =
            LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
        double distance = const Distance()
            .as(LengthUnit.Meter, _polylineCoordinates[1], newLatLng);
        setState(() {
          _currentLocation = newLocation;
          _mapController.move(newLatLng, 18);
          _polylineCoordinates[0] = newLatLng;
          if (distance < 10) {
            _polylineCoordinates.removeAt(1);
          }
        });
      });
    });
  }

  Future<void> _getCompassHeading() async {
    FlutterCompass.events?.listen((event) {
      setState(() {
        _heading = event.heading ?? 0.0;
        double newRotation = 360 - _heading;
        double diffRotation = (_mapRotation - newRotation).abs();
        if (diffRotation > 1.0) {
          _mapRotation = newRotation;
          _mapController.rotate(newRotation);
        }
      });
    });
  }

  void _continueRoute() {
    setState(() {
      _index++;
      _getRoute();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_completedLoad) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      if (_index < _exampleRoute.length) {
        switch (_exampleRoute[_index]['type']) {
          case 'reference' || 'destination':
            return NavigationWidget(
                completedLoad: _completedLoad,
                index: _index,
                exampleSteps: _exampleSteps,
                exampleRoute: _exampleRoute,
                continueRoute: _continueRoute,
                mapController: _mapController,
                polylineCoordinates: _polylineCoordinates,
                currentLocation: _currentLocation!,
                mapRotation: _mapRotation);
          case 'ejemplo':
            return CustomButton("hola", _continueRoute, true);
          default:
            return Text("Allgo ha fallado");
        }
      } else {
        return EndRouteWidget(_routeDestination);
      }
    }
  }
}
