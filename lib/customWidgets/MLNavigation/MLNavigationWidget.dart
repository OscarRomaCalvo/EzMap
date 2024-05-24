import 'package:ez_maps/models/MLInstruction.dart';
import 'package:flutter/material.dart';
import 'package:ez_maps/customWidgets/MLNavigation/EnterMLWidget.dart';
import 'package:ez_maps/customWidgets/MLNavigation/MLTransferWidget.dart';
import 'package:ez_maps/customWidgets/MLNavigation/OnMLWidget.dart';
import 'package:ez_maps/customWidgets/MLNavigation/InitMLStepWidget.dart';
import 'package:ez_maps/customWidgets/MLNavigation/MLEndWidget.dart';

import '../ImageButton.dart';

class MLNavigationWidget extends StatefulWidget {
  final String originStation;
  final MLInstruction instruction;
  final VoidCallback continueRoute;
  final Function(Widget) changeRightBottomWidget;

  MLNavigationWidget(this.originStation, this.instruction, this.continueRoute, this.changeRightBottomWidget);

  @override
  State<MLNavigationWidget> createState() => _MLNavigationWidgetState();
}

class _MLNavigationWidgetState extends State<MLNavigationWidget> {
  Widget _actualWidget = const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(Color(0xFF4791DB)),
  );
  int _actualStep = 0;

  @override
  initState() {
    super.initState();
    setState(() {
      _actualWidget = EnterMLWidget(widget.originStation, _setInitStep);
    });
  }

  void _setInitStep() {
    widget.changeRightBottomWidget(
      ImageButton(
          imagePath: "assets/images/ARASAACPictograms/nextButton.png",
          onPressed: _setOnMLStep,
          size: 60),
    );
    setState(() {
      _actualWidget =
          InitMLStepWidget(widget.instruction.mlSteps[_actualStep], _setOnMLStep, widget.changeRightBottomWidget);
    });
  }

  void _setOnMLStep() {
    widget.changeRightBottomWidget(
      SizedBox(),
    );
    setState(() {
      _actualWidget = OnMLWidget(widget.instruction.mlSteps[_actualStep].stopNumber,
          widget.instruction.mlSteps[_actualStep].destination, _doTransferOrEndML);
    });
  }

  void _doTransferOrEndML() {
    widget.changeRightBottomWidget(
        SizedBox(),
    );
    setState(() {
      _actualStep++;
      if (widget.instruction.mlSteps.length > _actualStep) {
        _actualWidget = MLTransferWidget(
            _setInitStep,
            widget.instruction.mlSteps[_actualStep-1].destination);
      } else {
        _actualWidget = MLEndWidget(
            widget.instruction.mlSteps[_actualStep-1].destination,
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
