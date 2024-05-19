import 'package:flutter/material.dart';
import 'package:mmc_test/src/constants/sizedbox_constants.dart';
import 'package:mmc_test/src/constants/string_constants.dart';

class UITextField extends StatefulWidget {
  final TextEditingController? controller;
  final bool readOnly;
  final String? hintText;
  final String? labelText;
  final bool enableEmptyValidation;

  const UITextField(
   {
    super.key,
     this.controller,
     this.readOnly = false,
    this.hintText,
    this.labelText,
    this.enableEmptyValidation = false,
  });

  @override
  State<UITextField> createState() => _UITextFieldState();
}

class _UITextFieldState extends State<UITextField> {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.readOnly ? 0.5 : 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _showLabelText(widget.labelText),
          if (widget.labelText != null) SizedBoxConstants.fourH(),
          Center(child: textField()),
        ],
      ),
    );
  }

  Widget textField() {
    final outlineInputBorder = OutlineInputBorder(
      borderSide: const BorderSide(
        color:
            // Colors.yellow ??
            Colors.grey,
      ),
      borderRadius: BorderRadius.circular(20),
    );
    final outlineInputBorderError = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red),
      borderRadius: BorderRadius.circular(20),
    );
    return TextFormField(
      maxLines: 1,
      controller: widget.controller,
      readOnly: widget.readOnly,
      maxLength: 25,
      style: const TextStyle(fontSize: 14),
      validator: (value) {
        if(widget.readOnly) return null;
        if ((value ?? '').trim().isEmpty) {
          return '${StringConstants.errorThisFieldCantBeEmpty} ';
        }
        return null;
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        errorStyle: const TextStyle(fontSize: 13),
        counterText: '',
        errorMaxLines: 2,
        fillColor: Colors.red,
        enabledBorder: outlineInputBorder,
        disabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        errorBorder: outlineInputBorderError,
        focusedErrorBorder: outlineInputBorderError,
        contentPadding: const EdgeInsetsDirectional.only(
          start: 10,
          top: 17,
          bottom: 17,
          end: 16,
        ),
        border: InputBorder.none,
        hintText: widget.hintText ?? '',
        hintStyle: TextStyle(
          color: Colors.grey.withOpacity(.7),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

Widget _showLabelText(String? text) {
  const labelTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  if (text != null) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          Text(
            text,
            style: labelTextStyle,
          ),
          const Text(
            '*',
            style: labelTextStyle,
          ),
        ],
      ),
    );
  } else {
    return const SizedBox();
  }
}
