import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class OpenContainerWrapper extends StatelessWidget {
  const OpenContainerWrapper(
      {required this.closedBuilder,
      required this.transitionType,
      this.onClosed,
      required this.openWidget});

  final OpenContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  final ClosedCallback<bool>? onClosed;
  final Widget openWidget;

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      closedColor: Colors.transparent,
      openColor: Colors.transparent,
      transitionDuration: Duration(milliseconds: 350),
      closedElevation: 0,
      openElevation: 0,
      transitionType: transitionType,
      openBuilder: (BuildContext context, VoidCallback _) {
        return openWidget;
      },
      onClosed: onClosed as ClosedCallback<bool?>?,
      tappable: false,
      closedBuilder: (BuildContext context, Function openContainer) {
        return closedBuilder(context, openContainer());
      },
    );
  }
}
