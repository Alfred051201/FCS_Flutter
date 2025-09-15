import 'package:flutter/material.dart';

class TAppBarTheme {
  TAppBarTheme._();

  static const appBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    backgroundColor: Colors.transparent,
    iconTheme: IconThemeData(color: Colors.black, size: 18.0),
    actionsIconTheme: IconThemeData(color: Colors.black, size: 18.0)
  );
}