import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../wethree_flutter_core.dart';

class ChangePasswordDialog {
  ChangePasswordDialog({
    required this.context,
  }) {
    changePassword(context);
  }
  final BuildContext context;

  BlurDialog changePassword(context) {
    return BlurDialog(
        container: ChangePasswordWidget(
          context: context,
        ),
        context: context);
  }
}

class ChangePasswordWidget extends StatefulWidget {
  const ChangePasswordWidget({required this.context});
  final BuildContext context;
  @override
  State<ChangePasswordWidget> createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  String? _currentPassword;
  String? _updatedPassword;

  var _form = GlobalKey<FormState>();

  bool validateAndSaveForm() {
    var form = _form.currentState;
    if (form?.validate()??false) {
      form?.save();
      return true;
    }
    return false;
  }

  Future<void> updatePassword() async {
    if (validateAndSaveForm()) {
      await DataService.patch(
          'api/user/current/update-password', <String, String>{
        "currentPassword": _currentPassword??'',
        "newPassword": _updatedPassword??''
      }).then((value) {
        Fluttertoast.showToast(
          msg: 'Password Updated',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        Navigator.pop(widget.context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
        width: size.width * 0.8,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _form,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(widget.context),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Update Your Password',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ]),
                  SizedBox(height: 15),
                  TextFormField(
                    obscureText: true,
                    onSaved: (value) {
                      _currentPassword = value;
                    },
                    validator: (value) {
                      if (value!.isNotEmpty) return null;

                      return 'Current Password can\'t be empty';
                    },
                    decoration: inputDecoration('Current Password',
                        prefixIcon: Icons.lock_open),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                      obscureText: true,
                      onSaved: (value) {
                        _updatedPassword = value;
                      },
                      validator: (value) {
                        if (value!.isNotEmpty) return null;

                        return 'New Password can\'t be empty';
                      },
                      decoration: inputDecoration('New Password',
                          prefixIcon: Icons.lock)),
                  SizedBox(height: 10),
                  SubmitButton(
                      onPressed: () async {
                        FocusScope.of(widget.context).requestFocus(FocusNode());
                        await updatePassword();
                      },
                      text: 'Change Password'),
                ]),
          ),
        ));
  }
}
