import 'package:flutter/material.dart';
import 'package:wethree_flutter_core/wethree_flutter_core.dart' as core;
import 'package:wethree_flutter_core/src/widgets/notes-form.dart';
import 'package:intl/intl.dart';

import '../wethree_flutter_core.dart';
import 'models/note.model.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class We3Notes extends StatefulWidget {
  We3Notes({
    
    required this.apiEndPoint,
  });
  final ApiEndpoint apiEndPoint;

  @override
  _We3NotesState createState() => _We3NotesState();
}

class _We3NotesState extends State<We3Notes> {
  final PagingController<int, Note> _pagingController =
      PagingController(firstPageKey: 1);
  Future<List<Note>> loadNotes(int page) async {
    widget.apiEndPoint.params!['num_items'] = "25|${page.toString()}";

    var data = await DataService.get(widget.apiEndPoint.url??'',
        params: widget.apiEndPoint.params);

    List<Note> items = [];

    for (int i = 0; i < data['data'].length; i++) {
      items.add(Note.fromJson(data['data'][i]));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: PaginatedListView<Note>(
            controller: _pagingController,
            fetchData: (page) => loadNotes(page),
            itemBuilder: (context, item, index) => ListTile(
              leading: CircleAvatar(
                child: Text(
                  (index + 1).toString(),
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                ),
                backgroundColor: Colors.orange,
              ),
              title: Text(item.note??''),
              subtitle: Row(
                children: <Widget>[
                  Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.grey,
                    size: 14,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(3, 0, 0, 0),
                  ),
                  Text(DateFormat.yMMMd()
                      .format(DateTime.parse(item.createdAt??''))),
                ],
              ),
            ),
            emptyMessage: 'Nothing here',
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: FloatingActionButton(
                onPressed: () {
                  BlurDialog(
                      container: NotesForm(
                          endpoint: widget.apiEndPoint,
                          controller: _pagingController),
                      context: context);
                },
                child: Icon(Icons.add, color: Colors.white)),
          ),
        )
      ],
    );
    // : NotesForm(
    //     controller: _pagingController,
    //     endpoint: widget.apiEndPoint,
    //   );
  }
}
