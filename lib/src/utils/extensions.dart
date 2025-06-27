import 'package:flutter/material.dart';

extension WidgetExt on Widget {
  Widget safe([
    EdgeInsetsGeometry padding = const EdgeInsets.all(0),
  ]) {
    return Builder(builder: (context) {
      return Padding(
        padding: padding,
        child: MediaQuery.removePadding(
          context: context,
          // removeTop: true,
          // removeBottom: true,
          child: this,
        ),
      );
    });
  }
}
