import 'package:Artisan/src/constants/colors.dart';

import 'package:Artisan/src/logic/repositories/auth_repository.dart';
import 'package:Artisan/src/routing/router.dart';

import 'package:Artisan/src/ui/profile_tab/widgets/profile_container.dart';

import 'package:Artisan/src/widgets/custom_scaffold.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets/image_name_section.dart';

@RoutePage()
class ProfileTabPage extends ConsumerStatefulWidget {
  const ProfileTabPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends ConsumerState<ProfileTabPage> {
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    "Profile",
                    style: GoogleFonts.nunitoSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const ProfileImageNameSection(),
                const SizedBox(height: 40),
                const ProfileContainer(
                  subtitle: 'Edit your profile details',
                  title: 'Profile Settings',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 20),
                const ProfileContainer(
                  subtitle: 'Edit your home address',
                  title: 'Your Address',
                  icon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 20),
                const ProfileContainer(
                  subtitle:
                      'Check your order status (track, return, cancel, etc)',
                  title: 'My Orders',
                  icon: Icons.shopping_bag_outlined,
                ),
                const SizedBox(height: 20),
                ProfileContainer(
                  onTap: () {
                    context.pushRoute(const WishlistRoute());
                  },
                  subtitle: 'View your favorite paintings in one place',
                  title: 'My Wishlist',
                  icon: Icons.favorite_outline,
                ),
                const SizedBox(height: 20),
                const ProfileContainer(
                  subtitle: 'Check your Artisan wallet balance',
                  title: 'Wallet',
                  icon: Icons.account_balance_wallet_outlined,
                ),
                const SizedBox(height: 20),
                const ProfileContainer(
                  subtitle: 'Edit the Artisn app settings',
                  title: 'Settings',
                  icon: Icons.settings_outlined,
                ),
                const SizedBox(height: 20),
                const ProfileContainer(
                  subtitle: 'Get help regarding your account or orders',
                  title: 'Help and Support',
                  icon: Icons.help_outline,
                ),
                const SizedBox(height: 20),
                ProfileContainer(
                  onTap: () async {
                    if (!isProcessing) {
                      if (mounted) {
                        setState(() {
                          isProcessing = true;
                        });
                      }
                      final res = await ref
                          .read(authRepositoryProvider.notifier)
                          .logOut();
                      if (res != '') {
                        debugPrint(res);
                      }
                      if (mounted) {
                        setState(() {
                          isProcessing = false;
                        });
                      }
                    }
                  },
                  subtitle: 'Log out of your current account',
                  title: 'Logout',
                  icon: Icons.logout_outlined,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        if (isProcessing)
          Center(
            child: Container(
              color: Colors.white.withOpacity(0.5),
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              child: const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              ),
            ),
          ),
      ],
    ));
  }
}
