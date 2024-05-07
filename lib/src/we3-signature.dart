import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class We3Signature extends StatefulWidget {
  We3Signature({ this.onSaved}) ;
  final ValueChanged<Uint8List>? onSaved;

  @override
  _We3SignatureState createState() => _We3SignatureState();
}

class _We3SignatureState extends State<We3Signature> {
  File? signatureFile;
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 4,
    penColor: Colors.blue,
    exportBackgroundColor: Colors.transparent,
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var _signatureCanvas = Signature(
      controller: _controller,
      width: size.width * 0.7,
      height: size.height * 0.35,
      backgroundColor: Colors.blueGrey[50]!,
    );
    _controller.clear();

    return Container(
      width: size.width < 800 ? size.width * 0.7 : size.width * 0.7,
      height: size.height < 450 ? size.height * 0.9 : size.height * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Sign Here',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              SizedBox(
                width: size.width * .24,
              ),
              TextButton(
                child: Text('clear'),
                onPressed: () => _controller.clear(),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(child: _signatureCanvas), //signature canvas
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox(height: 20),
                  TextButton(
                    child: Text('cancel'),
                    onPressed: () => Navigator.pop(context, null),
                  ),
                ],
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    onPressed: () async {
                      var signData = await _controller.toPngBytes();
                      widget.onSaved!(signData!);

                      if (widget.onSaved == null) {
                        Navigator.pop(context, signData);
                        setState(() {});
                      }
                    },
                    child: Text('Save', style: TextStyle(color: Colors.white)),
                  ))
            ],
          ),
          SizedBox(height: 10)
        ],
      ),
    );
  }
}
