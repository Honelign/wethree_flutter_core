import 'package:wethree_flutter_core/wethree_flutter_core.dart';

import 'package:flutter/material.dart';

class LogoutWidget extends StatefulWidget {
  const LogoutWidget({required this.landingPage, this.onLoggedOut})
  ;
  final Widget landingPage;
  final VoidCallback? onLoggedOut;
  @override
  _LogoutWidgetState createState() => _LogoutWidgetState();
}

class _LogoutWidgetState extends State<LogoutWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.2,
        width: size.width * 0.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Logout',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold)),
            Text('Are you sure you want to logout?',
                style: TextStyle(color: Colors.grey, fontSize: 14)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (widget.onLoggedOut != null) widget.onLoggedOut!();
                    await AuthService.logout().then((value) =>
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => widget.landingPage),
                            (Route<dynamic> route) => false));
                  },
                  child: Text('Logout', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    elevation: 8,
                  ),
                )
              ],
            )
          ],
        ));
  }
}
