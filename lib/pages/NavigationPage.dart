import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ez_maps/customWidgets/ImageButton.dart';
import 'package:ez_maps/customWidgets/WarningTimer.dart';
import 'package:ez_maps/exceptions/NoInternetException.dart';
import 'package:ez_maps/models/MetroInstruction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:ez_maps/customWidgets/MLNavigation/MLNavigationWidget.dart';
import 'package:ez_maps/customWidgets/MetroNavigation/MetroNavigationWidget.dart';
import 'package:ez_maps/customWidgets/WalkingNavigation/WalkingNavigationWidget.dart';

import 'package:provider/provider.dart';

import '../customWidgets/BusNavigation/BusNavigationWidget.dart';
import '../customWidgets/NextStepPopUp.dart';
import '../customWidgets/ProgressBar.dart';
import '../models/BusInstruction.dart';
import '../models/Instruction.dart';
import '../models/MLInstruction.dart';
import '../models/RoutePoint.dart';
import '../services/AuthService.dart';
import '../services/RouteTranslator.dart';
import 'EndRoutePage.dart';
import 'ExceptionPage.dart';

class NavigationPage extends StatefulWidget {
  NavigationPage({Key? key, required this.routeName, required this.iniLocation})
      : super(key: key);

  final String routeName;
  final Position iniLocation;

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final String? _mapboxKey = dotenv.env['MAPBOX_KEY'];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Position _currentLocation;
  double _mapRotation = 0.0;
  late MapController _mapController;
  late Timer _locationTimer;
  bool _skipDispose = false;
  bool _completedLoad = false;
  int _index = 0;
  List<RoutePoint> _routeWaypoints = [];
  List<Instruction> _routeInstructions = [];
  PolylinePoints _polylinePoints = PolylinePoints();
  List<LatLng> _polylineCoordinates = [];
  StreamSubscription<Position>? _locationSubscription;
  StreamSubscription<CompassEvent>? _compassSubscription;
  final Connectivity _connectivity = Connectivity();
  bool? _isConnectedToInternet;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isOnWalkNavigation = false;
  bool _isNewStep = true;

  Widget _rightBottomWidget = const SizedBox();
  Duration _warningTimeOut = const Duration(minutes: 1);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    try {
      _getRouteInformation();
    } on Exception catch (e) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ExceptionPage(e)),
      );
    }
    setState(() {
      _currentLocation = widget.iniLocation;
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_skipDispose == false) {
      _locationSubscription!.cancel();
      _compassSubscription!.cancel();
      _connectivitySubscription!.cancel();
      _locationTimer.cancel();
    }
  }

  Future<void> _getRouteInformation() async {
    var checkInternet = await _connectivity.checkConnectivity();
    if (checkInternet.contains(ConnectivityResult.none)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ExceptionPage(NoInternetException())),
      );
    }
    final AuthService authService =
        Provider.of<AuthService>(context, listen: false);
    User? user = authService.user;
    if (user != null) {
      List<RoutePoint> routeWaypoints = [];
      List<Instruction> routeInstructions = [];
      _firestore
          .collection("rutas")
          .doc(user.email)
          .collection(widget.routeName)
          .doc("infoRuta")
          .get()
          .then((event) {
        try {
          if (event.data()?["tiempoEstimado"] is int) {
            int time = event.data()?["tiempoEstimado"];
            if (time != null && time is int){setState(() {
              _warningTimeOut = Duration(minutes: time);
            });}
          }
          Map<String, dynamic> translatedRoute =
              RouteTranslator.translateRoute(event, widget.routeName);
          routeWaypoints = translatedRoute["routeWaypoints"];
          routeInstructions = translatedRoute["routeInstructions"];
          setState(() {
            _routeWaypoints = routeWaypoints;
            _routeInstructions = routeInstructions;
            _completedLoad = true;
          });

          _getRoute();
        } on Exception catch (e) {
          setState(() {
            _skipDispose = true;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ExceptionPage(e)),
          );
        }
      }).onError(
        (error, _) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ExceptionPage(error as Exception)),
        ),
      );
    }
  }

  Future<void> _checkInternetConnection() async {
    if (_isConnectedToInternet == null) {
      final List<ConnectivityResult> result =
          await _connectivity.checkConnectivity();
      if (result.contains(ConnectivityResult.none)) {
        _showConnectivityNoAvailableDialog(context);
      }
    }
  }

  void _subscribeToConnectivityChanges() {
    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      bool? actualState = _isConnectedToInternet;
      bool newState = !result.contains(ConnectivityResult.none);
      if (actualState != newState) {
        setState(() {
          _isConnectedToInternet = newState;
        });
        if (newState == true) {
          setState(() {
            _index = _index;
          });
        }
        if (newState == false) {
          _showConnectivityNoAvailableDialog(context);
        }
      }
    });
  }

  void _subscribeToLocationChanges() {
    double distance = 0.0;
    LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0,
        timeLimit: Duration(seconds: 60));
    _locationSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position newLocation) {
        setState(
          () {
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
          },
        );
      },
      onError: (e) {
        if (e.runtimeType == LocationServiceDisabledException) {
          _showTurnOnLocationDialog(context);
        } else if (e.runtimeType == TimeoutException) {
          _showLocationNoAvailableDialog(context);
        }
      },
    );
  }

  void _getRoute() {
    String currentLocationStr =
        "${_currentLocation.longitude}%2C${_currentLocation.latitude}%3B";
    String nextStepStr =
        "${_routeWaypoints[_index].location.longitude}%2C${_routeWaypoints[_index].location.latitude}";
    http
        .get(Uri.parse(
            "https://api.mapbox.com/directions/v5/mapbox/walking/$currentLocationStr$nextStepStr?alternatives=false&continue_straight=true&geometries=polyline&overview=full&steps=false&access_token=$_mapboxKey"))
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

  void _subscribeToCompassChanges() {
    List<double> lastHeadings = [];
    _compassSubscription = FlutterCompass.events?.listen((CompassEvent event) {
      if (event.heading == null) {
        return;
      }
      var heading = event.heading ?? 0.0;
      lastHeadings.add((heading + 180) % 360);
      if (lastHeadings.length > 3) {
        lastHeadings.removeAt(0);
      }
      double averageHeading =
          lastHeadings.reduce((a, b) => a + b) / lastHeadings.length;
      if ((averageHeading - ((heading + 180) % 360)).abs() < 5.0) {
        setState(() {
          _mapRotation = 360 - heading;
          _mapController.rotate(_mapRotation);
        });
      }
    });
  }

  void _continueRoute() {
    if (_index == _routeInstructions.length - 1) {
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

  void _changeRightBottomWidget(Widget newWidget) {
    setState(() {
      _rightBottomWidget = newWidget;
    });
  }

  void _showConnectivityNoAvailableDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.signal_wifi_connected_no_internet_4_sharp,
                    color: Color(0xFF4791DB),
                    size: 100,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "ERROR",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD32F2F),
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                  const Text(
                    "SE HA PERDIDO LA CONEXIÓN A INTERNET",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ImageButton(
                    imagePath:
                        "assets/images/ARASAACPictograms/refreshButton.png",
                    size: 100,
                    onPressed: () async {
                      if (_isConnectedToInternet == true) {
                        Navigator.of(context).pop();
                        setState(() {
                          _index = _index;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showTurnOnLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_off,
                      color: Color(0xFF4791DB), size: 100),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "ACTIVA LA UBICACIÓN EN EL DISPOSITIVO",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ImageButton(
                      imagePath:
                          "assets/images/ARASAACPictograms/refreshButton.png",
                      size: 100,
                      onPressed: () async {
                        bool serviceEnabled =
                            await Geolocator.isLocationServiceEnabled();
                        if (serviceEnabled) {
                          Navigator.of(context).pop();
                        }
                      }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLocationNoAvailableDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_off,
                      color: Color(0xFF4791DB), size: 100),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "ERROR",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD32F2F),
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                  const Text(
                    "SE HA PERDIDO EL ACCESO A LA UBICACIÓN",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ImageButton(
                      imagePath:
                          "assets/images/ARASAACPictograms/refreshButton.png",
                      size: 100,
                      onPressed: () async {
                        bool serviceEnabled =
                            await Geolocator.isLocationServiceEnabled();
                        if (serviceEnabled) {
                          try {
                            await Geolocator.getCurrentPosition();
                            _subscribeToLocationChanges();
                            Navigator.of(context).pop();
                          } catch (e) {}
                        }
                      }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _renderPage() {
    RoutePoint actualPoint = _routeWaypoints[_index];
    switch (actualPoint.type) {
      case 'pie' || 'destino':
        if (_isNewStep == true) {
          _getRoute();
          setState(() {
            _isNewStep = false;
            _rightBottomWidget = NextStepPopUp(
              _routeWaypoints[_index].name,
              _routeWaypoints[_index].pointImage,
              _routeWaypoints[_index].type,
              _isFarFromPoint,
              _continueRoute,
            );
          });
          _checkInternetConnection();
        }
        if (!_isOnWalkNavigation) {
          setState(() {
            _isOnWalkNavigation = true;
          });
          _subscribeToLocationChanges();
          _subscribeToCompassChanges();
          _subscribeToConnectivityChanges();
          _locationTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
            _getRoute();
          });
        }
        return Expanded(
          child: WalkingNavigationWidget(
              completedLoad: _completedLoad,
              index: _index,
              routeInstructions: _routeInstructions,
              routeWaypoints: _routeWaypoints,
              continueRoute: _continueRoute,
              mapController: _mapController,
              polylineCoordinates: _polylineCoordinates,
              currentLocation: _currentLocation,
              mapRotation: _mapRotation,
              destination: _routeWaypoints[_routeWaypoints.length - 1]),
        );
      case 'metro':
        if (_isOnWalkNavigation) {
          _locationSubscription!.pause();
          _compassSubscription!.pause();
          _connectivitySubscription!.pause();
          setState(() {
            _isConnectedToInternet = null;
          });
          _locationTimer.cancel();
          _rightBottomWidget = const SizedBox();
          _isOnWalkNavigation = false;
        }
        return Expanded(
          child: MetroNavigationWidget(
              actualPoint.name,
              _routeInstructions[_index] as MetroInstruction,
              _continueRoute,
              _changeRightBottomWidget),
        );
      case 'ml':
        if (_isOnWalkNavigation) {
          _locationSubscription!.pause();
          _compassSubscription!.pause();
          _connectivitySubscription!.pause();
          setState(() {
            _isConnectedToInternet = null;
          });
          _locationTimer.cancel();
          _isOnWalkNavigation = false;
        }
        return Expanded(
          child: MLNavigationWidget(
              actualPoint.name,
              _routeInstructions[_index] as MLInstruction,
              _continueRoute,
              _changeRightBottomWidget),
        );
      case 'bus':
        if (_isOnWalkNavigation) {
          _locationSubscription!.pause();
          _compassSubscription!.pause();
          _connectivitySubscription!.pause();
          setState(() {
            _isConnectedToInternet = null;
          });
          _locationTimer.cancel();
          _isOnWalkNavigation = false;
        }
        return Expanded(
          child: BusNavigationWidget(
              _routeInstructions[_index] as BusInstruction,
              _continueRoute,
              _changeRightBottomWidget),
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
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 0),
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
                _renderPage()
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(25),
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WarningTimer(
                  duration: _warningTimeOut,
                  padding: const EdgeInsets.only(
                    left: 25.0,
                  ),
                ),
                _rightBottomWidget
              ],
            ),
          ),
        ),
      );
    }
  }
}
