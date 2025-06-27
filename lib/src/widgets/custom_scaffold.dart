import 'package:Artisan/src/constants/colors.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomScaffold extends ConsumerStatefulWidget {
  final Widget child;
  final Color bgColor;
  const CustomScaffold({
    super.key,
    required this.child,
    this.bgColor = const Color(0xffEFE4FF),
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends ConsumerState<CustomScaffold> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.bgColor,
      child: Padding(
        padding: const EdgeInsets.only(top: 0), // TODO: was 28
        child: Scaffold(
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
        )),
      ),
    );
  }
}
