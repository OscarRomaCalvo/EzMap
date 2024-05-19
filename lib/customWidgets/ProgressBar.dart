import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final double stepHeight;
  final double spacing;

  const ProgressBar({
    Key? key,
    required this.totalSteps,
    required this.currentStep,
    this.stepHeight = 5.0,
    this.spacing = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        Color color;
        if (index < currentStep) {
          color = const Color(0xFF4791DB);
        } else if (index == currentStep) {
          color = const Color(0xFFFDA845);
        } else {
          color = const Color(0xFFDBDBDB);
        }

        if (index != currentStep) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing / 2),
              child: Container(
                height: stepHeight,
                color: color,
              ),
            ),
          );
        } else {
          return Expanded(
            child: SizedBox(
              height: stepHeight+20,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing / 2),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: stepHeight,
                      color: color,
                    ),
                    Center(
                      child: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                        ),
                        child: const Icon(Icons.person, size: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }),
    );
  }
}
