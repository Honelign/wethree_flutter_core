import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateField extends StatelessWidget {
  const DateField(
      {
      this.onSaved,
      this.onChanged,
      this.validator,
      this.labelText,
      this.initialValue});


  final Function(DateTime)? onSaved;
  final Function(DateTime)? onChanged;

  final String Function(DateTime)? validator;
  final String? labelText;
  final DateTime? initialValue;

  @override
  Widget build(BuildContext context) {
    return DateTimeField(
      decoration: InputDecoration(
        border:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200]!)),
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
        prefixIcon: Icon(Icons.date_range),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 7.0, horizontal: 10),
      ),
      resetIcon: Icon(Icons.highlight_off, color: Colors.grey),
      format: DateFormat('yyyy-MMM-dd'),
      validator: validator as String? Function(DateTime?)?,
      initialValue: initialValue,
      onSaved: onSaved as void Function(DateTime?)?,
      onChanged: onChanged as void Function(DateTime?)?,
      onShowPicker: (context, currentValue) {
        return showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100));
      },
    );
  }
}
