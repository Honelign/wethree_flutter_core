import 'package:flutter/material.dart';
import 'package:wethree_flutter_core/src/empty-widget.dart';

typedef ItemWidgetBuilder<T> = Widget Function(
    BuildContext context, T item, int index);

class ListItemsBuilder<T> extends StatefulWidget {
  const ListItemsBuilder(
      {
      required this.snapshot,
      required this.itemBuilder,
      this.physics,
      this.shrinkWrap,
     required this.controller,
      this.emptyMessage})
    ;
  final AsyncSnapshot<List<T>> snapshot;

  final ItemWidgetBuilder<T>? itemBuilder;
  final ScrollController controller;
  final String? emptyMessage;
  final ScrollPhysics? physics;
  final bool? shrinkWrap;

  @override
  _ListItemsBuilderState<T> createState() => _ListItemsBuilderState<T>();
}

class _ListItemsBuilderState<T> extends State<ListItemsBuilder<T>> {
  @override
  Widget build(BuildContext context) {
    if (widget.snapshot.hasData) {
      final List<T>? items = widget.snapshot.data;

      if (items!.isNotEmpty) {
        return _buildList(items, context, widget.controller!);
      } else {
        return EmptyList(message: widget.emptyMessage ?? 'No Data Found');
      }
    } else if (widget.snapshot.hasError) {
      return Center(child: Container(child: Text('Error Loading')));
    }
    return Center(
        child: Container(
            child: Image.asset(
              "assets/images/logo.gif",
              package: 'wethree_flutter_core',
            ),
            color: Colors.transparent));
  }

  Widget _buildList(List<T> items, BuildContext context,
      [ScrollController? controller]) {
    return ListView.builder(
      shrinkWrap: widget.shrinkWrap ?? false,
      controller: controller ?? null,
      physics: widget.physics ?? BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) =>
          widget.itemBuilder!(context, items[index], index),
    );
  }
}
