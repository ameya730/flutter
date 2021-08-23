import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gshala/const.dart';

class CustomTextField extends StatelessWidget {
  final Function(String?)? onChanged;
  final onSaved;
  final String? cLabelText;
  final validator;
  final keyboardtype;
  final controller;
  final String? initialvalue;
  final int? maxlines;
  final int? minlines;
  final int? maxlength;
  final double? height;
  final bool? enabled;
  final double? width;
  final bool? obscureText;
  final Widget? icon;
  final Function? onTap;
  final double? vertical;

  CustomTextField({
    this.onChanged,
    this.onSaved,
    this.cLabelText,
    this.validator,
    this.keyboardtype,
    this.controller,
    this.initialvalue,
    this.maxlines,
    this.minlines,
    this.maxlength,
    this.height,
    this.enabled,
    this.width,
    this.obscureText = false,
    this.icon,
    this.onTap,
    this.vertical = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 8.0,
        bottom: 8.0,
      ),
      child: Container(
        height: height,
        width: width,
        child: TextFormField(
          initialValue: initialvalue,
          onSaved: onSaved,
          onChanged: onChanged,
          validator: validator,
          keyboardType: keyboardtype,
          controller: controller,
          minLines: minlines,
          maxLines: maxlines,
          maxLength: maxlength,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          enabled: enabled,
          obscureText: obscureText!,
          decoration: InputDecoration(
            suffixIcon: icon,
            fillColor: textBoxBackgroundColor,
            filled: true,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 10, vertical: vertical!),
            hintText: cLabelText,
            hintStyle: TextStyle(
              color: Colors.black87,
              fontSize: 10,
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: new BorderSide(color: textBoxBackgroundColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: new BorderSide(color: textBoxBackgroundColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: new BorderSide(color: textBoxBackgroundColor),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: new BorderSide(color: textBoxBackgroundColor),
            ),
          ),
          style: TextStyle(
            color: Colors.black87,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
