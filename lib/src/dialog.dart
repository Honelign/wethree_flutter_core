import 'package:flutter/material.dart';
import 'package:wethree_flutter_core/src/widgets/custom-form.dart';

class BlurDialog {
  BlurDialog({required this.container, required this.context}) {
    formDialog(container, context);
  }
  final Widget container;
  final BuildContext context;

  static Future formDialog(Widget container, BuildContext context) {
    return Navigator.push(
        context,
        PageRouteBuilder(
            opaque: false,
            pageBuilder: (BuildContext context, _, __) {
              return FormDialog(container: container);
            }));
  }
}
