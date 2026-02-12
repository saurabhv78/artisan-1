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

void showAlertBox(BuildContext context, String message) {
  // Close any existing dialog
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  }

  showDialog(
    context: context,
    barrierDismissible: false, // user cannot tap outside to close
    builder: (context) {
      // Auto close after 20 seconds
      Future.delayed(const Duration(seconds: 20), () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      });

      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                message,
                style: const TextStyle(fontSize: 16),
              ),
            ),

            // Top-right close icon
            Positioned(
              right: 8,
              top: 8,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.close,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
