// // import 'package:Artisan/src/constants/colors.dart';
// // import 'package:Artisan/src/ui/cart/checkout/checkout_page.dart';
// // import 'package:flutter/material.dart';

// // import 'package:flutter_dash/flutter_dash.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';

// // import 'package:google_fonts/google_fonts.dart';

// // import '../../../widgets/custom_button.dart';
// // import '../cart_page_model.dart';

// // class CartBottomSheet extends ConsumerWidget {
// //   const CartBottomSheet({super.key});

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final cartData =
// //         ref.watch(cartPageModelProvider.select((value) => value.cartData));

// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 22),
// //       child: Column(
// //         children: [
// //           const SizedBox(
// //             height: 15,
// //           ),
// //           if (cartData.pricing != null)
// //             Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     Text(
// //                       "Sub Total",
// //                       style: GoogleFonts.nunitoSans(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.w400,
// //                         letterSpacing: .4,
// //                         color: grayTextColor,
// //                       ),
// //                     ),
// //                     Text(
// //                       "\$${cartData.pricing?.subtotal?.toStringAsFixed(2) ?? '0.00'}",
// //                       style: GoogleFonts.nunitoSans(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.w400,
// //                         letterSpacing: .1,
// //                         color: bgDark,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     Text(
// //                       "Shipping & Handling Cost",
// //                       style: GoogleFonts.nunitoSans(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.w400,
// //                         letterSpacing: .4,
// //                         color: grayTextColor,
// //                       ),
// //                     ),
// //                     Text(
// //                       "\$${cartData.pricing?.ShippingAmount?.toStringAsFixed(2) ?? '0.00'}",
// //                       style: GoogleFonts.nunitoSans(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.w400,
// //                         letterSpacing: .1,
// //                         color: bgDark,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     Text(
// //                       "Discount",
// //                       style: GoogleFonts.nunitoSans(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.w400,
// //                         letterSpacing: .4,
// //                         color: grayTextColor,
// //                       ),
// //                     ),
// //                     Text(
// //                       "-\$${cartData.pricing?.discount?.toStringAsFixed(2) ?? '0.00'}",
// //                       style: GoogleFonts.nunitoSans(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.w400,
// //                         letterSpacing: .1,
// //                         color: bgDark,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     Text(
// //                       "Tax (${cartData.pricing?.taxPercentage ?? 0}%)",
// //                       style: GoogleFonts.nunitoSans(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.w400,
// //                         letterSpacing: .4,
// //                         color: grayTextColor,
// //                       ),
// //                     ),
// //                     Text(
// //                       "\$${cartData.pricing?.tax?.toStringAsFixed(2) ?? '0.00'}",
// //                       style: GoogleFonts.nunitoSans(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.w400,
// //                         letterSpacing: .1,
// //                         color: bgDark,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 SizedBox(
// //                   height: 25,
// //                   child: Row(
// //                     children: [
// //                       Expanded(
// //                         child: LayoutBuilder(builder: (context, constraints) {
// //                           return Dash(
// //                             direction: Axis.horizontal,
// //                             dashLength: 3,
// //                             length: constraints.maxWidth,
// //                             dashGap: 3,
// //                             dashColor: grayTextColor,
// //                             dashThickness: 1,
// //                           );
// //                         }),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     Text(
// //                       "Total Cost",
// //                       style: GoogleFonts.nunitoSans(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.w400,
// //                         letterSpacing: .4,
// //                         color: grayTextColor,
// //                       ),
// //                     ),
// //                     Text(
// //                       "\$${cartData.pricing?.total?.toStringAsFixed(2) ?? '0.00'}",
// //                       style: GoogleFonts.nunitoSans(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.w400,
// //                         letterSpacing: .1,
// //                         color: bgDark,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           Padding(
// //             padding: const EdgeInsets.symmetric(vertical: 10),
// //             child: Row(
// //               children: [
// //                 Expanded(
// //                   child: CustomButton(
// //                     text: 'Shop More',
// //                     onTap: () {
// //                       Navigator.popUntil(context, (route) => route.isFirst);
// //                     },
// //                     secondUI: true,
// //                     isProcessing: false,
// //                   ),
// //                 ),
// //                 const SizedBox(width: 15),
// //                 Expanded(
// //                   child: CustomButton(
// //                     text: 'Checkout',
// //                     onTap: () {

// //                       Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                               builder: (context) => CheckoutPage()));
// //                     },
// //                     isProcessing: false,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'dart:convert';
// import 'package:Artisan/src/constants/colors.dart';
// import 'package:Artisan/src/logic/services/preference_services.dart';
// import 'package:Artisan/src/ui/cart/checkout/checkout_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dash/flutter_dash.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import '../../../logic/services/api_services/retrofit/auth_api_client/auth_api_client.dart';
// import '../../../widgets/custom_button.dart';
// import '../cart_page_model.dart';

// class CartBottomSheet extends ConsumerStatefulWidget {
//   const CartBottomSheet({super.key});

//   @override
//   ConsumerState<CartBottomSheet> createState() => _CartBottomSheetState();
// }

// class _CartBottomSheetState extends ConsumerState<CartBottomSheet> {
//   bool _isProcessing = false;
//   List<Map<String, String>> _addressList = [];
//   late String _token;

//   @override
//   void initState() {
//     super.initState();
//     _token = ref.read(preferenceServiceProvider).getString("auth_token") ?? '';

//     // _fetchAddressList();
//   }
//   // Replace these with your actual values

//   Future<void> _fetchAddressList() async {
//     setState(() => _isProcessing = true);

//     final url = Uri.parse('$apiBaseUrl/auth/user/address');

//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Authorization': _token,
//           'Content-Type': 'application/json',
//         },
//       );

//       setState(() => _isProcessing = false);

//       if (response.statusCode == 200) {
//         final body = jsonDecode(response.body);
//         final List<dynamic> data = body['data'] ?? [];

//         // if (data.isEmpty) {
//         //   _showError('Please add your address.');
//         //   return;
//         // }

//         _addressList = data.map<Map<String, String>>((item) {
//           final fullAddress =
//               "${item['address']}, ${item['city']}, ${item['state']} - ${item['pincode']}";
//           return {
//             'id': item['id'].toString(),
//             'label': fullAddress,
//             'sub': 'Created at: ${item['createdAt']}',
//             'isCurrent': item['isCurrentAddress'].toString(),
//           };
//         }).toList();

//         // Set current address
//         final current = _addressList.firstWhere(
//           (a) => a['isCurrent'] == 'true',
//           orElse: () => _addressList.first,
//         );
//         setState(() {
//           _addressList;
//         });
//       }
//     } catch (e) {
//       setState(() => _isProcessing = false);
//       // _showError('Please add your address.');
//     }
//   }

//   void _showError(String message) {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(message)),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cartData =
//         ref.watch(cartPageModelProvider.select((value) => value.cartData));

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 22),
//       child: Column(
//         children: [
//           const SizedBox(height: 15),
//           if (cartData.pricing != null)
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _priceRow("Sub Total", cartData.pricing?.subtotal?.toDouble()),
//                 _priceRow("Shipping & Handling Cost",
//                     cartData.pricing?.ShippingAmount?.toDouble()),
//                 _priceRow("Discount", cartData.pricing?.discount?.toDouble(),
//                     isNegative: true),
//                 cartData.pricing?.taxPercentage == 0
//                     ? const SizedBox.shrink()
//                     : _priceRow(
//                         "Tax (${cartData.pricing?.taxPercentage ?? 0}%)",
//                         cartData.pricing?.tax?.toDouble()),
//                 SizedBox(
//                   height: 25,
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: LayoutBuilder(builder: (context, constraints) {
//                           return Dash(
//                             direction: Axis.horizontal,
//                             dashLength: 3,
//                             length: constraints.maxWidth,
//                             dashGap: 3,
//                             dashColor: grayTextColor,
//                             dashThickness: 1,
//                           );
//                         }),
//                       ),
//                     ],
//                   ),
//                 ),
//                 _priceRow("Total Cost", cartData.pricing?.total?.toDouble()),
//               ],
//             ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 10),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: CustomButton(
//                     text: 'Shop More',
//                     onTap: () {
//                       Navigator.popUntil(context, (route) => route.isFirst);
//                     },
//                     secondUI: true,
//                     isProcessing: false,
//                   ),
//                 ),
//                 const SizedBox(width: 15),
//                 Expanded(
//                   child: CustomButton(
//                     text: 'Checkout',
//                     onTap: () async {
//                       await _fetchAddressList();

//                       if (_addressList.isEmpty) {
//                         _showError('Please add your address before checkout.');
//                         return;
//                       }

//                       Navigator.push(
//                         // ignore: use_build_context_synchronously
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => CheckoutPage(),
//                         ),
//                       );
//                     },
//                     isProcessing: _isProcessing,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _priceRow(String label, double? value, {bool isNegative = false}) {
//     final formattedValue =
//         (value ?? 0.0).toStringAsFixed(2).replaceAll(RegExp(r"^-"), "");
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: GoogleFonts.nunitoSans(
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//             color: grayTextColor,
//           ),
//         ),
//         Text(
//           "${isNegative ? '-' : ''}\$${formattedValue}",
//           style: GoogleFonts.nunitoSans(
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//             color: bgDark,
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'dart:convert';
import 'package:Artisan/src/constants/colors.dart';
import 'package:Artisan/src/logic/services/preference_services.dart';
import 'package:Artisan/src/ui/cart/checkout/checkout_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../../logic/services/api_services/retrofit/auth_api_client/auth_api_client.dart';
import '../../../widgets/custom_button.dart';
import '../cart_page_model.dart';

class CartBottomSheet extends ConsumerStatefulWidget {
  const CartBottomSheet({super.key});

  @override
  ConsumerState<CartBottomSheet> createState() => _CartBottomSheetState();
}

class _CartBottomSheetState extends ConsumerState<CartBottomSheet> {
  bool _isProcessing = false;
  List<Map<String, String>> _addressList = [];
  late String _token;

  @override
  void initState() {
    super.initState();
    _token = ref.read(preferenceServiceProvider).getString("auth_token") ?? '';
  }

  Future<void> _fetchAddressList() async {
    setState(() => _isProcessing = true);

    final url = Uri.parse('$apiBaseUrl/auth/user/address');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': _token,
          'Content-Type': 'application/json',
        },
      );

      setState(() => _isProcessing = false);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List<dynamic> data = body['data'] ?? [];

        _addressList = data.map<Map<String, String>>((item) {
          final fullAddress =
              "${item['address']}, ${item['city']}, ${item['state']} - ${item['pincode']}";
          return {
            'id': item['id'].toString(),
            'label': fullAddress,
            'sub': 'Created at: ${item['createdAt']}',
            'isCurrent': item['isCurrentAddress'].toString(),
          };
        }).toList();

        setState(() {});
      }
    } catch (e) {
      setState(() => _isProcessing = false);
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartData =
        ref.watch(cartPageModelProvider.select((value) => value.cartData));

    final width = MediaQuery.of(context).size.width;
    final isTablet = width > 600;

    final font16 = isTablet ? 20.0 : 16.0;
    final font14 = isTablet ? 18.0 : 14.0;
    final rowSpacing = isTablet ? 14.0 : 10.0;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 30 : 22,
      ),
      child: Column(
        children: [
          SizedBox(height: isTablet ? 20 : 15),

          if (cartData.pricing != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _priceRow("Sub Total", cartData.pricing?.subtotal?.toDouble(),
                    font16),
                SizedBox(height: rowSpacing),
                _priceRow("Shipping & Handling Cost",
                    cartData.pricing?.ShippingAmount?.toDouble(), font16),
                SizedBox(height: rowSpacing),
                _priceRow(
                    "Discount", cartData.pricing?.discount?.toDouble(), font16,
                    isNegative: true),
                SizedBox(height: rowSpacing),
                cartData.pricing?.taxPercentage == 0
                    ? const SizedBox.shrink()
                    : _priceRow(
                        "Tax (${cartData.pricing?.taxPercentage ?? 0}%)",
                        cartData.pricing?.tax?.toDouble(),
                        font16,
                      ),
                SizedBox(height: isTablet ? 20 : 15),
                SizedBox(
                  height: isTablet ? 30 : 25,
                  child: Row(
                    children: [
                      Expanded(
                        child: LayoutBuilder(builder: (context, constraints) {
                          return Dash(
                            direction: Axis.horizontal,
                            dashLength: 3,
                            length: constraints.maxWidth,
                            dashGap: 3,
                            dashColor: grayTextColor,
                            dashThickness: 1,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: rowSpacing),
                _priceRow(
                    "Total Cost", cartData.pricing?.total?.toDouble(), font16),
              ],
            ),

          SizedBox(height: isTablet ? 20 : 10),

          // BUTTONS
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  height: isTablet ? 55 : 48,
                  // textSize: isTablet ? 18 : 16,
                  text: 'Shop More',
                  onTap: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  secondUI: true,
                  isProcessing: false,
                ),
              ),
              SizedBox(width: isTablet ? 20 : 15),
              Expanded(
                child: CustomButton(
                  height: isTablet ? 55 : 48,
                  // textSize: isTablet ? 18 : 16,
                  text: 'Checkout',
                  onTap: () async {
                    await _fetchAddressList();

                    if (_addressList.isEmpty) {
                      _showError('Please add your address before checkout.');
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutPage(),
                      ),
                    );
                  },
                  isProcessing: _isProcessing,
                ),
              ),
            ],
          ),

          SizedBox(height: isTablet ? 10 : 5),
        ],
      ),
    );
  }

  Widget _priceRow(
    String label,
    double? value,
    double fontSize, {
    bool isNegative = false,
  }) {
    final formattedValue =
        (value ?? 0.0).toStringAsFixed(2).replaceAll(RegExp(r"^-"), "");

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.nunitoSans(
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
            color: grayTextColor,
          ),
        ),
        Text(
          "${isNegative ? '-' : ''}\$$formattedValue",
          style: GoogleFonts.nunitoSans(
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
            color: bgDark,
          ),
        ),
      ],
    );
  }
}
