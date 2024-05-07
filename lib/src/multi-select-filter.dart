import 'package:flutter/material.dart';
import 'package:wethree_flutter_core/wethree_flutter_core.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

typedef ItemAsString<T> = String Function(T item);
typedef TfromJson<T> = T Function(Map item);

class MultiSelectFilter<T> extends StatefulWidget {
  const MultiSelectFilter(
      {
      required this.itemAsString,
      required this.apiUrl,
      required this.modelFromJson,
      this.initialValues,
      this.params,
      required this.label,
      required this.onChanged})
    ;
  final ItemAsString<T> itemAsString;
  final ValueChanged<List<T>> onChanged;
  final List<T>? initialValues;
  final String apiUrl;
  final Map? params;
  final String label;
  final TfromJson modelFromJson;

  @override
  State<MultiSelectFilter<T>> createState() => _MultiSelectFilterState<T>();
}

class _MultiSelectFilterState<T> extends State<MultiSelectFilter<T>> {
  List<T> items = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    if (this.mounted)
      setState(() {
        isLoading = true;
      });
    var data = await DataService.get("api/${widget.apiUrl}",
        params: widget.params as Map<String, String>? ??
                    <String, String>{
                      "perPage": '100',
                      "num_items": '100',
                      "page": "1",
                      "lastPage": "1",
                    });
    items = List<T>.from(data['data']?.map((x) => widget.modelFromJson(x)));
    if (widget.apiUrl == 'users') {
      setUserAssignee();
    }
    if (this.mounted)
      setState(() {
        isLoading = false;
      });
  }

  setUserAssignee() {
    if (widget.initialValues!.isNotEmpty) {
      widget.initialValues![0] = items.firstWhere(
          (element) =>
              (element as dynamic).id ==
              (widget.initialValues!.first as dynamic).id,
            orElse: () => null as T);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4),
      child: InkWell(
        onTap: () async {
          if (!isLoading) {
            await showModalBottomSheet(
              barrierColor: Color(0xff244556).withAlpha(140),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              isScrollControlled: true,
              clipBehavior: Clip.antiAlias,
              context: context,
              builder: (ctx) {
                return MultiSelectBottomSheet<T>(
                  items: items
                      .map((e) => MultiSelectItem(e, widget.itemAsString(e)))
                      .toList(),
                  cancelText: Text(''),
                  searchable: true,
                  separateSelectedItems: true,
                  initialValue: widget.initialValues ?? [],
                  onConfirm: (values) {
                    widget.onChanged(values);
                  },
                  maxChildSize: 0.8,
                );
              },
            );
          }
        },
        child: Container(
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
            )),
      ),
    );
  }
}
