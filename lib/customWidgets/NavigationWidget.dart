import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:prueba_ezmaps_estatica/customWidgets/InstructionWidget.dart';
import 'package:prueba_ezmaps_estatica/customWidgets/NextStepPopUp.dart';

import 'CustomButton.dart';
import 'PopUpMarker.dart';

class NavigationWidget extends StatelessWidget {
  final bool completedLoad;
  final int index;
  final exampleSteps;
  final exampleRoute;
  final VoidCallback continueRoute;
  final MapController mapController;
  final List<LatLng> polylineCoordinates;
  final LocationData currentLocation;
  final double mapRotation;

  const NavigationWidget({
    Key? key,
    required this.completedLoad,
    required this.index,
    required this.exampleSteps,
    required this.exampleRoute,
    required this.continueRoute,
    required this.mapController,
    required this.polylineCoordinates,
    required this.currentLocation,
    required this.mapRotation,
  }) : super(key: key);

  List<Marker> _renderRouteMarkers() {
    List<Marker> markers = [];
    for (var i = 0; i < exampleRoute.length; i++) {
      var point = exampleRoute[i];
      var marker = Marker(
        point:
        LatLng(point['latitude'] as double, point['longitude'] as double),
        width: 50,
        height: 50,
        child: PopUpMarker(point['image']),
      );
      markers.add(marker);
    }
    return markers;
  }

  bool _isFarFromPoint() {
    LatLng currentLatLng =
    LatLng(currentLocation.latitude!, currentLocation.longitude!);
    LatLng nextStepLatLng = LatLng(exampleRoute[index]['latitude'] as double,
        exampleRoute[index]['longitude'] as double);
    double distance =
    const Distance().as(LengthUnit.Meter, currentLatLng, nextStepLatLng);
    return distance > 10;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: double.infinity,
                  height: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child:  InstructionWidget(exampleSteps[index]),
                  ),
                ),
              ),
              const SizedBox(height: 25.0),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Center(
                    child: FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        initialCenter: LatLng(currentLocation.latitude!,
                            currentLocation.longitude!),
                        initialZoom: 18,
                        initialRotation: mapRotation,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                          'https://api.mapbox.com/styles/v1/oscarro/clsxlxk5s00bq01mee7tm7502/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoib3NjYXJybyIsImEiOiJjbHNjeXo5bGkwcHU4MmpubzM3dHZlc253In0.XC-Sp1-ecbNP0mCBpjhsxw',
                        ),
                        PolylineLayer(polylines: [
                          Polyline(
                            points: polylineCoordinates,
                            strokeWidth: 8,
                            color: Colors.greenAccent,
                          ),
                        ]),
                        MarkerLayer(
                          rotate: true,
                          markers: _renderRouteMarkers() +
                              [
                                Marker(
                                  point: LatLng(currentLocation.latitude!,
                                      currentLocation.longitude!),
                                  width: 50,
                                  height: 50,
                                  child: const Icon(
                                    Icons.navigation,
                                    color: Color(0xFF4791DB),
                                    size: 50,
                                  ),
                                ),
                              ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomButton("SALIR", () {}, false),
            NextStepPopUp(
              exampleRoute[index]['pointName'],
              exampleRoute[index]['image'],
              _isFarFromPoint(),
              continueRoute,
            ),
          ],
        ),
      ),
    );
  }
}
