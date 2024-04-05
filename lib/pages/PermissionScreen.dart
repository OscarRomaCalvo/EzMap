import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ez_maps/pages/NavigationPage.dart';

class PermissionScreen extends StatefulWidget {
  @override
  _PermissionScreenState createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  @override
  void initState() {
    super.initState();
    checkPermissions();
  }

  Future<void> checkPermissions() async {
    if (!await Permission.location.isGranted) {
      await Permission.location.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Permiso de Ubicación'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                if (!await Permission.location.isGranted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No hay permiso de acceso a la ubicación.')),
                  );
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Permiso de acceso a la ubicación concedido.')),
                  );
                }
              },
              child: Text('Verificar Permiso de Ubicación'),
            ),
            ElevatedButton(
              onPressed: () {
                checkPermissions();
              },
              child: Text('Volver a Solicitar Permisos'),
            ),
            ElevatedButton(
              onPressed: () async {
                String routeJsonString = await rootBundle.loadString('assets/routePoints.json');
                String stepsJsonString = await rootBundle.loadString('assets/steps.json');

                var routeData = json.decode(routeJsonString);
                var stepsData = json.decode(stepsJsonString);

                //PRELOAD INITIAL LOCATION
                var locationService = Location();
                var iniLocation = await locationService.getLocation();
                /*Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NavigationPage(routeData: routeData, stepsData: stepsData, iniLocation: iniLocation)),
                );*/
              },
              child: Text('Ir a la Segunda Pantalla'),
            ),
          ],
        ),
      ),
    );
  }
}