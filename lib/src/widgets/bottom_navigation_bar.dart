import 'package:auto_route/auto_route.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';

class BottomBar extends ConsumerStatefulWidget {
  const BottomBar({
    super.key,
  });

  @override
  ConsumerState<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends ConsumerState<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(135, 225, 227, .24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 15,
                  color: Colors.black.withOpacity(.1),
                ),
              ],
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SafeArea(
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 25,
                      right: 25,
                      bottom: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _NavigationBarItem(
                          label: 'Home',
                          index: 0,
                          icon: 'assets/images/ic_home.png',
                          isActive: context.tabsRouter.activeIndex == 0,
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            context.tabsRouter.setActiveIndex(0);

                            setState(() {});
                          },
                        ),
                        _NavigationBarItem(
                          label: 'Explore',
                          icon: 'assets/images/ic_grid.png',
                          index: 1,
                          isActive: context.tabsRouter.activeIndex == 1,
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            context.tabsRouter.setActiveIndex(1);

                            // if (mounted) {
                            setState(() {});
                            // }/
                          },
                        ),
                        _NavigationBarItem(
                          label: 'Chat',
                          index: 2,
                          icon: 'assets/images/ic_chat.png',
                          isActive: context.tabsRouter.activeIndex == 2,
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            context.tabsRouter.setActiveIndex(2);

                            // if (mounted) {
                            setState(() {});
                            // }
                          },
                        ),
                        _NavigationBarItem(
                          label: 'Profile',
                          index: 3,
                          icon: 'assets/images/ic_user.png',
                          isActive: context.tabsRouter.activeIndex == 3,
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            if (mounted) {
                              setState(() {});
                            }
                            context.tabsRouter.setActiveIndex(3);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationBarItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final String icon;
  final VoidCallback onTap;
  final int? index;

  const _NavigationBarItem({
    required this.label,
    required this.isActive,
    required this.icon,
    required this.onTap,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? primaryColor : const Color(0xff89909A);

    return SizedBox(
      width: 70,
      height: 69,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 2,
              width: 60,
              color: isActive ? primaryColor : Colors.white,
            ),
            const Expanded(child: SizedBox()),
            Center(
              child: Image.asset(
                icon,
                color: color,
                height: 24,
                width: 24,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              label,
              style: GoogleFonts.nunitoSans(
                color: color,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                fontSize: 12,
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
