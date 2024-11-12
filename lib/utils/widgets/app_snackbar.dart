import 'package:flutter/material.dart';
import 'package:solar_monitoring/main.dart';

class AppSnackBar {
  showSnackBar({
    Color? color,
    String? text,
    Widget? child,
    Duration? duration,
    TextStyle? textStyle,
    EdgeInsetsGeometry? margin,
    double? elevation,
    ShapeBorder? shape,
  }) {
    assert(
    (text != null && child == null) || (text == null && child != null),
    'You must use only one of the two parameters (child or text)',
    );
    final snack = SnackBar(
      content: child ?? Center(child: Text(text ?? '', style: textStyle)),
      backgroundColor: color ?? Colors.green,
      elevation: elevation ?? 10,
      duration: duration ?? const Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      shape: shape,
    );
    scaffoldMessengerKey.currentState?.clearSnackBars();
    scaffoldMessengerKey.currentState?.showSnackBar(snack);
  }
}
