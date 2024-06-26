import 'package:ez_maps/models/MetroInstruction.dart';
import 'package:flutter/material.dart';
import 'package:ez_maps/customWidgets/MetroNavigation/InitMetroStepWidget.dart';
import 'package:ez_maps/customWidgets/MetroNavigation/MetroEndWidget.dart';
import 'package:ez_maps/customWidgets/MetroNavigation/MetroTransferWidget.dart';

import '../ImageButton.dart';
import 'EnterMetroWidget.dart';
import 'OnMetroWidget.dart';

class MetroNavigationWidget extends StatefulWidget {
  final String originStation;
  final MetroInstruction instruction;
  final VoidCallback continueRoute;
  final Function(Widget) changeRightBottomWidget;

  MetroNavigationWidget(this.originStation, this.instruction, this.continueRoute,
      this.changeRightBottomWidget);

  @override
  State<MetroNavigationWidget> createState() => _MetroNavigationWidgetState();
}

class _MetroNavigationWidgetState extends State<MetroNavigationWidget> {
  Widget _actualWidget = const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(Color(0xFF4791DB)),
  );
  int _actualStep = 0;

  @override
  initState() {
    super.initState();
    setState(() {
      _actualWidget = EnterMetroWidget(widget.originStation, _setInitStep);
    });
  }

  void _setInitStep() {
    widget.changeRightBottomWidget(
      ImageButton(
          imagePath: "assets/images/ARASAACPictograms/nextButton.png",
          onPressed: _setOnMetroStep,
          size: 60),
    );
    setState(() {
      _actualWidget = InitMetroStepWidget(widget.instruction.metroSteps[_actualStep],
          _setOnMetroStep, widget.changeRightBottomWidget);
    });
  }

  void _setOnMetroStep() {
    widget.changeRightBottomWidget(
        SizedBox(),
    );
    setState(() {
      _actualWidget = OnMetroWidget(
          widget.instruction.metroSteps[_actualStep].stopNumber,
          widget.instruction.metroSteps[_actualStep].destination,
          _doTransferOrEndMetro);
    });
  }

  void _doTransferOrEndMetro() {
    widget.changeRightBottomWidget(
        SizedBox(),
    );
    setState(() {
      _actualStep++;
      if (widget.instruction.metroSteps.length > _actualStep) {
        _actualWidget = MetroTransferWidget(_setInitStep,
            widget.instruction.metroSteps[_actualStep-1].destination);
      } else {
        _actualWidget = MetroEndWidget(
            widget.instruction.metroSteps[_actualStep-1].destination,
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
