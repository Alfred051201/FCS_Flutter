import 'package:fcs_flutter/utils/theme/appbar_theme.dart';
import 'package:fcs_flutter/utils/theme/elevated_button_theme.dart';
import 'package:fcs_flutter/utils/theme/text_field_theme.dart';
import 'package:flutter/material.dart';

class TAppTheme {
  static ThemeData theme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: TAppBarTheme.appBarTheme,
    elevatedButtonTheme: TElevatedButtonTheme.elevatedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.inputDecorationTheme,
  );
}