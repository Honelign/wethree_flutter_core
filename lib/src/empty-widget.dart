import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({this.message}) ;

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 220,
            width: 220,
            child: FlareActor(
                "packages/wethree_flutter_core/assets/empty_not_found_404.flr",
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: "idle"),
          ),
          Text(message ?? "No Data Found",
              style:
                  TextStyle(color: Colors.black54, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}
