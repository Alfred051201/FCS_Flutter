import 'package:fcs_flutter/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class TTextFormFieldTheme {

  TTextFormFieldTheme._();

  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(TSizes.borderRadius)
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(TSizes.borderRadius),
      borderSide: const BorderSide(width: 2),
    )
  );
}