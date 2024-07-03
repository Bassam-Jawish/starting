import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';

class VerificationCodePage extends StatelessWidget {
  VerificationCodePage(this.email,{Key? key}) : super(key: key);

  final String email;

  final TextEditingController _pinCode = TextEditingController();

  final FocusNode _pinCodeFocusNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: theme.background,
        // appBar: CustomProductAppBar('', width, height, context, true),
        // body: VerificationCodeBody(email, _pinCode, _formKey, _pinCodeFocusNode),
      ),
    );
  }
}