import 'package:flutter/material.dart';
import 'package:wethree_flutter_core/src/dialog.dart';
import 'package:wethree_flutter_core/src/submit-button.dart';

class AlertPopup {
  AlertPopup(
      {required this.context,
      required this.onPressed,
      required this.buttonText,
      required this.label,
      required this.title}) {
    alertPopup(context);
  }
  final BuildContext context;
  final Function onPressed;
  final String title;
  final String label;
  final String buttonText;

  BlurDialog alertPopup(context) {
    return BlurDialog(container: alertWidget(), context: context);
  }

  Widget alertWidget() {
    final size = MediaQuery.of(context).size;
    return Container(
        width: size.width * 0.7,
        height: size.height * 0.26,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                SizedBox(height: 15),
                Text(label, style: TextStyle(fontSize: 15)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ignore: deprecated_member_use
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 20),
                    SubmitButton(onPressed: onPressed, text: buttonText)
                  ],
                )
              ]),
        ));
  }
}
