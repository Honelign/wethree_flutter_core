import 'package:flutter/material.dart';
import 'package:wethree_flutter_core/wethree_flutter_core.dart' as core;
import 'package:wethree_flutter_core/src/scrolling-loader.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

typedef BuilderWidget<T> = Widget Function(
    BuildContext context, T item, int index);
typedef Fetch = Function(int pageKey);

class PaginatedListView<T> extends StatefulWidget {
  PaginatedListView(
      {required this.fetchData,
      this.physics,
      this.emptyMessage,
      required this.itemBuilder,
      this.noMoreItemsMessage,
      this.emptyWidget,
      this.isGridView = false,
      required this.controller});
  final PagingController controller;
  final Fetch fetchData;
  final BuilderWidget<T> itemBuilder;
  final String? emptyMessage;
  final String? noMoreItemsMessage;
  final Widget? emptyWidget;
  final ScrollPhysics? physics;
  final bool isGridView;
  @override
  _PaginatedListViewState<T> createState() => _PaginatedListViewState<T>();
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>> {
  PagingController? _pagingController;

  @override
  void initState() {
    super.initState();
    _pagingController = widget.controller;
    _pagingController?.addPageRequestListener((pageKey) async {
      List<T> items = await widget.fetchData(pageKey);
      paginate(items, pageKey);
    });
  }

  @override
  void dispose() {
    _pagingController?.dispose();
    super.dispose();
  }

  void updateList() {
    _pagingController?.refresh();
  }

  void paginate(List<T> items, int pageKey, {bool isCache = false}) {
    bool isLastPage = items.length < 25;
    if (!isLastPage) {
      if (isCache) {
        _pagingController?.appendPage(items, pageKey);
      }
      final nextPageKey = ++pageKey;
      _pagingController?.appendPage(items, nextPageKey);
    } else {
      _pagingController?.appendLastPage(items);
    }
  }

  @override
  Widget build(BuildContext context) {
    return !widget.isGridView
        ? PagedListView<int, T>(
            shrinkWrap: true,
            physics: widget.physics,
            pagingController: _pagingController as PagingController<int, T>,
            builderDelegate: PagedChildBuilderDelegate<T>(
              noMoreItemsIndicatorBuilder: (context) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(widget.noMoreItemsMessage ?? '..That\'s all..',
                        style: TextStyle(color: Colors.grey, fontSize: 12))),
              ),
              itemBuilder: (context, item, index) =>
                  widget.itemBuilder(context, item, index),
              firstPageErrorIndicatorBuilder: (context) => core.EmptyList(
                message: _pagingController?.error,
              ),
              newPageProgressIndicatorBuilder: (context) =>
                  ScrollingLoaderAnimation(),
              firstPageProgressIndicatorBuilder: (context) =>
                  core.LoaderAnimation(),
              animateTransitions: true,
              noItemsFoundIndicatorBuilder: (context) =>
                  widget.emptyWidget ??
                  core.EmptyList(
                    message: widget.emptyMessage,
                  ),
            ),
          )
        : PagedGridView<int, T>(
            shrinkWrap: true,
            physics: widget.physics,
            pagingController: _pagingController as PagingController<int, T>,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
            ),
            builderDelegate: PagedChildBuilderDelegate<T>(
              noMoreItemsIndicatorBuilder: (context) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(widget.noMoreItemsMessage ?? '..That\'s all..',
                        style: TextStyle(color: Colors.grey, fontSize: 12))),
              ),
              itemBuilder: (context, item, index) =>
                  widget.itemBuilder(context, item, index),
              firstPageErrorIndicatorBuilder: (context) => core.EmptyList(
                message: _pagingController?.error,
              ),
              newPageProgressIndicatorBuilder: (context) =>
                  Center(child: ScrollingLoaderAnimation()),
              firstPageProgressIndicatorBuilder: (context) =>
                  core.LoaderAnimation(),
              animateTransitions: true,
              noItemsFoundIndicatorBuilder: (context) =>
                  widget.emptyWidget ??
                  core.EmptyList(
                    message: widget.emptyMessage,
                  ),
            ),
          );
  }
}
