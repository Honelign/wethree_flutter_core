import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wethree_flutter_core/wethree_flutter_core.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PaginationController {
  int? pageKey;
  Function(int, List<dynamic>, {bool isCache})? paginateController;
  PagingController? controller;

  PaginationController(
      {this.pageKey, this.paginateController, this.controller});
}

typedef FetchData = Function(
  PaginationController controller,
);

typedef WidgetBuilder<T> = Widget Function(
    BuildContext context, T item, int index);

class PaginatedList<T> extends StatefulWidget {
  PaginatedList(
      {required this.fetchData,
      this.watchBloc,
      this.emptyMessage,
      required this.itemBuilder,
      required this.controller});
  final PagingController controller;
  final FetchData fetchData;
  final WidgetBuilder<T> itemBuilder;
  final String? emptyMessage;
  final dynamic watchBloc;

  @override
  _PaginatedListState<T> createState() => _PaginatedListState<T>();
}

class _PaginatedListState<T> extends State<PaginatedList<T>> {
  PagingController? _pagingController;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    _pagingController = widget.controller;
    _pagingController!.addPageRequestListener((pageKey) {
      currentPage = pageKey;
      widget.fetchData(PaginationController(
          pageKey: pageKey,
          paginateController:
              paginate as dynamic Function(int, List<dynamic>, {bool isCache})?,
          controller: _pagingController));
    });
  }

  @override
  void dispose() {
    _pagingController!.dispose();
    super.dispose();
  }

  void updateList() {
    _pagingController?.refresh();
  }

  void paginate(int lastPage, List<T> items, {bool isCache = false}) {
    final isLastPage = currentPage < lastPage;
    if (isLastPage) {
      if (isCache) {
        _pagingController?.appendPage(items, currentPage);
      }
      final nextPageKey = ++currentPage;
      _pagingController?.appendPage(items, nextPageKey);
    } else {
      _pagingController?.appendLastPage(items);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, __) {
        if (widget.watchBloc != null) ref.watch(widget.watchBloc);

        return PagedListView<int, T>(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          pagingController: _pagingController as PagingController<int, T>,
          cacheExtent: 200,
          builderDelegate: PagedChildBuilderDelegate<T>(
            noMoreItemsIndicatorBuilder: (context) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text('..That\'s all..',
                      style: TextStyle(color: Colors.grey, fontSize: 12))),
            ),
            itemBuilder: (context, item, index) =>
                widget.itemBuilder(context, item, index),
            firstPageErrorIndicatorBuilder: (context) => EmptyList(
              message: _pagingController?.error,
            ),
            newPageProgressIndicatorBuilder: (context) => Spinner(),
            firstPageProgressIndicatorBuilder: (context) => LoaderAnimation(),
            animateTransitions: true,
            noItemsFoundIndicatorBuilder: (context) => EmptyList(
              message: widget.emptyMessage,
            ),
          ),
        );
      },
    );
  }
}
