import 'package:Artisan/src/constants/colors.dart';

import 'package:Artisan/src/logic/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileImageNameSection extends ConsumerWidget {
  const ProfileImageNameSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData =
        ref.watch(authRepositoryProvider.select((value) => value.authUser));
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hey, ${userData?.userData.fullName.split(' ').first ?? "User"}',
                maxLines: 1,
                style: GoogleFonts.nunitoSans(
                  fontSize: 24,
                  height: 2,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                "Logged in via ${userData?.userData.email}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  color: Color(0xff8F98AA),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        const CircleAvatar(
          radius: 41,
          backgroundColor: primaryColor,
        ),
      ],
    );
  }
}
