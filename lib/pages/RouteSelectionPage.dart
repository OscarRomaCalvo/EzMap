import 'package:ez_maps/customWidgets/ShortRouteWidget.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart' as perm;
import '../customWidgets/CustomButton.dart';
import '../models/RoutePoint.dart';
import '../models/ShortRoute.dart';

class RouteSelectionPage extends StatefulWidget {
  const RouteSelectionPage({super.key});

  @override
  State<RouteSelectionPage> createState() => _RouteSelectionPageState();
}

class _RouteSelectionPageState extends State<RouteSelectionPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final locationService = Location();

  bool? _hasLocationPermission = null;

  bool _getLocationCompleted = false;
  bool _loadRoutesCompleted = false;
  List<ShortRoute> _nearRoutes = [];
  late LocationData _iniLocation;

  @override
  void initState() {
    super.initState();
    _initialLoad();
  }

  Future<void> _initialLoad() async {
    _initialCheckPermissions().then((value) async {
      if (_hasLocationPermission == true) {
        await _getLocation();
        _getNearbyRoutes();
      }
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
    var iniLocation = await locationService.getLocation();
    setState(() {
      _iniLocation = iniLocation;
      _getLocationCompleted = true;
    });
  }

  bool _isNearRouteOrigin(var routeOriginPoint) {
    LatLng currentLatLng =
        LatLng(_iniLocation.latitude!, _iniLocation.longitude!);
    double distance =
        const Distance().as(LengthUnit.Meter, currentLatLng, routeOriginPoint);
    return distance < 50;
  }

  void _getNearbyRoutes() {
    List<ShortRoute> nearRoutes = [];
    _firestore.collection("shortRoutes").doc("idUsuario1").get().then((event) {
      event.data()?.forEach((routeName, routeInformation) {
        RoutePoint origin = RoutePoint(
            name: routeInformation["origin"]["name"],
            type: "origin",
            pointImage: routeInformation["origin"]["image"],
            location: routeInformation["origin"]["location"]);
        RoutePoint destination = RoutePoint(
            name: routeInformation["destination"]["name"],
            type: "destination",
            pointImage: routeInformation["destination"]["image"],
            location: routeInformation["destination"]["location"]);
        LatLng routeOriginLatLng =
            LatLng(origin.location.latitude, origin.location.longitude);

        if (_isNearRouteOrigin(routeOriginLatLng)) {
          nearRoutes.add(ShortRoute(
              routeName: routeName, origin: origin, destination: destination));
        }
      });

      setState(() {
        _nearRoutes = nearRoutes;
        _loadRoutesCompleted = true;
      });
    });
  }

  Widget _getPage() {
    if (_hasLocationPermission == null) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Color(0xFF4791DB)),
        ),
      );
    } else if (_hasLocationPermission == false) {
      return (Column(
        children: [
          const Text("No hay permisos para acceder a la ubicación"),
          CustomButton("ACTIVAR PERMISOS", () async {
            _reloadPermissions();
          }, true),
        ],
      ));
    } else {
      return Padding(
        padding: const EdgeInsets.all(25.0),
        child: (_getLocationCompleted && _loadRoutesCompleted)
            ? _renderNearRoutes()
            : const Center(child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Color(0xFF4791DB)),
        )),
      );
    }
  }

  Widget _renderNearRoutes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _nearRoutes.map((shortRoute) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
          child: ShortRouteWidget(
              shortRoute: shortRoute, iniLocation: _iniLocation),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'RUTAS',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: _getPage());
  }
}
