import 'package:ez_maps/customWidgets/BusNavigation/BusInstructionWidget.dart';
import 'package:ez_maps/customWidgets/BusNavigation/LastBusInstructionWidget.dart';
import 'package:ez_maps/models/BusInstruction.dart';
import 'package:flutter/material.dart';

import '../ImageButton.dart';

class BusNavigationWidget extends StatefulWidget {
  final BusInstruction busInstruction;
  final VoidCallback continueRoute;
  final Function(Widget) changeRightBottomWidget;

  const BusNavigationWidget(
      this.busInstruction, this.continueRoute, this.changeRightBottomWidget,
      {Key? key})
      : super(key: key);

  @override
  State<BusNavigationWidget> createState() => _BusNavigationWidgetState();
}

class _BusNavigationWidgetState extends State<BusNavigationWidget> {
  int _actualStep = 0;
  Widget _actualWidget = const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(Color(0xFF4791DB)),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initRoute();
    });
  }

  void _initRoute() {
    setState(() {
      _actualWidget =
          BusInstructionWidget(widget.busInstruction.busSteps[_actualStep]);
    });
    widget.changeRightBottomWidget(
      ImageButton(
        imagePath: "assets/images/ARASAACPictograms/nextButton.png",
        onPressed: _continueRoute,
        size: 60,
      ),
    );
  }

  void _continueRoute() {
    if (_actualStep + 1 < widget.busInstruction.busSteps.length) {
      setState(() {
        _actualStep++;
        _actualWidget =
            BusInstructionWidget(widget.busInstruction.busSteps[_actualStep]);
      });
    } else {
      widget.changeRightBottomWidget(
        const SizedBox(),
      );
      setState(() {
        _actualStep++;
        _actualWidget = LastBusInstructionWidget(widget.continueRoute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _actualWidget;
  }
}
