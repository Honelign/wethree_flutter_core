import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoaderAnimation extends StatelessWidget {
  const LoaderAnimation();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            height: 250,
            child: RiveAnimation.asset(
              'packages/wethree_flutter_core/assets/loader.riv',
            )));
  }
}
