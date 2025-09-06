import 'package:Artisan/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomScaffold extends ConsumerStatefulWidget {
  final Widget child;
  final Color bgColor;
  final Widget? floatingActionButton;
  final double? topPadding; // 👈 optional top padding

  const CustomScaffold({
    super.key,
    required this.child,
    this.bgColor = const Color(0xffEFE4FF),
    this.floatingActionButton,
    this.topPadding, // 👈 default null = no padding
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends ConsumerState<CustomScaffold> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.bgColor,
      child: Padding(
        padding: EdgeInsets.only(
            top: widget.topPadding ?? 0), // 👈 apply only if given
        child: Scaffold(
          floatingActionButton: widget.floatingActionButton,
          body: Stack(
            children: [
              Container(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                decoration: const BoxDecoration(
                  gradient: backgroundGradient,
                ),
              ),
              widget.child,
            ],
          ),
        ),
      ),
    );
  }
}
