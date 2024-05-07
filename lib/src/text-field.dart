import 'package:flutter/material.dart';

class TextForm extends StatelessWidget {
  const TextForm({
    this.onSaved,
    this.validator,
    this.labelText,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.initialValue,
    this.keyboardType,
    this.onFieldSubmitted,
    this.autofocus,
    this.enabled,
    this.decoration,
    this.hintText,
  });

  final Function(String)? onSaved;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;

  final Function(String)? validator;
  final String? labelText;
  final Icon? prefixIcon;
  final Icon? suffixIcon;

  final String? initialValue;
  final TextInputType? keyboardType;
  final bool? enabled;
  final bool? autofocus;
  final InputDecoration? decoration;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      keyboardType: keyboardType,
      initialValue: initialValue,
      onSaved: onSaved as void Function(String?)?,
      onChanged: onChanged,
      autofocus: autofocus ?? false,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator as String? Function(String?)?,
      decoration: decoration ??
          InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[200]!)),
            filled: true,
            labelStyle: TextStyle(fontSize: 14),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Color(0xffff7f00),
                width: 1.0,
              ),
            ),
            labelText: labelText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 7.0, horizontal: 10),
          ),
    );
  }
}
