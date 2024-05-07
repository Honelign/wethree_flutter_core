import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../wethree_flutter_core.dart';

typedef TableRowBuilder<T> = List<Widget> Function(T item);
typedef OnTap<T> = Function Function(T item);

class TableBuilder<T> extends HookWidget {
  TableBuilder(
      {required this.tableHeaders,
      required this.stream,
      required this.flexValues,
      required this.rowBuilder,
      this.onTap,
      required this.nextPage});
  final List<String> tableHeaders;
  final List<int> flexValues;
  final Stream<List<T>> stream;
  final VoidCallback nextPage;
  final TableRowBuilder<T> rowBuilder;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollControllerForListing(() {
      nextPage();
    });
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ...tableHeaders
                  .asMap()
                  .map((key, value) => MapEntry(
                      key,
                      Expanded(
                        flex: flexValues[key],
                        child: Text(value,
                            style: TextStyle(
                                color: Colors.black38,
                                fontWeight: FontWeight.bold)),
                      )))
                  .values
                  .toList(),
            ],
          ),
        ),
        StreamBuilder<List<T>>(
            stream: stream,
            builder: (context, snapshot) {
              return Container(
                height: 200,
                child: ListItemsBuilder<T>(
                    controller: scrollController,
                    snapshot: snapshot,
                    itemBuilder: (context, item, index) => InkWell(
                          onTap: onTap != null
                              ? () {
                                  onTap!(item);
                                }
                              : null,
                          child: Container(
                            color: index % 2 == 1
                                ? Colors.grey[100]
                                : Colors.transparent,
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, top: 8, bottom: 8),
                                child: Row(
                                  children: [
                                    for (int i = 0; i < flexValues.length; i++)
                                      Expanded(
                                          flex: flexValues[i],
                                          child: rowBuilder(item)[i])
                                  ],
                                )),
                          ),
                        )),
              );
            }),
      ],
    );
  }
}
