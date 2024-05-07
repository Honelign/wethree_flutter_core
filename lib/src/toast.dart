import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessage {
  ToastMessage(
      {required this.message, this.useTheme, this.isLongerLength = false}) {
    toast(message, isLongerLength, useTheme: useTheme ?? false);
  }

  final String message;
  final bool? useTheme;
  final bool isLongerLength;

  static Future toast(String msg, bool isLong,
      {bool useTheme = false}) {
    return Fluttertoast.showToast(
      backgroundColor: useTheme ? Colors.blue : null,
      textColor: useTheme ? Colors.white : null,
      msg: msg,
      toastLength: isLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
