import 'package:flutter/material.dart';
import 'package:ez_maps/customWidgets/MLNavigation/EnterMLWidget.dart';
import 'package:ez_maps/customWidgets/MLNavigation/MLTransferWidget.dart';
import 'package:ez_maps/customWidgets/MLNavigation/OnMLWidget.dart';
import 'package:ez_maps/customWidgets/MLNavigation/InitStepWidget.dart';
import 'package:ez_maps/customWidgets/MLNavigation/MLEndWidget.dart';

class MLNavigationWidget extends StatefulWidget {
  final String originStation;
  final steps;
  final VoidCallback continueRoute;

  MLNavigationWidget(this.originStation, this.steps, this.continueRoute);

  @override
  State<MLNavigationWidget> createState() => _MLNavigationWidgetState();
}

class _MLNavigationWidgetState extends State<MLNavigationWidget> {
  Widget _actualWidget = const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(Color(0xFF4791DB)),
  );
  int _actualStep = 1;

  @override
  initState() {
    super.initState();
    setState(() {
      _actualWidget = EnterMLWidget(widget.originStation, _setInitStep);
    });
  }

  void _setInitStep() {
    setState(() {
      _actualWidget =
          InitStepWidget(widget.steps["step$_actualStep"], _setOnMLStep);
    });
  }

  void _setOnMLStep() {
    setState(() {
      _actualWidget = OnMLWidget(widget.steps["step$_actualStep"]["stops"],
          widget.steps["step$_actualStep"]["destination"], _doTransferOrEndML);
    });
  }

  void _doTransferOrEndML() {
    setState(() {
      _actualStep++;
      if (widget.steps["step$_actualStep"] != null) {
        _actualWidget = MLTransferWidget(
            _setInitStep,
            widget.steps["step${_actualStep - 1}"]["destination"]);
      } else {
        _actualWidget = MLEndWidget(
            widget.steps["step${_actualStep - 1}"]["destination"],
            widget.continueRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _actualWidget,
    );
  }
}
