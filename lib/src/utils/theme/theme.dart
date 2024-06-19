import 'package:flutter/material.dart';
import 'package:visitors_log_project/src/utils/theme/widget_themes/text_theme.dart';

class tAppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: tTextTheme.lightTextTheme,
  );
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: tTextTheme.darkTextTheme,
  );
}
