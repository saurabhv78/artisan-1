import 'package:Artisan/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BackBtn extends ConsumerWidget {
  final VoidCallback onTap;
  final Color? iconColor;
  const BackBtn({
    super.key,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      child: GestureDetector(
        onTap: () {
          onTap();
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: 38,
          width: 38,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.red.withOpacity(0.3),
            border: Border.all(
              width: 0.5,
              color: subHead,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Center(
              child: Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: iconColor ?? Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
