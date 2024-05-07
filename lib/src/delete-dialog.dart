import 'package:flutter/material.dart';
import 'package:wethree_flutter_core/src/dialog.dart';
import 'package:wethree_flutter_core/src/submit-button.dart';

class DeleteDialog {
  DeleteDialog({required this.context, required this.onPressed}) {
    deleteDialog(context);
  }
  final BuildContext context;
  final Function onPressed;

  BlurDialog deleteDialog(context) {
    return BlurDialog(container: deleteWidget(), context: context);
  }

  Widget deleteWidget() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(
          'Delete',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        SizedBox(height: 15),
        Text('Are you sure you want to delete?',
            style: TextStyle(fontSize: 15)),
        SizedBox(height: 15),
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
            SubmitButton(onPressed: onPressed, text: 'Delete')
          ],
        )
      ]),
    );
  }
}
