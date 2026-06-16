import 'package:flutter/material.dart';

const Color appBlue = Color(0xFF1976D2);
const Color appGrey = Color(0xFF9E9E9E);
const Color appLightGrey = Color(0xFFF5F5F5);

const Color _blue = appBlue;
const Color _grey = appGrey;
const Color _lightGrey = appLightGrey;

Theme pickerTheme(BuildContext context, Widget? child) {
  return Theme(
    data: Theme.of(context).copyWith(
      colorScheme: const ColorScheme.light(
        primary: _blue,
        onPrimary: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black,
        secondary: _grey,
        onSecondary: Colors.white,
      ),
      dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
      datePickerTheme: const DatePickerThemeData(
        backgroundColor: Colors.white,
        headerBackgroundColor: _blue,
        headerForegroundColor: Colors.white,
        todayForegroundColor: WidgetStatePropertyAll(_blue),
        todayBackgroundColor: WidgetStatePropertyAll(_lightGrey),
        yearForegroundColor: WidgetStatePropertyAll(Colors.black),
        yearBackgroundColor: WidgetStatePropertyAll(Colors.white),
      ),
      timePickerTheme: const TimePickerThemeData(
        backgroundColor: Colors.white,
        dialBackgroundColor: _lightGrey,
        dialHandColor: _blue,
        dialTextColor: Colors.black,
        hourMinuteColor: _lightGrey,
        hourMinuteTextColor: Colors.black,
        dayPeriodColor: _lightGrey,
        dayPeriodTextColor: Colors.black,
        entryModeIconColor: _grey,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: _blue),
      ),
    ),
    child: child!,
  );
}
