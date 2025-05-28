// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<T?> showAdaptiveAlertDialog<T>({
  required BuildContext context,
  required Widget Function(BuildContext context) builder,
  bool barrierDismissible = true,
}) {
  return Platform.isIOS
      ? showCupertinoDialog<T>(
          barrierDismissible: barrierDismissible,
          context: context,
          builder: builder,
        )
      : showDialog<T>(
          barrierDismissible: barrierDismissible,
          context: context,
          barrierColor: Colors.black.withOpacity(0.3),
          builder: (context) => WillPopScope(
            onWillPop: () async => barrierDismissible,
            child: builder(context),
          ),
        );
}
