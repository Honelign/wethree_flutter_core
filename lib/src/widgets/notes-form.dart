import 'package:flutter/material.dart';
import 'package:wethree_flutter_core/wethree_flutter_core.dart';

import 'package:wethree_flutter_core/src/models/note.model.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class NotesForm extends StatefulWidget {
  NotesForm({required this.endpoint ,this.controller, this.note});
  final Note? note;
  final ApiEndpoint endpoint;
  final PagingController? controller;
  @override
  _NotesFormState createState() => _NotesFormState();
}

class _NotesFormState extends State<NotesForm> {
  String? text;
  bool isLoading = false;

  Future<void> saveNote() async {
    setState(() {
      isLoading = true;
    });
    var data =
        await DataService.post(widget.endpoint.url??'', widget.endpoint.data??{});
    if (data.containsKey('item')) {
      ToastMessage(message: 'Note added Successfully');
      Navigator.pop(context);
      widget.controller!.refresh();
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                iconSize: 18,
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: Colors.grey[600])),
            Text('Note Form',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 17,
                    fontWeight: FontWeight.bold)),
            Icon(Icons.ac_unit, color: Colors.white, size: 18)
          ],
        ),
        SizedBox(height: 15),
        TextField(
          decoration: inputDecoration('Note*', isMultiLine: true),
          keyboardType: TextInputType.multiline,
          minLines: 4,
          maxLines: 5,
          onChanged: (x) => text = x,
        ),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            widget.endpoint.data?['note'] = text;
            saveNote();
          },
          child: isLoading
              ? Spinner()
              : Text('Save',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
        )
      ]),
    );
  }
}
