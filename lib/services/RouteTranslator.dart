import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Instruction.dart';
import '../models/MLInstruction.dart';
import '../models/MetroInstruction.dart';
import '../models/RoutePoint.dart';
import '../models/WalkInstruction.dart';

class RouteTranslator {

  static Map<String,dynamic> translateRoute(var event, String routeName) {
    int waypointIndex = 0;
    List<RouteWaypoint> routeWaypoints = [];
    List<Instruction> routeInstructions = [];

    event.data()?["waypoints"].forEach((waypoint) {
      if (waypoint["name"] is! String ||
          waypoint["type"] is! String ||
          waypoint["pointImage"] is! String ||
          waypoint["location"] is! GeoPoint) {
        throw Exception(
            "Datos incorrectos en la ruta ${routeName}");
      }
      if (waypoint["type"] != "reference" &&
          waypoint["type"] != "destination" &&
          waypoint["type"] != "metro" &&
          waypoint["type"] != "ml") {
        throw Exception(
            "Datos incorrectos en la ruta ${routeName}");
      }
      RouteWaypoint routePoint = RouteWaypoint(
          name: waypoint["name"],
          type: waypoint["type"],
          pointImage: waypoint["pointImage"],
          location: waypoint["location"]);

      routeWaypoints.add(routePoint);
      waypointIndex++;
    });

    int stepIndex = 0;
    event.data()?["steps"].forEach((step) {
      if (routeWaypoints[stepIndex].type == 'reference' ||
          routeWaypoints[stepIndex].type == 'destination') {
        if (step["step1"] == null) {
          throw Exception(
              "Datos incorrectos en la ruta ${routeName}");
        }
        if (step["step1"]["text"] is! String ||
            step["step1"]["image"] is! String) {
          throw Exception(
              "Datos incorrectos en la ruta ${routeName}");
        }

        WalkStep firstStep =
        WalkStep(step["step1"]["image"], step["step1"]["text"]);
        WalkStep? secondStep = null;

        if (step["step2"] != null) {
          if (step["step2"]["text"] is! String ||
              step["step2"]["image"] is! String) {
            throw Exception(
                "Datos incorrectos en la ruta ${routeName}");
          }
          secondStep =
              WalkStep(step["step2"]["image"], step["step2"]["text"]);
        }

        WalkInstruction walkInstruction =
        WalkInstruction(firstStep, secondStep);
        routeInstructions.add(walkInstruction);
      } else if (routeWaypoints[stepIndex].type == 'metro') {
        List<MetroStep> metroStepList = [];

        int metroStepIndex = 1;
        while (step["step${metroStepIndex}"] != null) {
          var metroStepElement = step["step${metroStepIndex}"];

          if (metroStepElement["destination"] is! String ||
              metroStepElement["direction"] is! String ||
              metroStepElement["line"] is! String ||
              metroStepElement["stops"] is! int) {
            throw Exception(
                "Datos incorrectos en la ruta ${routeName}");
          }

          MetroStep metroStep = MetroStep(
              metroStepElement["destination"],
              metroStepElement["direction"],
              metroStepElement["line"],
              metroStepElement["stops"]);

          metroStepList.add(metroStep);

          metroStepIndex++;
        }

        if (metroStepList.isEmpty) {
          throw Exception(
              "Datos incorrectos en la ruta ${routeName}");
        }

        MetroInstruction metroInstruction =
        MetroInstruction(metroStepList);
        routeInstructions.add(metroInstruction);
      } else if (routeWaypoints[stepIndex].type == 'ml') {
        List<MLStep> mlStepList = [];

        int mlStepIndex = 1;

        while (step["step${mlStepIndex}"] != null) {
          var mlStepElement = step["step${mlStepIndex}"];

          if (mlStepElement["destination"] is! String ||
              mlStepElement["direction"] is! String ||
              mlStepElement["line"] is! String ||
              mlStepElement["stops"] is! int) {
            throw Exception(
                "Datos incorrectos en la ruta ${routeName}");
          }

          MLStep mlStep = MLStep(
              mlStepElement["destination"],
              mlStepElement["direction"],
              mlStepElement["line"],
              mlStepElement["stops"]);

          mlStepList.add(mlStep);

          mlStepIndex++;
        }

        if (mlStepList.isEmpty) {
          throw Exception(
              "Datos incorrectos en la ruta ${routeName}");
        }

        MLInstruction mlInstruction = MLInstruction(mlStepList);
        routeInstructions.add(mlInstruction);
      }

      stepIndex++;
    });

    if (waypointIndex != stepIndex || waypointIndex == 0) {
      throw Exception("Datos incorrectos en la ruta ${routeName}");
    }

    return {
      'routeWaypoints': routeWaypoints,
      'routeInstructions': routeInstructions,
    };
  }

}
