import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_maps/exceptions/WrongWalkingInstructionException.dart';
import 'package:ez_maps/models/BusInstruction.dart';

import '../exceptions/WrongBusInstructionException.dart';
import '../exceptions/WrongMLInstructionException.dart';
import '../exceptions/WrongMetroInstructionException.dart';
import '../exceptions/WrongWaypointException.dart';
import '../models/Instruction.dart';
import '../models/MLInstruction.dart';
import '../models/MetroInstruction.dart';
import '../models/RoutePoint.dart';
import '../models/WalkInstruction.dart';

class RouteTranslator {
  static Map<String, dynamic> translateRoute(var event, String routeName) {
    int waypointIndex = 0;
    List<RoutePoint> routeWaypoints = [];
    List<Instruction> routeInstructions = [];

    event.data()?["puntosMapa"].forEach((waypoint) {
      if (waypoint["nombre"] is! String ||
          waypoint["tipo"] is! String ||
          waypoint["urlImagen"] is! String ||
          waypoint["coordenadas"] is! GeoPoint) {
        throw WrongWaypointException(routeName, waypointIndex);
      }
      if (waypoint["tipo"] != "pie" &&
          waypoint["tipo"] != "destino" &&
          waypoint["tipo"] != "metro" &&
          waypoint["tipo"] != "ml" &&
          waypoint["tipo"] != "bus"
      ) {
        throw WrongWaypointException(routeName, waypointIndex);
      }
      RoutePoint routePoint = RoutePoint(
          name: waypoint["nombre"],
          type: waypoint["tipo"],
          pointImage: waypoint["urlImagen"],
          location: waypoint["coordenadas"]);

      routeWaypoints.add(routePoint);
      waypointIndex++;
    });

    int stepIndex = 0;
    event.data()?["instrucciones"].forEach((step) {
      if (routeWaypoints[stepIndex].type == 'pie' ||
          routeWaypoints[stepIndex].type == 'destino') {
        if (step["instruccion1"] == null) {
          throw WrongWalkingInstructionException(routeName, stepIndex);
        }
        if (step["instruccion1"]["texto"] is! String ||
            step["instruccion1"]["urlImagen"] is! String) {
          throw WrongWalkingInstructionException(routeName, stepIndex);
        }

        WalkStep firstStep = WalkStep(
            step["instruccion1"]["urlImagen"], step["instruccion1"]["texto"]);
        WalkStep? secondStep = null;

        if (step["instruccion2"] != null) {
          if (step["instruccion2"]["texto"] is! String ||
              step["instruccion2"]["urlImagen"] is! String) {
            throw WrongWalkingInstructionException(routeName, stepIndex);
          }
          secondStep = WalkStep(
              step["instruccion2"]["urlImagen"], step["instruccion2"]["texto"]);
        }

        WalkInstruction walkInstruction =
            WalkInstruction(firstStep, secondStep);
        routeInstructions.add(walkInstruction);
      } else if (routeWaypoints[stepIndex].type == 'metro') {
        List<MetroStep> metroStepList = [];

        int metroStepIndex = 1;
        while (step["instruccion${metroStepIndex}"] != null) {
          var metroStepElement = step["instruccion${metroStepIndex}"];

          if (metroStepElement["destino"] is! String ||
              metroStepElement["direccion"] is! String ||
              metroStepElement["linea"] is! String ||
              metroStepElement["numeroDeParadas"] is! int ||
              metroStepElement["imagenLinea"] is! String) {
            throw WrongMetroInstructionException(routeName, stepIndex);
          }

          MetroStep metroStep = MetroStep(
            metroStepElement["destino"],
            metroStepElement["direccion"],
            metroStepElement["linea"],
            metroStepElement["numeroDeParadas"],
            metroStepElement["imagenLinea"],
          );

          metroStepList.add(metroStep);

          metroStepIndex++;
        }

        if (metroStepList.isEmpty) {
          throw WrongMetroInstructionException(routeName, stepIndex);
        }

        MetroInstruction metroInstruction = MetroInstruction(metroStepList);
        routeInstructions.add(metroInstruction);
      } else if (routeWaypoints[stepIndex].type == 'ml') {
        List<MLStep> mlStepList = [];

        int mlStepIndex = 1;

        while (step["instruccion${mlStepIndex}"] != null) {
          var mlStepElement = step["instruccion${mlStepIndex}"];

          if (mlStepElement["destino"] is! String ||
              mlStepElement["direccion"] is! String ||
              mlStepElement["linea"] is! String ||
              mlStepElement["numeroDeParadas"] is! int ||
              mlStepElement["imagenLinea"] is! String) {
            throw WrongMLInstructionException(routeName, stepIndex);
          }

          MLStep mlStep = MLStep(
            mlStepElement["destino"],
            mlStepElement["direccion"],
            mlStepElement["linea"],
            mlStepElement["numeroDeParadas"],
            mlStepElement["imagenLinea"],
          );

          mlStepList.add(mlStep);

          mlStepIndex++;
        }

        if (mlStepList.isEmpty) {
          throw WrongMLInstructionException(routeName, stepIndex);
        }

        MLInstruction mlInstruction = MLInstruction(mlStepList);
        routeInstructions.add(mlInstruction);
      }else if(routeWaypoints[stepIndex].type == 'bus'){
        List<BusStep> busStepList = [];

        int busStepIndex = 1;

        while (step["instruccion${busStepIndex}"] != null) {
          var busStepElement = step["instruccion${busStepIndex}"];

          if (busStepElement["texto"] is! String) {
            throw WrongBusInstructionException(routeName, stepIndex);
          }
          String? urlImage;
          if(busStepElement["urlImagen"] is String){
            urlImage = busStepElement["urlImagen"];
          }
          BusStep busStep = BusStep(
            busStepElement["texto"],
            urlImage,
          );

          busStepList.add(busStep);

          busStepIndex++;
        }

        if (busStepList.isEmpty) {
          throw WrongBusInstructionException(routeName, stepIndex);
        }

        BusInstruction busInstruction = BusInstruction(busStepList);
        routeInstructions.add(busInstruction);
      }

      stepIndex++;
    });

    if (waypointIndex != stepIndex || waypointIndex == 0) {
      throw Exception(
          "No concuerda el número de waypoints y de instrucciones en la ruta $routeName");
    }

    return {
      'routeWaypoints': routeWaypoints,
      'routeInstructions': routeInstructions,
    };
  }
}
