import 'package:flutter/material.dart';
import 'package:gshala/const.dart';

class CustomDropDownField extends StatelessWidget {
  const CustomDropDownField({
    @required this.dropList,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.hinttext,
    this.height,
    this.width,
    this.left = 16.0,
    this.right = 16.0,
    this.dropDownValue,
  });

  final List? dropList;
  final onSaved;
  final Function(void)? onChanged;
  final validator;
  final String? hinttext;
  final double? height;
  final double? width;
  final double left;
  final double right;
  final String? dropDownValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: left, right: right),
      child: Container(
        height: height,
        width: width,
        child: DropdownButtonFormField(
          style: TextStyle(
            color: Colors.black87,
            fontSize: 12,
          ),
          decoration: InputDecoration(
            fillColor: textBoxBackgroundColor,
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 7, vertical: 10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: new BorderSide(color: textBoxBackgroundColor),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: new BorderSide(color: textBoxBackgroundColor),
            ),
            hintText: hinttext,
            hintStyle: TextStyle(
              color: Colors.black87,
              fontSize: 12,
            ),
          ),
          value: dropDownValue,
          items: dropList!.map((e) {
            return DropdownMenuItem(
              child: Text(e),
              value: e,
            );
          }).toList(),
          onChanged: onChanged,
          onSaved: onSaved,
          validator: validator,
        ),
      ),
    );
  }
}
