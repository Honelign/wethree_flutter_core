import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wethree_flutter_core/wethree_flutter_core.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_dropdown_search/reactive_dropdown_search.dart';

typedef LabelBuilder<T> = String Function(T item);

void onLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spinner(),
          ],
        ),
      );
    },
  );
}

Widget textForm(String control, String label, String validation,
    {TextInputType? keyboardType, bool isPassword = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: ReactiveTextField<String>(
      
      obscureText: isPassword,
      keyboardType: keyboardType,
      maxLines: keyboardType == TextInputType.multiline ? 4 : 1,
      formControlName: control,
      decoration: inputDecoration(label,
          isMultiLine: keyboardType == TextInputType.multiline),
      validationMessages: {
        ValidationMessage.required: (errors) => '$validation is required.',
        ValidationMessage.email: (errors) => 'Invalid email address',
        ValidationMessage.mustMatch: (errors) => 'Passwords do not match',
        ValidationMessage.minLength: (errors) => 'The password must be at least 8 characters long.',
      },
    ),
  );
}

Widget dateForm(String control, String label, String validation) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: ReactiveDateTimePicker(
      formControlName: control,
      firstDate: DateTime(1985),
      lastDate: DateTime(2030),
      decoration: inputDecoration(label),
      type: ReactiveDatePickerFieldType.date,
      validationMessages: {
        ValidationMessage.required: (errors) => '$validation is required.',
      },
    ),
  );
}

Widget checkBoxForm(String control) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: ReactiveCheckbox(
      formControlName: control,
    ),
  );
}

class SingleSelectDropdown<T> extends StatelessWidget {
  const SingleSelectDropdown(
      {required this.control,
      required this.label,
      required this.labelBuilder,
      required this.api,
      required this.modelFromJson,
      this.params});
  final String control;
  final String label;
  final LabelBuilder<T> labelBuilder;
  final TfromJson modelFromJson;
  final String api;
  final Map<String, String>? params;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ReactiveDropdownSearch(
        formControlName: control,
        dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: inputDecoration(label)),
        itemAsString: labelBuilder as String Function(dynamic)?,
        asyncItems: getData,
        showClearButton: true,
      ),
    );
  }

  Future<List> getData(String query) async {
    var data = await DataService.get(api, params: params);
    var models = [];
    models = List<T>.from((data['data'] as List).map((x) => modelFromJson(x)));
    return models;
  }
}
