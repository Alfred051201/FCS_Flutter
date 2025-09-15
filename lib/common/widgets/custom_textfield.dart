import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextfield extends StatelessWidget {
  
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  Icon? preIcon;
  Icon? suffIcon;
  bool obscure;

  CustomTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.preIcon,
    this.suffIcon,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscure,
      controller: controller,
      textAlign: TextAlign.start,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: preIcon,
        labelText: hintText,
        suffixIcon: suffIcon,
        alignLabelWithHint: true,
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Enter your $hintText';
        }
        return null;
      },
      maxLines: maxLines,
    );
  }
}