// // ignore_for_file: unused_local_variable

// import 'package:Artisan/src/ui/auth/sign_in/signin_model.dart';
// import 'package:Artisan/src/utils/dialog_utls.dart';
// import 'package:Artisan/src/utils/toast_utils.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';

// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../constants/colors.dart';
//

// showRememberMeBottomSheet(BuildContext context, List list) {
//   return showArtisansBottomSheet(
//       enableDrag: false,
//       context: context,
//       builder: (context) => ShowRememberMeSheet(list: list));
// }

// class ShowRememberMeSheet extends ConsumerStatefulWidget {
//   final List list;
//   const ShowRememberMeSheet({
//     super.key,
//     required this.list,
//   });

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _ShowRememberMeSheetState();
// }

// class _ShowRememberMeSheetState extends ConsumerState<ShowRememberMeSheet> {
//   bool isProcessing = false;
//   int processingInd = 0;

//   @override
//   Widget build(BuildContext context) {
//     final removedInd =
//         ref.watch(signInPageModelProvider.select((value) => value.removedInd));
//     return WillPopScope(
//       onWillPop: () async {
//         return !isProcessing;
//       },
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const SizedBox(
//               height: 10,
//             ),
//             const Center(
//                 child: Text(
//               "Choose an account",
//               style: GoogleFonts.nunitoSans(
//                 fontSize: 28,
//
//                 fontWeight: FontWeight.w700,
//               ),
//             )),
//             const Center(
//                 child: Text(
//               "to continue to ARTISANS",
//               style: GoogleFonts.nunitoSans(
//                 fontSize: 14,
//
//                 fontWeight: FontWeight.w400,
//               ),
//             )),
//             const SizedBox(
//               height: 10,
//             ),
//             if (isProcessing) ...[
//               const Center(
//                 child: Center(
//                   child: SizedBox(
//                     height: 25,
//                     width: 25,
//                     child: CircularProgressIndicator(
//                       color: primaryColor,
//                       strokeWidth: 2.5,
//                     ),
//                   ),
//                 ),
//               ),
//             ] else
//               ConstrainedBox(
//                 constraints: const BoxConstraints(maxHeight: 400),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: ListView.builder(
//                     itemCount: widget.list.length,
//                     shrinkWrap: true,
//                     itemBuilder: (BuildContext context, int index) {
//                       return GestureDetector(
//                         behavior: HitTestBehavior.opaque,
//                         onTap: () async {
//                           if (!isProcessing) {
//                             if (mounted) {
//                               setState(() {
//                                 processingInd = index;
//                                 isProcessing = true;
//                               });
//                             }
//                             final res = await ref
//                                 .read(signInPageModelProvider.notifier)
//                                 .loginUser(
//                                     checkBox: false,
//                                     email: (widget.list[0] as Map)
//                                         .keys
//                                         .first
//                                         .toString(),
//                                     password: (widget.list[0] as Map)
//                                         .values
//                                         .first
//                                         .toString());
//                             if (res != '') {
//                               showErrorMessage(res);
//                             } else {
//                               context.maybePop();
//                             }
//                             if (mounted) {
//                               setState(() {
//                                 processingInd = -1;
//                                 isProcessing = false;
//                               });
//                             }
//                           }
//                         },
//                         child: _LoginDetailsCard(
//                           listLength: widget.list.length,
//                           isLast: index + 1 == widget.list.length,
//                           index: index,
//                           email:
//                               (widget.list[index] as Map).keys.first.toString(),
//                           password: (widget.list[index] as Map)
//                               .values
//                               .first
//                               .toString(),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             const SizedBox(
//               height: 10,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _LoginDetailsCard extends ConsumerWidget {
//   final String email;
//   final String password;
//   final int index;
//   final int listLength;
//   final bool isLast;
//   const _LoginDetailsCard({
//     required this.email,
//     required this.password,
//     required this.index,
//     required this.listLength,
//     required this.isLast,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const CircleAvatar(
//                 backgroundColor: primaryColor,
//                 radius: 20,
//               ),
//               const SizedBox(
//                 width: 5,
//               ),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     Text(
//                       email,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const GoogleFonts.nunitoSans(
//                         fontSize: 14,
//
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     const Text(
//                       "**********",
//                       maxLines: 1,
//                       style: GoogleFonts.nunitoSans(
//                         fontSize: 18,
//
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 width: 5,
//               ),
//               GestureDetector(
//                 onTap: () async {
//                   try {
//                     await ref
//                         .read(signInPageModelProvider.notifier)
//                         .removeEmail(email);

//                     if (listLength == 1) {
//                       context.maybePop();
//                     }
//                   } catch (e) {
//                     showErrorMessage(e.toString());
//                   }
//                 },
//                 child: const Icon(
//                   Icons.delete,
//                   size: 25,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         if (!isLast)
//           const Divider(
//             height: 5,
//             color: Colors.white,
//           ),
//       ],
//     );
//   }
// }

// Future<List?> getAllEmails() async {
//   return await (_collectionBox?.get('emails')) as List?;
// }

// Future<void> removeEmail(String email) async {
//   List data = await _collectionBox?.get('emails') ?? [];
//   int ind = data.indexWhere((_) => (_ as Map).keys.first.toString() == email);
//   if (ind != -1) {
//     data.removeAt(ind);
//   }
//   addInd(ind);
//   await _collectionBox?.put('emails', data);
// }

// Future<void> setRememberMe(String email, String pass) async {
//   List data = await _collectionBox?.get('emails') ?? [];
//   final ind = data.indexWhere((_) => (_ as Map).keys.first.toString() == email);
//   if (ind == -1) {
//     data.add({email: pass});
//   } else {
//     data.removeAt(ind);
//     data.add({email: pass});
//   }
//   await _collectionBox?.put('emails', data);
// }
