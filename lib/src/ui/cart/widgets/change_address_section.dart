import 'package:Artisan/src/constants/colors.dart';
import 'package:Artisan/src/ui/cart/address/addressSelection_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangeAddressSection extends ConsumerWidget {
  const ChangeAddressSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xffFFE5E7),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Image.asset(
                'assets/images/ic_truck.png',
                height: 24,
                width: 24,
              ),
              const SizedBox(
                width: 7,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Deliver to 600001',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w500,
                        color: blackPrimaryColor,
                        fontSize: 14,
                        letterSpacing: -.1,
                      ),
                    ),
                    Text(
                      "Rishi,No.10........ballia",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff818181),
                        fontSize: 12,
                        letterSpacing: -.1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 7,
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const AddressSelectionSheet(),
                  );
                },
                child: Container(
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: primaryColor, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Center(
                        child: Text(
                      "Change",
                      style: GoogleFonts.nunitoSans(
                        color: primaryColor,
                        fontSize: 14,
                        letterSpacing: -.1,
                      ),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
