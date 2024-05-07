import 'package:wethree_flutter_core/wethree_flutter_core.dart';

typedef ResetItemsList<T> = bool Function(T item, dynamic controllerItem);
typedef ModelBuilder<T> = T Function(dynamic data);

class PaginatedApiController<T> {
  final PaginationController? controller;
  final ResetItemsList<T>? resetItems;
  final Function? notifyListeners;
  final ModelBuilder<T>? modelBuilder;
  final String? api;
  final Map<String, String>? params;
  PaginatedApiController(
      {this.modelBuilder,
      this.controller,
      this.api,
      this.params,
      this.notifyListeners,
      this.resetItems}) {
    loadData();
  }
  loadData() async {
    addDatatoList(data, {bool isCache = false}) {
      List<T> items = [];

      for (int i = 0; i < data['data'].length; i++) {
        items.add(modelBuilder!(data['data'][i]));
      }
      if (!isCache)
        items.forEach((e) {
          controller!.controller?.itemList?.removeWhere((element) => resetItems!(e, element));
        });
      controller?.paginateController!(data['last_page'], items, isCache: isCache);
      notifyListeners!();
    }

    var data = await DataService.getCache(api??'');
    if (data != null) {
      addDatatoList(data, isCache: true);
    }

    data = await DataService.get(api??'', params: params, enableCache: true);
    addDatatoList(data);
  }
}
