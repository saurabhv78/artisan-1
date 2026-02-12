import 'dart:convert';
import 'package:Artisan/src/ui/cart/checkout/checkout_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:Artisan/src/constants/colors.dart';
import 'package:Artisan/src/ui/auth/widgets/back_btn.dart';
import 'package:Artisan/src/widgets/custom_scaffold.dart';
import 'package:Artisan/src/logic/services/preference_services.dart';
import '../../../logic/services/api_services/retrofit/auth_api_client/auth_api_client.dart';

class ApplyCouponPage extends ConsumerStatefulWidget {
  final Function(String) onSelect;
  final String cartId;

  const ApplyCouponPage({
    super.key,
    required this.onSelect,
    required this.cartId,
  });

  @override
  ConsumerState<ApplyCouponPage> createState() => _ApplyCouponPageState();
}

class _ApplyCouponPageState extends ConsumerState<ApplyCouponPage> {
  final String _baseUrl = apiBaseUrl;
  late String _token;

  List<Map<String, dynamic>> coupons = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _token = ref.read(preferenceServiceProvider).getString("auth_token") ?? '';
    _fetchCoupons();
  }

  /* ---------------- GET ACTIVE COUPONS ---------------- */

  Future<void> _fetchCoupons() async {
    final url = Uri.parse('$_baseUrl/products/coupons/active');
    setState(() => isLoading = true);

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': _token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List list = body['data'] ?? [];

        coupons = list.map((e) {
          return {
            "id": e["id"],
            "code": e["code"],
            "type": e["type"],
            "value": e["value"],
            "maxDiscount": e["maxDiscountAmount"],
            "minOrder": e["minOrderAmount"],
            "endDate": e["endDate"],
          };
        }).toList();
      } else {
        _showError("Failed to load coupons");
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  /* ---------------- APPLY COUPON (FORM-DATA POST) ---------------- */

  Future<void> _applyCoupon(String code) async {
    final url = Uri.parse('$_baseUrl/products/coupons/apply');
    setState(() => isLoading = true);

    try {
      final request = http.MultipartRequest("POST", url);

      request.headers.addAll({
        "Authorization": _token,
      });

      request.fields.addAll({
        "code": code,
        "cartId": widget.cartId,
      });

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Navigator.pop(context, true); // 🔥 only signal
      } else {
        _showError(body["message"] ?? "Coupon apply failed");
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

// /products/coupons/remove
  /* ---------------- HELPERS ---------------- */

  String _couponDescription(Map<String, dynamic> c) {
    if (c["type"] == "percentage") {
      return "Get ${c["value"]}% OFF up to \$${c["maxDiscount"]} on orders above \$${c["minOrder"]}";
    }
    return "Flat \$${c["value"]} OFF on minimum order \$${c["minOrder"]}";
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  /* ---------------- UI ---------------- */

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final bool isTablet = width >= 600;

    return CustomScaffold(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                isTablet ? 40 : 25,
                15,
                isTablet ? 40 : 25,
                10,
              ),
              child: Row(
                children: [
                  BackBtn(
                    iconColor: Colors.black,
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    "Apply Coupon",
                    style: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.w600,
                      color: bgDark,
                      fontSize: isTablet ? 30 : 24,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : coupons.isEmpty
                      ? const Center(child: Text("No coupons available"))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: coupons.length,
                          itemBuilder: (_, i) {
                            final coupon = coupons[i];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        coupon["code"],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () =>
                                            _applyCoupon(coupon["code"]),
                                        child: const Text(
                                          "APPLY",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const Divider(),
                                  Text(_couponDescription(coupon)),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
