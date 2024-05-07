import 'package:flutter/material.dart';
import 'package:wethree_flutter_core/wethree_flutter_core.dart';

typedef SelectCheck<T> = bool Function(T item);
typedef ApiData<T> = void Function(List<T> items);

class SingleItemSelector<T> extends StatefulWidget {
  const SingleItemSelector({
  
    required this.label,
    required this.onChanged,
    this.items,
    required this.modelFromJson,
    required this.itemAsString,
    this.apiData,
    required this.apiUrl,
    required this.selectCheck,
    this.params,
  }) ;
  final String label;
  final ValueChanged<T> onChanged;
  final ItemAsString<T> itemAsString;
  final TfromJson modelFromJson;
  final List<T>? items;
  final String apiUrl;
  final SelectCheck<T> selectCheck;
  final ApiData<T>? apiData;
  final Map<String, String>? params;

  @override
  State<SingleItemSelector<T>> createState() => _SingleItemSelectorState<T>();
}

class _SingleItemSelectorState<T> extends State<SingleItemSelector<T>> {
  bool isLoading = false;
  List<T> items = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    if (widget.items == null) {
      if (this.mounted)
        setState(() {
          isLoading = true;
        });
      var data = await DataService.get(widget.apiUrl,
          params: widget.params ??
              <String, String>{
                "perPage": '1000',
                "page": "1",
                "lastPage": "1",
              });
      if (data != null && data.containsKey('data') && data['data'] != null)
        items = List<T>.from(data['data']?.map((x) => widget.modelFromJson(x)));
      if (this.mounted)
        setState(() {
          isLoading = false;
        });
    } else {
      items = widget.items!;
    }
    if (widget.apiData != null) widget.apiData!(items);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        !isLoading
            ? showModalBottomSheet(
                barrierColor: Color(0xff244556).withAlpha(140),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                isScrollControlled: true,
                clipBehavior: Clip.antiAlias,
                context: context,
                builder: (builder) {
                  return DraggableScrollableSheet(
                      initialChildSize: 0.4,
                      minChildSize: 0.4,
                      maxChildSize: 0.8,
                      expand: false,
                      builder: (BuildContext context,
                          ScrollController scrollController) {
                        return SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Select ${widget.label}',
                                      style: TextStyle(
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.bold)),
                                ),
                                ...items.map((e) {
                                  return ListTile(
                                    tileColor: widget.selectCheck(e)
                                        ? Colors.blue
                                        : Colors.white,
                                    title: Text(widget.itemAsString(e),
                                        style: TextStyle(
                                          color: widget.selectCheck(e)
                                              ? Colors.white
                                              : Colors.black,
                                        )),
                                    onTap: () {
                                      if (widget.selectCheck(e)) {
                                        widget.onChanged(e);
                                      } else {
                                        widget.onChanged(e);
                                      }
                                      Navigator.pop(context);
                                    },
                                  );
                                })
                              ]),
                        );
                      });
                })
            : ToastMessage(message: 'Loading ${widget.label}');
      },
      child: Builder(builder: (context) {
        return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.grey[300]!,
                )),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.label,
                      style: TextStyle(fontSize: 11, color: Colors.grey)),
                  SizedBox(width: 3),
                  Icon(
                    Icons.arrow_downward,
                    color: Colors.grey,
                    size: 16,
                  ),
                ],
              ),
            ));
      }),
    );
  }
}
