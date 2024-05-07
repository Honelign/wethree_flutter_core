import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
class NoData extends StatefulWidget {
  final String? text;
  NoData([this.text]);
  //Uses a Ticker Mixin for Animations
  @override
  _EmptyState createState() => _EmptyState(this.text??'');
}

class _EmptyState extends State<NoData> with SingleTickerProviderStateMixin {
  String text;
  _EmptyState([this.text = '']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
                child: Container(
                    child: FlareActor("assets/empty_not_found_404.flr",
                        alignment: Alignment.center,
                        fit: BoxFit.contain,
                        animation: "idle"))),
            Text(text != null ? text : 'Empty'),
          ],
        ),
      ),
    );
  }
}
