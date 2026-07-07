// import 'dart:convert';
// import 'dart:developer';
// import 'package:Artisan/orders/order_details.dart';
// import 'package:Artisan/src/constants/colors.dart';
// import 'package:Artisan/src/logic/services/api_services/retrofit/auth_api_client/auth_api_client.dart';
// import 'package:Artisan/src/logic/services/preference_services.dart';
// import 'package:Artisan/src/ui/auth/widgets/back_btn.dart';
// import 'package:Artisan/src/widgets/custom_scaffold.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class OrdersPage extends ConsumerStatefulWidget {
//   const OrdersPage({super.key});

//   @override
//   ConsumerState<OrdersPage> createState() => _OrdersPageState();
// }

// class _OrdersPageState extends ConsumerState<OrdersPage> {
//   List<Map<String, dynamic>> _orders = [];
//   bool _isLoading = false;
//   int _currentPage = 1;
//   int _totalPages = 1;

//   final ScrollController _scrollController = ScrollController();
//   final int _limit = 10;
//   final String _baseUrl = apiBaseUrl;
//   @override
//   void initState() {
//     super.initState();
//     _fetchOrders();
//     _scrollController.addListener(_scrollListener);
//   }

//   void _scrollListener() {
//     if (_scrollController.position.pixels >=
//             _scrollController.position.maxScrollExtent &&
//         !_isLoading &&
//         _currentPage < _totalPages) {
//       _fetchOrders();
//     }
//   }

//   Future<void> _fetchOrders() async {
//     setState(() => _isLoading = true);

//     final token =
//         ref.read(preferenceServiceProvider).getString("auth_token") ?? '';

//     final url = Uri.parse(_baseUrl + '/auth/orders/list');

//     var request = http.MultipartRequest('POST', url)
//       ..headers['Authorization'] = token
//       ..fields['page'] = "$_currentPage"
//       ..fields['limit'] = '$_limit';

//     try {
//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);
//       final jsonBody = jsonDecode(response.body);

//       if (jsonBody['success'] == true) {
//         final List<dynamic> data = jsonBody['data'] ?? [];
//         final meta = jsonBody['other'];

//         setState(() {
//           _orders.addAll(data.map((e) => {
//                 'orderId': e['orderNumber'],
//                 'id': e['id'],
//                 'price': '\$${e['totalAmount']}',
//                 'status': e['orderStatus'],
//                 'date': e['createdAt'],
//                 'items': e['itemCount'],
//                 'image': 'https://tinyjpg.com/images/social/website.jpg',
//               }));
//           _totalPages = meta['totalPages'] ?? 1;
//           _currentPage++;
//         });
//       } else {
//         _showError("Failed to fetch orders");
//       }
//     } catch (e) {
//       _showError("Error: $e");
//     }

//     setState(() => _isLoading = false);
//   }

//   void _showError(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
//     log(msg);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomScaffold(
//       topPadding: 35,
//       child: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFFEBDCFD), Color(0xFFE0F5F0)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(25, 15, 25, 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     BackBtn(
//                       iconColor: Colors.black,
//                       onTap: () => context.maybePop(),
//                     ),
//                     const SizedBox(width: 15),
//                     Text(
//                       "My Orders",
//                       style: GoogleFonts.nunitoSans(
//                         fontWeight: FontWeight.w400,
//                         color: bgDark,
//                         fontSize: 24,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Expanded(
//                 child: ListView.builder(
//                   controller: _scrollController,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                   itemCount: _orders.length + 1,
//                   itemBuilder: (context, index) {
//                     if (index == _orders.length) {
//                       return _isLoading
//                           ? const Padding(
//                               padding: EdgeInsets.all(20.0),
//                               child: Center(child: CircularProgressIndicator()),
//                             )
//                           : const SizedBox();
//                     }

//                     final order = _orders[index];
//                     return Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               order['date'] ?? '',
//                               style: GoogleFonts.nunitoSans(
//                                 color: Colors.grey[600],
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             Text(
//                               order['status']?.toString().capitalize() ?? '',
//                               style: GoogleFonts.nunitoSans(
//                                 color: Colors.green,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 4),
//                         ListTile(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => OrderDetailsPage(
//                                         orderId: order['id'],
//                                       )),
//                             );
//                           },
//                           contentPadding: EdgeInsets.zero,
//                           title: Text(
//                             order['orderId'] ?? '',
//                             style: GoogleFonts.nunitoSans(
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           subtitle: Text(order['price'] ?? ''),
//                           trailing: Text(
//                             "${order['items']}Items",
//                             style: GoogleFonts.nunitoSans(
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                         const Divider(
//                           height: 16,
//                           color: Colors.grey,
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Null-safe capitalize extension
// extension StringCasingExtension on String? {
//   String capitalize() {
//     final str = this ?? '';
//     if (str.isEmpty) return '';
//     return str[0].toUpperCase() + str.substring(1);
//   }
// }
import 'dart:convert';
import 'dart:developer';
import 'package:Artisan/orders/order_details.dart';
import 'package:Artisan/src/constants/colors.dart';
import 'package:Artisan/src/logic/services/api_services/retrofit/auth_api_client/auth_api_client.dart';
import 'package:Artisan/src/logic/services/preference_services.dart';
import 'package:Artisan/src/ui/auth/widgets/back_btn.dart';
import 'package:Artisan/src/widgets/custom_scaffold.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrdersPage extends ConsumerStatefulWidget {
  const OrdersPage({super.key});

  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends ConsumerState<OrdersPage> {
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = false;
  int _currentPage = 1;
  int _totalPages = 1;

  final ScrollController _scrollController = ScrollController();
  final int _limit = 10;
  final String _baseUrl = apiBaseUrl;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !_isLoading &&
        _currentPage < _totalPages) {
      _fetchOrders();
    }
  }

  Future<void> _fetchOrders() async {
    setState(() => _isLoading = true);

    final token =
        ref.read(preferenceServiceProvider).getString("auth_token") ?? '';

    final url = Uri.parse(_baseUrl + '/auth/orders/list');

    var request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = token
      ..fields['page'] = "$_currentPage"
      ..fields['limit'] = '$_limit';

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final jsonBody = jsonDecode(response.body);

      if (jsonBody['success'] == true) {
        final List<dynamic> data = jsonBody['data'] ?? [];
        final meta = jsonBody['other'];

        setState(() {
          _orders.addAll(data.map((e) => {
                'orderId': e['orderNumber'],
                'id': e['id'],
                'price': '\$${e['totalAmount']}',
                'status': e['orderStatus'],
                'date': e['createdAt'],
                'items': e['itemCount'],
                'image': 'https://tinyjpg.com/images/social/website.jpg',
              }));
          _totalPages = meta['totalPages'] ?? 1;
          _currentPage++;
        });
      } else {
        _showError("Failed to fetch orders");
      }
    } catch (e) {
      _showError("Error: $e");
    }

    setState(() => _isLoading = false);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    log(msg);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    // Responsive Font Scale
    double font(double size) => size * (width / 400);

    return CustomScaffold(
      // topPadding: 35,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEBDCFD), Color(0xFFE0F5F0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.fromLTRB(width * 0.06, 15, width * 0.06, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BackBtn(
                      iconColor: Colors.black,
                      onTap: () => context.maybePop(),
                    ),
                    SizedBox(width: width * 0.04),
                    Text(
                      "My Orders",
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w600,
                        fontSize: font(18),
                        letterSpacing: 0.5,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.02),

              // -------------------- LIST VIEW --------------------
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (_orders.isEmpty && !_isLoading) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_bag_outlined,
                                size: 80, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              "No orders found",
                              style: GoogleFonts.nunitoSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.05,
                        vertical: 12,
                      ),
                      itemCount: _orders.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _orders.length) {
                          return _isLoading
                              ? const Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                )
                              : const SizedBox();
                        }

                        final order = _orders[index];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Date + Status Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  order['date'] ?? '',
                                  style: GoogleFonts.nunitoSans(
                                    color: Colors.grey[600],
                                    fontSize: font(10),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  order['status']?.toString().capitalize() ??
                                      '',
                                  style: GoogleFonts.nunitoSans(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w700,
                                    fontSize: font(13),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 4),

                            ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderDetailsPage(
                                      orderId: order['id'].toString(),
                                    ),
                                  ),
                                );
                              },
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                order['orderId'] ?? '',
                                style: GoogleFonts.nunitoSans(
                                  fontSize: font(16),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: Text(
                                order['price'] ?? '',
                                style: GoogleFonts.nunitoSans(
                                  fontSize: font(14),
                                ),
                              ),
                              trailing: Text(
                                "${order['items']} Items",
                                style: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: font(14),
                                ),
                              ),
                            ),
                            Divider(height: 16, color: Colors.grey[400]),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Null-safe capitalize extension
extension StringCasingExtension on String? {
  String capitalize() {
    final str = this ?? '';
    if (str.isEmpty) return '';
    return str[0].toUpperCase() + str.substring(1);
  }
}
