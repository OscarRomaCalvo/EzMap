import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:location/location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:prueba_ezmaps_estatica/customWidgets/EndRouteWidget.dart';
import 'package:prueba_ezmaps_estatica/customWidgets/MLNavigation/MLNavigationWidget.dart';
import 'package:prueba_ezmaps_estatica/customWidgets/MetroNavigation/MetroNavigationWidget.dart';
import 'package:prueba_ezmaps_estatica/customWidgets/NavigationWidget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Asegura la inicialización de Flutter

  //PRELOAD JSON DATA (ROUTE AND STEPS)
  String routeJsonString = await rootBundle.loadString('assets/routePoints.json');
  String stepsJsonString = await rootBundle.loadString('assets/steps.json');

  var routeData = json.decode(routeJsonString);
  var stepsData = json.decode(stepsJsonString);

  //PRELOAD INITIAL LOCATION
  var locationService = Location();
  var iniLocation = await locationService.getLocation();

  runApp(MyApp(routeData, stepsData, iniLocation));
}
class MyApp extends StatelessWidget {
  final routeData;
  final stepsData;
  final iniLocation;

  const MyApp(this.routeData, this.stepsData, this.iniLocation);
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: NavigationPage(title: 'Flutter Demo Home Page', routeData: routeData, stepsData: stepsData, iniLocation: iniLocation),
    );
  }
}

class NavigationPage extends StatefulWidget {
  NavigationPage({Key? key, required this.title, required this.routeData, required this.stepsData, required this.iniLocation}) : super(key: key);
  final String title;
  final routeData;
  final stepsData;
  final iniLocation;

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  late LocationData _currentLocation;
  double _heading = 0.0;
  double _mapRotation = 0.0;
  late MapController _mapController;
  late Timer _locationTimer;

  String _getLocationCompleted = "melon";
  String _loadJSONCompleted = "sandia";

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
  StreamSubscription<LocationData>? _locationSubscription;
  StreamSubscription<CompassEvent>? _compassSubscription;
  bool _isOnWalkNavigation = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
      setState(() {
        _currentLocation = widget.iniLocation;
        _getLocationCompleted = "completada";
        _exampleSteps= widget.stepsData;
        _exampleRoute= widget.routeData;
        _loadJSONCompleted = "completada";
        _completedLoad = true;
      });
  }

  Future<void> _getLocation() async {
    var locationService = Location();
    var newLocation = await locationService.getLocation();
    setState(() {
      _currentLocation = newLocation;
      _getLocationCompleted = "completada";
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

  void _subscribeToLocationChanges() {
    var locationService = Location();
    double distance = 0.0;
    _locationSubscription =
        locationService.onLocationChanged.listen((LocationData newLocation) {
      setState(() {
        _currentLocation = newLocation;
        LatLng newLatLng =
            LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
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

  void _suscribeToCompassChanges() {
    _compassSubscription = FlutterCompass.events?.listen((CompassEvent event) {
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
    });
    if (_isOnWalkNavigation && _index < _exampleRoute.length) {
      _getRoute();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_completedLoad) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("GET POSITION = $_getLocationCompleted"),
            Text("GET JSON = $_loadJSONCompleted"),
            CircularProgressIndicator(),
          ],
        ),
      );
    } else {
      if (_index < _exampleRoute.length) {
        switch (_exampleRoute[_index]['type']) {
          case 'reference' || 'destination':
            if (!_isOnWalkNavigation) {
              setState(() {
                _isOnWalkNavigation = true;
              });
              _getRoute();
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
                exampleSteps: _exampleSteps,
                exampleRoute: _exampleRoute,
                continueRoute: _continueRoute,
                mapController: _mapController,
                polylineCoordinates: _polylineCoordinates,
                currentLocation: _currentLocation!,
                mapRotation: _mapRotation,
                destination: _routeDestination);
          case 'metro':
            if (_isOnWalkNavigation) {
              _locationSubscription!.pause();
              _compassSubscription!.pause();
              _locationTimer.cancel();
              _isOnWalkNavigation = false;
            }
            return MetroNavigationWidget(_exampleRoute[_index]["pointName"],
                _exampleSteps[_index], _continueRoute);
          case 'ml':
            if (_isOnWalkNavigation) {
              _locationSubscription!.pause();
              _compassSubscription!.pause();
              _locationTimer.cancel();
              _isOnWalkNavigation = false;
            }
            return MLNavigationWidget(_exampleRoute[_index]["pointName"],
                _exampleSteps[_index], _continueRoute);
          default:
            return const Text("Allgo ha fallado");
        }
      } else {
        return EndRouteWidget(_routeDestination);
      }
    }
  }
}
