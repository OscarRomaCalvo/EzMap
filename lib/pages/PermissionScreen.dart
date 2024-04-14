import 'package:ez_maps/pages/RouteSelectionPage.dart';
import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';

import 'InitSessionPage.dart';

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
                    const SnackBar(content: Text('No hay permiso de acceso a la ubicación.')),
                  );
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Permiso de acceso a la ubicación concedido.')),
                  );
                }
              },
              child: const Text('Verificar Permiso de Ubicación'),
            ),
            ElevatedButton(
              onPressed: () {
                checkPermissions();
              },
              child: const Text('Volver a Solicitar Permisos'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InitSessionPage()),
                );
              },
              child: Text('Ir a la Segunda Pantalla'),
            ),
          ],
        ),
      ),
    );
  }
}