import 'package:flutter/material.dart';
import 'package:prueba_ezmaps_estatica/customWidgets/MetroNavigation/InitStepWidget.dart';
import 'package:prueba_ezmaps_estatica/customWidgets/MetroNavigation/MetroEndWidget.dart';
import 'package:prueba_ezmaps_estatica/customWidgets/MetroNavigation/MetroTransferWidget.dart';

import 'EnterMetroWidget.dart';
import 'OnMetroWidget.dart';

class MetroNavigationWidget extends StatefulWidget {
  final String originStation;
  final steps;
  final VoidCallback continueRoute;

  MetroNavigationWidget(this.originStation, this.steps, this.continueRoute);

  @override
  State<MetroNavigationWidget> createState() => _MetroNavigationWidgetState();
}

class _MetroNavigationWidgetState extends State<MetroNavigationWidget> {
  Widget _actualWidget = const CircularProgressIndicator();
  int _actualStep = 1;

  @override
  initState() {
    super.initState();
    setState(() {
      _actualWidget = EnterMetroWidget(widget.originStation, _setInitStep);
    });
  }

  void _setInitStep(){
    setState(() {
      _actualWidget = InitStepWidget(widget.steps["step$_actualStep"], _setOnMetroStep);
    });
  }

  void _setOnMetroStep(){
    setState(() {
      _actualWidget = OnMetroWidget(widget.steps["step$_actualStep"]["stops"], widget.steps["step$_actualStep"]["destination"], _doTransferOrEndMetro);
    });
  }

  void _doTransferOrEndMetro(){
    setState(() {
      _actualStep++;
      if(widget.steps["step$_actualStep"]!=null){
        _actualWidget = MetroTransferWidget(_setInitStep, widget.steps["step${_actualStep-1}"]["line"],widget.steps["step${_actualStep-1}"]["destination"], widget.steps["step$_actualStep"]["line"], widget.steps["step$_actualStep"]["direction"]);
      } else {
        _actualWidget = MetroEndWidget(widget.steps["step${_actualStep-1}"]["destination"], widget.continueRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: _actualWidget,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
