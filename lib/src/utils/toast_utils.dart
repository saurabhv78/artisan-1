// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// 📦 Package imports:

/// shows success message toast
showSuccessMessage(String message) => _showToast(
      message,
      Colors.black,
    );

showErrorMessage(String message) => _showToast(
      message,
      Colors.red,
      toastLength: message.length > 80 ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
    );

_showToast(
  String message,
  Color backgroundColor, {
  Toast? toastLength,
}) {
  // remove current toast, if any
  Fluttertoast.cancel();
  // show the snack bar
  Fluttertoast.showToast(
    msg: message,
    textColor: Colors.white,
    backgroundColor: backgroundColor,
    toastLength: toastLength,
  );
}
