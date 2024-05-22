import 'package:ez_maps/customWidgets/CallForInterruptedRouteDialog.dart';
import 'package:ez_maps/customWidgets/ShortRouteWidget.dart';
import 'package:ez_maps/services/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../customWidgets/CustomButton.dart';
import '../customWidgets/ImageButton.dart';
import '../models/RoutePoint.dart';
import '../models/ShortRoute.dart';
import 'package:geolocator/geolocator.dart';

class RouteSelectionPage extends StatefulWidget {
  const RouteSelectionPage({super.key});

  @override
  State<RouteSelectionPage> createState() => _RouteSelectionPageState();
}

class _RouteSelectionPageState extends State<RouteSelectionPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _startedRoute = null;
  bool? _hasLocationPermission;

  bool _getLocationCompleted = false;
  bool _loadRoutesCompleted = false;
  List<ShortRoute> _nearRoutes = [];
  List<ShortRoute> _shortRoute = [];
  late Position _iniLocation;

  @override
  void initState() {
    super.initState();
    _initialLoad();
  }

  Future<void> _initialLoad() async {
    _initialCheckPermissions().then((value) async {
      if (_hasLocationPermission == true) {
        await _checkStartedRoute();
        await _getLocation();
        await _getRoutes();
        _getNearbyRoutes();
      }
    });
  }

  Future<void> _checkStartedRoute() async {
    final prefs = await SharedPreferences.getInstance();
    String? startedRoute = prefs.getString('startedRoute');
    if (startedRoute != null) {
      setState(() {
        _startedRoute = startedRoute;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CallForInterruptedRouteDialog(route_name: startedRoute);
          },
        );
      });
    }
  }

  void _removeStartedRoute() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('startedRoute');
    setState(() {
      _startedRoute = null;
    });
  }

  Future<void> _initialCheckPermissions() async {
    var status = await perm.Permission.location.request();
    setState(() {
      _hasLocationPermission = status == perm.PermissionStatus.granted;
    });
  }

  Future<void> _reloadPermissions() async {
    _checkPermissions().then((value) async {
      if (_hasLocationPermission == true) {
        await _getLocation();
        await _getRoutes();
        _getNearbyRoutes();
      }
    });
  }

  Future<void> _checkPermissions() async {
    var status = await perm.Permission.location.request();
    if (status == perm.PermissionStatus.permanentlyDenied) {
      perm.openAppSettings();
      status = await perm.Permission.location.status;
    }
    setState(() {
      _hasLocationPermission = status == perm.PermissionStatus.granted;
    });
  }

  Future<void> _getLocation() async {
    var iniLocation = await Geolocator.getCurrentPosition();
    setState(() {
      _iniLocation = iniLocation;
      _getLocationCompleted = true;
    });
  }

  bool _isNearRouteOrigin(var routeOriginPoint) {
    LatLng currentLatLng =
        LatLng(_iniLocation.latitude, _iniLocation.longitude);
    double distance =
        const Distance().as(LengthUnit.Meter, currentLatLng, routeOriginPoint);
    return distance < 100;
  }

  Future<void> _getRoutes() async {
    final AuthService authService =
        Provider.of<AuthService>(context, listen: false);
    User? user = authService.user;
    List<ShortRoute> shortRoutes = [];
    if (user != null) {
      await _firestore
          .collection("shortRoutes")
          .doc(user.email)
          .get()
          .then((event) {
        event.data()?.forEach((routeName, routeInformation) {
          try {
            if (routeName == null) {
              throw Exception("Nombre de ruta incorrecto");
            }

            var originData = routeInformation["origin"];
            if (originData == null) {
              throw Exception("$routeName no tiene origen");
            }

            var destinationData = routeInformation["destination"];
            if (destinationData == null) {
              throw Exception("$routeName no tiene destino");
            }

            String? originName = originData['name'];
            String? originImage = originData['image'];
            GeoPoint? originLocation = originData['location'];

            if (originName == null ||
                originImage == null ||
                originLocation == null) {
              throw Exception(
                  "Datos incompletos en el origen de la ruta $routeName");
            }

            RouteWaypoint origin = RouteWaypoint(
                name: originName,
                type: "origin",
                pointImage: originImage,
                location: originLocation);

            String? destinationName = destinationData['name'];
            String? destinationImage = destinationData['image'];
            GeoPoint destinationLocation = destinationData['location'];

            if (destinationName == null ||
                destinationImage == null ||
                destinationLocation == null) {
              throw Exception(
                  "Datos incompletos en el destino del Resumen de Ruta $routeName");
            }

            RouteWaypoint destination = RouteWaypoint(
                name: destinationName,
                type: "destination",
                pointImage: destinationImage,
                location: destinationLocation);

            shortRoutes.add(
              ShortRoute(
                  routeName: routeName, origin: origin, destination: destination),
            );
          } on Exception catch (e) {
            print(e);
          }

        });
        setState(() {
          _shortRoute = shortRoutes;
        });
      });
    }
  }

  void _getNearbyRoutes() {
    List<ShortRoute> nearRoutes = [];
    _shortRoute.forEach((route) {
      LatLng routeOriginLatLng = LatLng(
          route.origin.location.latitude, route.origin.location.longitude);
      if (_isNearRouteOrigin(routeOriginLatLng)) {
        nearRoutes.add(route);
      }
    });
    setState(() {
      _nearRoutes = nearRoutes;
      _loadRoutesCompleted = true;
    });
  }

  Widget _getPage() {
    if (_hasLocationPermission == null) {
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Color(0xFF4791DB)),
      );
    } else if (_hasLocationPermission == false) {
      return (Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Color(0xFF4791DB),
                size: 100,
              ),
              Text(
                "NO HAY PERMISOS DE UBICACIÓN",
                style: TextStyle(
                  fontSize: 30,
                  color: Color(0xFF4791DB),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "PULSA EL BOTÓN PARA ACTIVAR LOS PERMISOS DE UBICACIÓN",
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              const SizedBox(
                height: 20.0,
              ),
              CustomButton("ACTIVAR PERMISOS", () async {
                _reloadPermissions();
              }, true),
            ],
          ),
        ],
      ));
    } else {
      return (_getLocationCompleted && _loadRoutesCompleted)
          ? _renderNearRoutes()
          : const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Color(0xFF4791DB)),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "PACIENCIA...\nESTAMOS CARGANDO TUS RUTAS",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF4791DB),
                      fontWeight: FontWeight.bold),
                )
              ],
            );
    }
  }

  Widget _renderNearRoutes() {
    if (_nearRoutes.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Color(0xFF4791DB),
                size: 100,
              ),
              Text(
                "NO TIENES NINGUNA RUTA CERCA DE TI",
                style: TextStyle(
                  fontSize: 30,
                  color: Color(0xFF4791DB),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "PULSA EL BOTÓN PARA RECARGAR RUTAS",
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              const SizedBox(
                height: 20.0,
              ),
              ImageButton(
                imagePath: "assets/images/ARASAACPictograms/refreshButton.png",
                size: 100,
                onPressed: () async {
                  setState(() {
                    _getLocationCompleted = false;
                    _loadRoutesCompleted = false;
                  });
                  await _getLocation();
                  _getNearbyRoutes();
                },
              ),
            ],
          ),
        ],
      );
    } else {
      return ListView(
        children: _nearRoutes.map((shortRoute) {
          return Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
            child: ShortRouteWidget(
              shortRoute: shortRoute,
              iniLocation: _iniLocation,
            ),
          );
        }).toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TUS RUTAS',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4791DB),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(30.0),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: Center(child: _getPage()),
      ),
      bottomNavigationBar: _startedRoute != null
          ? Container(
              color: const Color(0xFF4791DB),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ImageButton(
                        imagePath: "assets/images/ARASAACPictograms/yes.png",
                        size: 60,
                        showBorder: true,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CallForInterruptedRouteDialog(
                                  route_name: _startedRoute ?? "");
                            },
                          );
                        }),
                    const Expanded(
                      child: Text(
                        '¿NECESITAS AYUDA?',
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ImageButton(
                        imagePath: "assets/images/ARASAACPictograms/no.png",
                        size: 60,
                        showBorder: true,
                        onPressed: _removeStartedRoute),
                  ],
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}
