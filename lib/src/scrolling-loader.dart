import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class ScrollingLoaderAnimation extends StatelessWidget {
  const ScrollingLoaderAnimation();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            height: 120,
            child: RiveAnimation.asset(
                'packages/wethree_flutter_core/assets/elips-loader.riv',
                artboard: 'One_more_loader', onInit: (Artboard artboard) {
              artboard.fills.first.paint.color = Colors.transparent;
            })));
  }
}
