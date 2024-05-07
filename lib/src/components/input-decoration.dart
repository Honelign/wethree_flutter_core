import 'package:flutter/material.dart';

InputDecoration inputDecoration(String label,
    {IconData? prefixIcon,
    IconData? suffixIcon,
    Widget? suffixWidget,
    bool isMultiLine = false,
    Color? borderColor,
    bool enableBorder = false,
    EdgeInsetsGeometry? contentPadding,
    String? helperText}) {
  return InputDecoration(
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Colors.red,
        width: 1.0,
      ),
    ),
    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200]!)),
    filled: true,
    helperText: helperText,
    helperStyle: TextStyle(color: Colors.grey, fontSize: 14),
    labelStyle: TextStyle(fontSize: 14),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: enableBorder
            ? BorderSide(color: Colors.grey[300]!)
            : BorderSide.none),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: borderColor ?? Color(0xffff7f00),
        width: 1.0,
      ),
    ),
    labelText: label,
    prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 15) : null,
    suffixIcon: suffixIcon != null ? Icon(suffixIcon) : suffixWidget,
    contentPadding: contentPadding ??
        EdgeInsets.symmetric(horizontal: 6,
          vertical: isMultiLine ? 16 : 0.0,
        ),
  );
}
