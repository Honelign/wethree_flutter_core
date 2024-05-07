import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FormDialog extends HookWidget {
  FormDialog({required this.container});

  final Widget container;
  @override
  Widget build(BuildContext context) {
    final controller =
        useAnimationController(duration: Duration(milliseconds: 700));
    final cardController =
        useAnimationController(duration: Duration(milliseconds: 200));
    controller.forward();
    cardController.forward();
    return Builder(
      builder: (context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: AnimatedBuilder(
          animation: controller,
          builder: (BuildContext context, Widget? child) => BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: controller.value * 5, sigmaY: controller.value * 5),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Opacity(
                  opacity: cardController.value,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    elevation: 10,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: container),
                  ),
                ),
              ))),
        ),
      ),
    );
  }
}
