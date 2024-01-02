import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  primaryColor: Color.fromRGBO(0, 226, 193, 1),
  hintColor: Colors.black,
  backgroundColor: Colors.white,
  // Add more properties as needed
);

final ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.black,
  hintColor: Color.fromRGBO(0, 226, 193, 1),
  backgroundColor: Colors.white,
  // You can customize dark theme properties here
);

// You can use a theme provider or manage the theme dynamically based on user preference
ThemeData getCurrentTheme(bool isDarkMode) {
  return isDarkMode ? darkTheme : lightTheme;
}
