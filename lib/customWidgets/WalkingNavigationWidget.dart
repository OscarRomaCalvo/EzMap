import 'package:ez_maps/models/WalkInstruction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:ez_maps/customWidgets/InstructionWidget.dart';

import '../models/Instruction.dart';
import '../models/RoutePoint.dart';
import 'PopUpMarker.dart';

class WalkingNavigationWidget extends StatefulWidget {
  final bool completedLoad;
  final int index;
  final List<Instruction> routeInstructions;
  final List<RouteWaypoint> routeWaypoints;
  final VoidCallback continueRoute;
  final MapController mapController;
  final List<LatLng> polylineCoordinates;
  final Position currentLocation;
  final double mapRotation;
  final destination;

  const WalkingNavigationWidget({
    Key? key,
    required this.completedLoad,
    required this.index,
    required this.routeInstructions,
    required this.routeWaypoints,
    required this.continueRoute,
    required this.mapController,
    required this.polylineCoordinates,
    required this.currentLocation,
    required this.mapRotation,
    required this.destination,
  }) : super(key: key);

  @override
  _WalkingNavigationWidgetState createState() => _WalkingNavigationWidgetState();
}

class _WalkingNavigationWidgetState extends State<WalkingNavigationWidget> {
  List<Marker> _renderRouteMarkers() {
    List<Marker> markers = [];
    for (var i = 0; i < widget.routeWaypoints.length; i++) {
      if (widget.routeWaypoints[i].type == 'pie' ||
          widget.routeWaypoints[i].type == 'destino') {
        RouteWaypoint routePoint = widget.routeWaypoints[i];
        var marker = Marker(
          point: LatLng(
              routePoint.location.latitude, routePoint.location.longitude),
          width: 50,
          height: 50,
          child: PopUpMarker(imageURL: routePoint.pointImage),
        );
        markers.add(marker);
      }
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: InstructionWidget(widget.routeInstructions[widget.index] as WalkInstruction),
            ),
          ),
        ),
        const SizedBox(height: 25.0),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Center(
              child: FlutterMap(
                mapController: widget.mapController,
                options: MapOptions(
                    initialCenter: LatLng(
                        widget.currentLocation.latitude, widget.currentLocation.longitude),
                    initialZoom: 18,
                    initialRotation: widget.mapRotation,
                    interactionOptions:
                    const InteractionOptions(flags: InteractiveFlag.none)),
                children: [
                  TileLayer(
                    urlTemplate:
                    'https://api.mapbox.com/styles/v1/oscarro/clsxlxk5s00bq01mee7tm7502/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoib3NjYXJybyIsImEiOiJjbHNjeXo5bGkwcHU4MmpubzM3dHZlc253In0.XC-Sp1-ecbNP0mCBpjhsxw',
                  ),
                  PolylineLayer(polylines: [
                    Polyline(
                      points: widget.polylineCoordinates,
                      strokeWidth: 9,
                      color: const Color(0xFF4791DB),
                      borderStrokeWidth: 3,
                      borderColor: const Color(0xFF8EC4FB),
                    ),
                  ]),
                  MarkerLayer(
                    rotate: true,
                    markers: _renderRouteMarkers() +
                        [
                          Marker(
                            point: LatLng(widget.currentLocation.latitude,
                                widget.currentLocation.longitude),
                            width: 60,
                            height: 60,
                            child: const Stack(
                              children: [
                                Icon(
                                  Icons.navigation,
                                  color: Color(0xFF4791DB),
                                  size: 60,
                                ),
                                Icon(
                                  Icons.navigation_outlined,
                                  color: Colors.white,
                                  size: 60,
                                ),
                              ],
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
    );
  }
}
