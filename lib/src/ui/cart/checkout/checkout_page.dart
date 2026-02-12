import 'dart:convert';
import 'dart:developer';
import 'package:Artisan/src/constants/colors.dart';
import 'package:Artisan/src/ui/auth/widgets/back_btn.dart';
import 'package:Artisan/src/ui/cart/checkout/apply_coupon.dart';
import 'package:Artisan/src/ui/cart/payment/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:Artisan/src/logic/services/preference_services.dart';
import 'package:Artisan/src/widgets/custom_button.dart';
import 'package:Artisan/src/widgets/custom_scaffold.dart';

import '../../../logic/services/api_services/retrofit/auth_api_client/auth_api_client.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  bool _isProcessing = false;
  bool _isProcessingc = false;
  late String _token;
  String? _selectedAddressId;
  String? _cartId;
  String? _paymentId;

  late Razorpay _razorpay;
  final String _baseUrl = apiBaseUrl;

  List<Map<String, dynamic>> _addressList = [];
  List<dynamic> _cartItems = [];
  Map<String, dynamic> _pricing = {};

  @override
  void initState() {
    super.initState();
    _token = ref.read(preferenceServiceProvider).getString("auth_token") ?? '';
    _fetchAddressList();
    _fetchItemList();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  // ---------------- API CALLS + PAYMENT HANDLING ------------------

  Future<void> _submitOrder() async {
    if (_selectedAddressId == null || _cartId == null) {
      _showError('Missing address or cart info.');
      return;
    }

    setState(() => _isProcessing = true);
    final url = Uri.parse('$_baseUrl/auth/orders');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': _token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'cartId': _cartId,
          'paymentMethod': 'razorpay',
          'shippingAddressId': _selectedAddressId,
        }),
      );

      setState(() => _isProcessing = false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);
        final data = body['data'];

        final razorpayOrderId = data['razorpayOrderId'];
        final amount = (data['amountInPaise'] as num).toInt();
        final currency = data['currency'] ?? 'USD';
        final razorpayKey = data['razorpayKey'].toString();
        log('Razorpay Key: $razorpayKey');
        // .isNotEmpty == true
        // ?
        // data['razorpayKey'];
        // : 'rzp_live_RStRs3fKDBv7Jk';

        final prefill = data['razorpayPrefill'] ?? {};

        _paymentId = data['paymentId']?.toString();

        _startRazorpayPayment(
          key: razorpayKey.toString(),
          orderId: razorpayOrderId,
          amount: amount,
          currency: currency,
          prefill: {
            'name': prefill['name'] ?? '',
            'email': prefill['email'] ?? '',
            'contact': prefill['contact'] ?? '',
          },
        );
      } else {
        _showError('Failed to place order: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      _showError('Order error: $e');
    }
  }

  void _startRazorpayPayment({
    required String key,
    required String orderId,
    required int amount,
    required String currency,
    required Map<String, String> prefill,
  }) {
    final options = {
      'key': key,
      'amount': amount,
      'currency': currency,
      'name': 'Artisan Store',
      'description': 'Order Payment',
      'order_id': orderId,
      'prefill': prefill,
      'theme': {'color': '#f37254'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      _showError('Razorpay error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Payment Successful 🎉"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const PaymentPage()),
    );

    await _verifyPaymentOnBackend(response);
  }

  Future<void> _verifyPaymentOnBackend(PaymentSuccessResponse response) async {
    final url = Uri.parse('$_baseUrl/auth/order/verify/payment');

    final payload = {
      "razorpayOrderId": response.orderId,
      "signature": response.signature,
      "razorpayPaymentId": response.paymentId,
      "paymentId": _paymentId,
      "cartId": _cartId,
      "shippingAddressId": _selectedAddressId,
    };

    try {
      final res = await http.post(
        url,
        headers: {
          'Authorization': _token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      // Show success or failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(jsonDecode(res.body)['message'] ??
              "Payment verification complete."),
        ),
      );
    } catch (e) {
      _showError("Verification error: $e");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Payment failed ❌"),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Wallet: ${response.walletName}"),
        backgroundColor: Colors.orange,
      ),
    );
  }

  // --------------------------------------------------------------

  Future<void> _fetchAddressList() async {
    final url = Uri.parse('$_baseUrl/auth/user/address');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': _token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List;

        _addressList = data.map((e) {
          return {
            'id': e['id'],
            'fullName': e['fullName'],
            'contactNumber': e['contactNumber'],
            'address': e['address'],
            'city': e['city'],
            'state': e['state'],
            'pincode': e['pincode'],
            'isCurrent': e['isCurrentAddress'],
          };
        }).toList();

        final currentAddress = _addressList.firstWhere(
          (A) => A['isCurrent'] == true,
          orElse: () => _addressList.first,
        );

        _selectedAddressId = currentAddress['id'];
        setState(() {});
      }
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _fetchItemList() async {
    final url = Uri.parse('$_baseUrl/products/app/cart/list');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': _token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];

        setState(() {
          _cartItems = data['items'] ?? [];
          _pricing = Map<String, dynamic>.from(data['pricing'] ?? {});
          _cartId = data['id'];

          /// 🔥 COUPON HANDLE
          if (_pricing['isCouponApplied'] == true) {
            appliedCoupon = _pricing['couponcode']?.toString();
            isCouponApplied = true;
            couponController.text = appliedCoupon ?? 'Coupon';
          } else {
            appliedCoupon = null;
            isCouponApplied = false;
            couponController.clear();
          }
        });
      }
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // --------------------------------------------------------------
  // UI BUILD
  // --------------------------------------------------------------
  TextEditingController couponController = TextEditingController();
  String? appliedCoupon;
  double discountAmount = 0.0;
  bool isCouponApplied = false;

  @override
  Widget build(BuildContext context) {
    final currentAddress = _addressList.firstWhere(
      (item) => item['id'] == _selectedAddressId,
      orElse: () => {},
    );

    final width = MediaQuery.sizeOf(context).width;
    final bool isTablet = width >= 600;

    return CustomScaffold(
      topPadding: 0,
      child: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // HEADER
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
                          onTap: () => Navigator.pop(context)),
                      const SizedBox(width: 20),
                      Text(
                        "Checkout",
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
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 40 : 16,
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        _buildAddressSection(currentAddress),
                        const SizedBox(height: 20),
                        _buildPriceDetails(),
                        const SizedBox(height: 20),
                        _buildCouponSection(),
                        const SizedBox(height: 20),
                        _buildCartItemList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // BOTTOM BUTTON
          Positioned(
            bottom: 20,
            left: isTablet ? 40 : 16,
            right: isTablet ? 40 : 16,
            child: CustomButton(
              text: "Proceed to Payment",
              onTap: () => !_isProcessing ? _submitOrder() : null,
              isProcessing: _isProcessing,
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------
  // RESPONSIVE WIDGETS
  // --------------------------------------------------------------

  Widget _buildAddressSection(Map<String, dynamic> currentAddress) {
    final width = MediaQuery.sizeOf(context).width;
    final bool isTablet = width >= 600;
    final bool isLargeTablet = width >= 900;

    double titleFont = isLargeTablet
        ? 22
        : isTablet
            ? 18
            : 16;
    double subFont = isLargeTablet
        ? 18
        : isTablet
            ? 16
            : 14;
    double padding = isLargeTablet
        ? 26
        : isTablet
            ? 22
            : 16;

    if (_addressList.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(padding),
        child: Text(
          "No shipping address found. Please add one.",
          style: GoogleFonts.nunitoSans(
            fontSize: subFont,
            color: Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Container(
      width: width,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow:
            isTablet ? [BoxShadow(color: Colors.black12, blurRadius: 8)] : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Deliver to ${currentAddress['fullName']}, ${currentAddress['pincode']}",
            style: GoogleFonts.nunitoSans(
              fontSize: titleFont,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: isTablet ? 12 : 8),
          Text(
            "${currentAddress['address']}, ${currentAddress['city']}, ${currentAddress['state']}",
            style: GoogleFonts.nunitoSans(fontSize: subFont),
          ),
          SizedBox(height: isTablet ? 12 : 8),
          Text(
            "Contact: ${currentAddress['contactNumber']}",
            style: GoogleFonts.nunitoSans(fontSize: subFont),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceDetails() {
    final width = MediaQuery.sizeOf(context).width;
    final bool isTablet = width >= 600;

    double font = isTablet ? 16 : 14;
    double padding = isTablet ? 22 : 16;

    final subtotal = _pricing['subtotal'] ?? 0;
    final shipping = _pricing['ShippingAmount'] ?? 0;
    final tax = _pricing['tax'] ?? 0;
    final discount = _pricing['discount'] ?? 0;
    final coupondiscount = _pricing['CouponAmount'] ?? 0;
    final total = _pricing['total'] ?? 0;
    final taxPercent = _pricing["taxPercentage"] ?? 0;
    double finalDiscount = 0.0;

    if ((discount ?? 0) > 0) {
      finalDiscount = discount!;
    } else if ((coupondiscount ?? 0) > 0) {
      finalDiscount = coupondiscount!;
    }

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _priceRow("Subtotal", "\$${subtotal.toStringAsFixed(2)}", font),
          _priceRow(
              "Shipping & Handling", "\$${shipping.toStringAsFixed(2)}", font),
          _priceRow(
            "Discount",
            "- \$${finalDiscount.toStringAsFixed(2)}",
            font,
            color: Colors.green,
          ),
          // if (coupondiscount != 0)
          //   _priceRow(
          //     "Coupon Discount",
          //     "- \$${coupondiscount.toStringAsFixed(2)}",
          //     font,
          //     color: Colors.green,
          //   ),
          if (taxPercent != 0)
            _priceRow(
                "Tax ($taxPercent%)", "\$${tax.toStringAsFixed(2)}", font),
          const Divider(),
          _priceRow(
            "Total",
            "\$${total.toStringAsFixed(2)}",
            font,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value, double font,
      {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.nunitoSans(
                fontSize: font,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              )),
          Text(
            value,
            style: GoogleFonts.nunitoSans(
              fontSize: font,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemList() {
    final width = MediaQuery.sizeOf(context).width;
    final bool isTablet = width >= 600;

    double imageSize = isTablet ? 100 : 80;
    double titleFont = isTablet ? 16 : 14;
    double qtyFont = isTablet ? 15 : 13;
    double priceFont = isTablet ? 16 : 14;

    return Column(
      children: _cartItems.map((item) {
        final imageUrl = item['image'];
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: imageUrl != null && imageUrl.startsWith('http')
                    ? Image.network(
                        imageUrl,
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(imageSize),
                      )
                    : _placeholder(imageSize),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'] ?? "",
                      style: GoogleFonts.nunitoSans(
                        fontSize: titleFont,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Qty: ${item['quantity']}",
                      style: GoogleFonts.nunitoSans(
                        fontSize: qtyFont,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "\$${(item['totalPrice'] as num).toStringAsFixed(2)}",
                style: GoogleFonts.nunitoSans(
                  fontSize: priceFont,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _placeholder(double size) {
    return Container(
      width: size,
      height: size,
      color: Colors.grey[300],
      child: const Icon(Icons.image_not_supported),
    );
  }

  Widget _buildCouponSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Discount Coupon",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: couponController,
                  readOnly: isCouponApplied,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Coupon Code",
                  ),
                ),
              ),

              /// 🔥 APPLY / REMOVE
              (_pricing['CouponAmount'] ?? 0) != 0
                  ? GestureDetector(
                      onTap: removeCoupon,
                      child: const Text(
                        "REMOVE",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        final code = couponController.text.trim();
                        if (code.isNotEmpty) {
                          _applyCouponOnCart(code); // 🔥 BACKEND CALL
                        } else {
                          _showError("Please enter coupon code");
                        }
                      },
                      child: _isProcessingc
                          ? CircularProgressIndicator(
                              strokeWidth: 1.5,
                            )
                          : Text(
                              "APPLY",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        /// VIEW ALL COUPONS
        GestureDetector(
          onTap: () async {
            if (_cartId == null) return;

            final applied = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (_) => ApplyCouponPage(
                  cartId: _cartId!,
                  onSelect: (_) {},
                ),
              ),
            );

            if (applied == true && mounted) {
              await _fetchItemList();
            }
          },
          child: const Row(
            children: [
              Text("View all coupons"),
              Icon(Icons.keyboard_arrow_right),
            ],
          ),
        ),
      ],
    );
  }

  void applyCoupon(String code) {
    if (code.isEmpty) return;

    setState(() {
      appliedCoupon = code;
      isCouponApplied = true;
      couponController.text = code;
    });

    // 👉 OPTIONAL: backend ko notify karo
    // _applyCouponOnCart(code);
  }

  Future<void> removeCoupon() async {
    appliedCoupon = null;
    isCouponApplied = false;
    discountAmount = 0;
    couponController.clear();
    final url = Uri.parse('$_baseUrl/products/coupons/remove');
    setState(() => _isProcessing = true);

    try {
      final request = http.MultipartRequest("POST", url);

      request.headers.addAll({
        "Authorization": _token,
      });

      request.fields.addAll({
        "cartId": _cartId.toString(),
      });

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _fetchItemList();
      } else {
        _showError(body["message"] ?? "Coupon apply failed");
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  // 👉 OPTIONAL backend call
  // _removeCouponFromCart();

  Future<void> _applyCouponOnCart(String code) async {
    if (_cartId == null || code.isEmpty) return;

    final url = Uri.parse('$_baseUrl/products/coupons/apply');
    setState(() => _isProcessingc = true);

    try {
      final request = http.MultipartRequest("POST", url);

      request.headers.addAll({
        "Authorization": _token,
      });

      request.fields.addAll({
        "cartId": _cartId!,
        "code": code,
      });

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        /// ✅ Coupon applied successfully
        appliedCoupon = code;
        isCouponApplied = true;
        couponController.text = code;

        await _fetchItemList(); // 🔥 pricing reload
      } else {
        _showError(body["message"] ?? "Invalid coupon");
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _isProcessingc = false);
    }
  }
}
