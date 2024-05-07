import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

ScrollController useScrollControllerForListing(Function reloadFunction) {
  return use(_ListScrollController(reloadFunction: reloadFunction));
}

class _ListScrollController extends Hook<ScrollController> {
  _ListScrollController({
    required this.reloadFunction,
  });

  final Function reloadFunction;
  @override
  __ListScrollControllerState createState() => __ListScrollControllerState();
}

class __ListScrollControllerState
    extends HookState<ScrollController, _ListScrollController> {
  ScrollController _scrollController = ScrollController();
  @override
  void initHook() {
    super.initHook();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        hook.reloadFunction();
      }
    });
  }

  @override
  ScrollController build(BuildContext context) {
    return _scrollController;
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
