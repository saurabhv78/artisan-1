import 'dart:convert';

import 'package:Artisan/orders/my_order_list.dart';
import 'package:Artisan/src/constants/colors.dart';

import 'package:Artisan/src/logic/repositories/auth_repository.dart';
import 'package:Artisan/src/logic/services/api_services/retrofit/auth_api_client/auth_api_client.dart';
import 'package:Artisan/src/logic/services/preference_services.dart';
import 'package:Artisan/src/routing/router.dart';
import 'package:Artisan/src/ui/auth/tnc/deactivate.dart';
import 'package:Artisan/src/ui/auth/tnc/tnc_page.dart';
import 'package:Artisan/src/ui/profile_tab/deactivate_view.dart';
import 'package:Artisan/src/ui/profile_tab/delete_screen.dart';
import 'package:Artisan/src/ui/profile_tab/editProfile_View.dart';
import 'package:Artisan/src/ui/profile_tab/edit_address_view.dart';

import 'package:Artisan/src/ui/profile_tab/widgets/profile_container.dart';

import 'package:Artisan/src/widgets/custom_scaffold.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../auth/tnc/refund_policy.dart';
import 'widgets/image_name_section.dart';

@RoutePage()
class ProfileTabPage extends ConsumerStatefulWidget {
  const ProfileTabPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends ConsumerState<ProfileTabPage> {
  bool isProcessing = false;
  final _baseurl = apiBaseUrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authRepositoryProvider.notifier).fetchUserDetails();
    });
  }

  Future<bool> deactivateUserAPI() async {
    try {
      final token =
          ref.read(preferenceServiceProvider).getString("auth_token") ?? '';
      final userId =
          ref.read(preferenceServiceProvider).getString("userId") ?? "";
      final response = await http.get(
        Uri.parse("$_baseurl/auth/deactivate/$userId"),
        headers: {
          "Authorization": "$token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        // Success UI
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account deactivated successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        final res = await ref.read(authRepositoryProvider.notifier).logOut();
        // Logout or navigate
        return true;
      } else {
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error["message"] ?? "Something went wrong"),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Server error!"),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        topPadding: 35,
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
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const ProfileImageNameSection(),
                    const SizedBox(height: 40),
                    ProfileContainer(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EditProfilePage()),
                        );
                      },
                      subtitle: 'Edit your profile details',
                      title: 'Profile Settings',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 20),
                    ProfileContainer(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EditAddress()),
                        );
                        // context.pushRoute(const EditAddress());
                      },
                      subtitle: 'Edit your home address',
                      title: 'Manage Address',
                      icon: Icons.location_on_outlined,
                    ),
                    const SizedBox(height: 20),
                    ProfileContainer(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OrdersPage()),
                        );
                      },
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
                    ProfileContainer(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const DeleteAccountScreen()),
                        );
                      },
                      // onTap: () async {
                      //   await showDialog(
                      //     context: context,
                      //     barrierDismissible: false,
                      //     builder: (context) {
                      //       final TextEditingController confirmCtrl =
                      //           TextEditingController();
                      //       final ValueNotifier<bool> isEnabled =
                      //           ValueNotifier(false);
                      //       final ValueNotifier<bool> isLoading =
                      //           ValueNotifier(false);

                      //       return StatefulBuilder(
                      //         builder: (context, setState) {
                      //           return AlertDialog(
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(20),
                      //             ),
                      //             title: const Text(
                      //               "Confirm Deactivation",
                      //               style: TextStyle(
                      //                 fontSize: 20,
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //               textAlign: TextAlign.center,
                      //             ),
                      //             content: Column(
                      //               mainAxisSize: MainAxisSize.min,
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.center,
                      //               children: [
                      //                 // Warning
                      //                 Row(
                      //                   mainAxisAlignment:
                      //                       MainAxisAlignment.center,
                      //                   children: const [
                      //                     Icon(Icons.warning_amber_rounded,
                      //                         color: Colors.red, size: 26),
                      //                     SizedBox(width: 8),
                      //                     Text("Warning",
                      //                         style: TextStyle(
                      //                             color: Colors.red,
                      //                             fontSize: 16,
                      //                             fontWeight: FontWeight.bold)),
                      //                   ],
                      //                 ),

                      //                 const SizedBox(height: 16),

                      //                 const Text(
                      //                   "To proceed, please type the word *DEACTIVATE* below",
                      //                   style: TextStyle(fontSize: 16),
                      //                 ),

                      //                 const SizedBox(height: 12),

                      //                 // Input
                      //                 TextField(
                      //                   controller: confirmCtrl,
                      //                   onChanged: (value) {
                      //                     setState(() {
                      //                       isEnabled.value =
                      //                           value.trim().toUpperCase() ==
                      //                               "DEACTIVATE";
                      //                     });
                      //                   },
                      //                   decoration: InputDecoration(
                      //                     labelText: "Type Here",
                      //                     filled: true,
                      //                     fillColor: Colors.grey.shade200,
                      //                     border: OutlineInputBorder(
                      //                       borderRadius:
                      //                           BorderRadius.circular(12),
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //             actionsPadding: const EdgeInsets.only(
                      //                 bottom: 12, right: 10, left: 10),
                      //             actions: [
                      //               // Cancel button
                      //               TextButton(
                      //                 style: TextButton.styleFrom(
                      //                   foregroundColor: Colors.black87,
                      //                   padding: const EdgeInsets.symmetric(
                      //                       horizontal: 20, vertical: 10),
                      //                 ),
                      //                 onPressed: () => Navigator.pop(context),
                      //                 child: const Text("Cancel",
                      //                     style: TextStyle(fontSize: 16)),
                      //               ),

                      //               // Confirm button
                      //               ValueListenableBuilder<bool>(
                      //                 valueListenable: isEnabled,
                      //                 builder: (context, enabled, _) {
                      //                   return ValueListenableBuilder<bool>(
                      //                     valueListenable: isLoading,
                      //                     builder: (context, loading, _) {
                      //                       return ElevatedButton(
                      //                         style: ElevatedButton.styleFrom(
                      //                           padding:
                      //                               const EdgeInsets.symmetric(
                      //                                   horizontal: 25,
                      //                                   vertical: 10),
                      //                           backgroundColor: enabled
                      //                               ? Colors.redAccent
                      //                               : Colors.grey,
                      //                         ),
                      //                         onPressed: (!enabled || loading)
                      //                             ? null
                      //                             : () async {
                      //                                 isLoading.value = true;

                      //                                 // WAIT FOR API CALL
                      //                                 final success =
                      //                                     await deactivateUserAPI();

                      //                                 isLoading.value = false;

                      //                                 if (success) {
                      //                                   Navigator.pop(
                      //                                       context); // close dialog
                      //                                 }
                      //                               },
                      //                         child: loading
                      //                             ? const SizedBox(
                      //                                 height: 18,
                      //                                 width: 18,
                      //                                 child:
                      //                                     CircularProgressIndicator(
                      //                                   strokeWidth: 2,
                      //                                   color: Colors.white,
                      //                                 ),
                      //                               )
                      //                             : const Text(
                      //                                 "Confirm",
                      //                                 style: TextStyle(
                      //                                     fontSize: 16,
                      //                                     color: Colors.white),
                      //                               ),
                      //                       );
                      //                     },
                      //                   );
                      //                 },
                      //               ),
                      //             ],
                      //           );
                      //         },
                      //       );
                      //     },
                      //   );
                      // },

                      title: 'Delete Account',
                      subtitle:
                          'Permanently delete or disable your Artisan account',
                      icon: Icons
                          .person_off_outlined, // or Icons.person_off_outlined
                    ),

                    const SizedBox(height: 20),
                    ProfileContainer(
                      onTap: () {
                        showAdaptiveDialog(
                          context: context,
                          builder: (context) => Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: RefundPolicyScreen(),
                            ),
                          ),
                        );
                      },
                      title: 'Refund Policy',
                      subtitle: 'View details about Artisan\'s refund policy',
                      icon: Icons.policy_outlined,
                    ),
                    const SizedBox(height: 20),
                    // const ProfileContainer(
                    //   subtitle: 'Edit the Artisn app settings',
                    //   title: 'Settings',
                    //   icon: Icons.settings_outlined,
                    // ),
                    // const SizedBox(height: 20),
                    // const ProfileContainer(
                    //   subtitle: 'Get help regarding your account or orders',
                    //   title: 'Help and Support',
                    //   icon: Icons.help_outline,
                    // ),
                    // const SizedBox(height: 20),
                    ProfileContainer(
                      onTap: () async {
                        if (!isProcessing) {
                          final shouldLogout = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Row(
                                children: [
                                  const Icon(Icons.logout,
                                      color: Colors.redAccent),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Logout',
                                    style: GoogleFonts.nunitoSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              content: Text(
                                'Are you sure you want to logout from your account?',
                                style: GoogleFonts.nunitoSans(fontSize: 16),
                              ),
                              actionsAlignment: MainAxisAlignment.end,
                              actionsPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.grey[700],
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: GoogleFonts.nunitoSans(fontSize: 15),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Logout',
                                    style: GoogleFonts.nunitoSans(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (shouldLogout ?? false) {
                            if (mounted) {
                              setState(() {
                                isProcessing = true;
                              });
                            }

                            final res = await ref
                                .read(authRepositoryProvider.notifier)
                                .logOut();
                            if (res.$1) {
                              // debugPrint(res);
                            }

                            if (mounted) {
                              setState(() {
                                isProcessing = false;
                              });
                            }
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
