import 'package:flutter/material.dart';

class SubmitButton extends StatefulWidget {
  final Function onPressed;
  final String text;
  final Color? color;
  SubmitButton({required this.onPressed, required this.text, this.color});
  @override
  _SubmitButtonState createState() => _SubmitButtonState(this.text);
}

class _SubmitButtonState extends State<SubmitButton> {
  String _buttonText;
  _SubmitButtonState(this._buttonText);
  bool isLoading = false;
  _doSubmit() async {
    setState(() {
      isLoading = true;
    });
    await widget.onPressed();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.color ?? Colors.blueGrey,
        elevation: 8,
        textStyle: TextStyle(color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
      ),
      onPressed: () async {
        await _doSubmit();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: FittedBox(
          fit: BoxFit.fill,
          child: isLoading
              ? Container(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Text(
                  _buttonText,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
        ),
      ),
    );
  }
}
