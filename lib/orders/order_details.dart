import 'dart:convert';
import 'package:Artisan/src/constants/colors.dart';
import 'package:Artisan/src/logic/services/api_services/retrofit/auth_api_client/auth_api_client.dart';
import 'package:Artisan/src/logic/services/preference_services.dart';
import 'package:Artisan/src/ui/auth/widgets/back_btn.dart';
import 'package:Artisan/src/widgets/custom_scaffold.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class OrderDetailsPage extends ConsumerStatefulWidget {
  final String orderId;
  const OrderDetailsPage({super.key, required this.orderId});

  @override
  ConsumerState<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends ConsumerState<OrderDetailsPage> {
  Map<String, dynamic>? orderData;
  bool isLoading = true;
  final String _baseUrl = apiBaseUrl;
  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
  }

  Future<void> fetchOrderDetails() async {
    final token =
        ref.read(preferenceServiceProvider).getString("auth_token") ?? '';
    final url = Uri.parse(_baseUrl + '/auth/orders/byId');

    var request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = token
      ..fields['id'] = widget.orderId;

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final jsonBody = jsonDecode(response.body);

      if (jsonBody['success'] == true) {
        setState(() {
          orderData = jsonBody['data'];
          isLoading = false;
        });
      } else {
        _showError("Failed to load order");
      }
    } catch (e) {
      _showError("Error: $e");
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      topPadding: 35,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEBDCFD), Color(0xFFE0F5F0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: isLoading || orderData == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: ListView(
                    children: [
                      Row(
                        children: [
                          BackBtn(
                              iconColor: Colors.black,
                              onTap: () => context.maybePop()),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Order #${orderData!['orderNumber']}",
                                  style: GoogleFonts.nunitoSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              Text("${orderData!['items'].length} item",
                                  style: GoogleFonts.nunitoSans(
                                      fontSize: 12, color: Colors.grey))
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Icon(Icons.check_box,
                              color: Colors.green, size: 28),
                          const SizedBox(width: 10),
                          Text(
                            (orderData!['orderStatus'] ?? '')
                                .toString()
                                .capitalize(),
                            style: GoogleFonts.nunitoSans(
                                fontSize: 18,
                                color: Colors.green,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...orderData!['items'].map<Widget>((item) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item['image'],
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(item['name'],
                                style: GoogleFonts.nunitoSans(
                                    fontWeight: FontWeight.w600)),
                            subtitle: Text("${item['quantity']} unit"),
                            trailing: Text("₹${item['price']}",
                                style: GoogleFonts.nunitoSans(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          )),
                      const SizedBox(height: 20),
                      buildSectionTitle("Order Details"),
                      buildKeyValue("Order Number", orderData!['orderNumber']),
                      buildKeyValue("Order Placed", orderData!['createdAt']),
                      buildKeyValue(
                          "Quantity", "${orderData!['items'].length}"),
                      buildKeyValue("Total Price",
                          "₹${orderData!['pricing']['subtotal'] ?? 0}"),
                      buildKeyValue("Order Status", orderData!['orderStatus']),
                      buildKeyValue(
                          "Payment Status", orderData!['paymentStatus']),
                      buildKeyValue(
                          "Payment Method", orderData!['paymentMethod']),
                      const Divider(height: 32),
                      buildSectionTitle("Bill Summary"),
                      buildKeyValue("Item Subtotal",
                          "₹${orderData!['pricing']['subtotal'] ?? 0}"),
                      buildKeyValue("Shipping and Handling Charges",
                          "₹${orderData!['pricing']['shipping'] ?? 0}"),
                      buildKeyValue("Discount",
                          "₹${orderData!['pricing']['discount'] ?? 0}"),
                      buildKeyValue(
                          "Tax(${orderData!['pricing']['taxPercentage'] ?? 0}%)",
                          "₹${orderData!['pricing']['tax'] ?? 0}"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Shipment Total",
                              style: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w600)),
                          Text("₹${orderData!['pricing']['total'] ?? 0}",
                              style: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const Divider(height: 32),
                      buildSectionTitle("Shipping Address"),
                      const SizedBox(height: 8),
                      Text(
                        "Deliver to ${orderData!['shippingAddress']['fullName']}, +91${orderData!['shippingAddress']['contactNumber']}",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${orderData!['shippingAddress']['address']},\n${orderData!['shippingAddress']['city']}, ${orderData!['shippingAddress']['state']}\n${orderData!['shippingAddress']['country']} - ${orderData!['shippingAddress']['pincode']}",
                        style: GoogleFonts.nunitoSans(fontSize: 14),
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget buildKeyValue(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: GoogleFonts.nunitoSans(color: Colors.grey, fontSize: 14)),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.end,
                style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w600, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style:
            GoogleFonts.nunitoSans(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}

extension CapExtension on String {
  String capitalize() =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
}
