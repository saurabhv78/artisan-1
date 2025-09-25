import 'dart:convert';
import 'dart:developer';
import 'package:Artisan/src/constants/colors.dart';
import 'package:Artisan/src/ui/auth/widgets/back_btn.dart';
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
        log(response.body);
        final data = body['data'];
        var paymentId = data['paymentId']?.toString();
        final razorpayOrderId = data['razorpayOrderId'];
        final amount = (data['amountInPaise'] as num).toInt();
        final currency = data['currency'] ?? 'INR';
        final razorpayKey = data['razorpayKey']?.toString().isNotEmpty == true
            ? data['razorpayKey']
            : 'rzp_test_RIZLixlOa7cEqX'; // fallback
        final prefill = data['razorpayPrefill'] ?? {};

        setState(() {
          _paymentId = paymentId;
        });
        _startRazorpayPayment(
          key: razorpayKey,
          orderId: razorpayOrderId,
          amount: amount,
          currency: currency,
          prefill: {
            'name': prefill['name']?.toString() ?? '',
            'email': prefill['email']?.toString() ?? '',
            'contact': prefill['contact']?.toString() ?? '',
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
      debugPrint('Opening Razorpay with: $options');
      _razorpay.open(options);
    } catch (e) {
      _showError('Razorpay error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text("✅ Payment Successful\nPayment ID: ${response.paymentId}"),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder: (context) => const PaymentPage(),
      ),
    );

    await _verifyPaymentOnBackend(response);
  }

  Future<void> _verifyPaymentOnBackend(PaymentSuccessResponse response) async {
    final url = Uri.parse('$_baseUrl/auth/order/verify/payment');

    final payload = {
      "razorpayOrderId": response.orderId,
      "signature": response.signature,
      "razorpayPaymentId": response.paymentId,
      "paymentId": _paymentId ?? "",
      "cartId": _cartId ?? "",
      "shippingAddressId": _selectedAddressId ?? "",
//       {
//     "razorpayOrderId":"order_QrRvx8vIqsz0oj",
//     "paymentId":"686ffa5b2543184784171273",
//     "signature":"20541639c086ebbbba07470c0a779025c080a075dfee4d35def8e51832fe7072",
//     "razorpayPaymentId":"pay_QrRwtXF1r6eAiX",
//     "cartId":"",
//     "shippingAddressId":""
// }
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

      if (res.statusCode == 201) {
        final body = jsonDecode(res.body);
        final message = body['message'] ?? 'Payment verified successfully.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ $message"), backgroundColor: Colors.green),
        );
      } else {
        final body = jsonDecode(res.body);
        final message = body['message'] ?? 'Verification failed';
        // ScaffoldMessenger.of(context).showSnackBar(
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ $message"), backgroundColor: Colors.green),

          // SnackBar(
          //   content: Text("⚠️ Verification failed: ${res.statusCode}"),
          //   backgroundColor: Colors.orange,
          // ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error verifying payment: $e")),
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("❌ Payment Failed\n${response.message}"),
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
        _addressList = data.map<Map<String, dynamic>>((item) {
          return {
            'id': item['id'],
            'fullName': item['fullName'],
            'contactNumber': item['contactNumber'],
            'address': item['address'],
            'city': item['city'],
            'state': item['state'],
            'pincode': item['pincode'],
            'isCurrent': item['isCurrentAddress'] == true,
          };
        }).toList();

        final currentAddress = _addressList.firstWhere(
          (e) => e['isCurrent'] == true,
          orElse: () => _addressList.isNotEmpty ? _addressList.first : {},
        );
        _selectedAddressId = currentAddress['id'];
        setState(() {});
      } else {
        _showError('Address fetch failed.');
      }
    } catch (e) {
      _showError('Error: $e');
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
        _cartItems = data['items'] ?? [];
        _pricing = data['pricing'] ?? {};
        _cartId = data['id'];
        setState(() {});
      } else {
        _showError('Cart fetch failed.');
      }
    } catch (e) {
      _showError('Error: $e');
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final currentAddress = _addressList.firstWhere(
      (item) => item['id'] == _selectedAddressId,
      orElse: () => {},
    );

    return CustomScaffold(
      topPadding: 35,
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 15, 25, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BackBtn(
                      iconColor: Colors.black,
                      onTap: () {
                        log("Back button pressed");
                        Navigator.pop(
                            context); // Un-commented for proper behavior
                      },
                    ),
                    const SizedBox(width: 30),
                    Text(
                      "Checkout",
                      style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w400,
                        color: bgDark,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 100, left: 16, right: 16),
                  child: Column(
                    children: [
                      _buildAddressSection(currentAddress),
                      const SizedBox(height: 20),
                      _buildPriceDetails(),
                      const SizedBox(height: 20),
                      _buildCartItemList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: CustomButton(
              text: "Proceed to Payment",
              onTap: () {
                if (!_isProcessing) {
                  _submitOrder();
                }
              },
              isProcessing: _isProcessing,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection(Map<String, dynamic> currentAddress) {
    if (_addressList.isEmpty) {
      return const Text("No address found.");
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'Deliver to ${currentAddress['fullName']}, ${currentAddress['pincode']}',
              style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 6),
          Text(
              '${currentAddress['address']}, ${currentAddress['city']}, ${currentAddress['state']}',
              style: GoogleFonts.nunitoSans(fontSize: 14)),
          const SizedBox(height: 6),
          Text('Contact: ${currentAddress['contactNumber']}',
              style: GoogleFonts.nunitoSans(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildPriceDetails() {
    final subtotal = _pricing['subtotal'] ?? 0;
    final shippingAmount = _pricing['ShippingAmount'] ?? 0;
    final tax = _pricing['tax'] ?? 0;
    final discount = _pricing['discount'] ?? 0;
    final total = _pricing['total'] ?? 0;
    final taxPercentage = _pricing["taxPercentage"] ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _priceRow('Subtotal', '₹${subtotal.toStringAsFixed(2)}'),
          _priceRow('Shipping & Handling Cost',
              '₹${shippingAmount.toStringAsFixed(2)}'),
          _priceRow('Discount', '- ₹${discount.toStringAsFixed(2)}',
              color: Colors.green),
          _priceRow('Tax ' + "($taxPercentage%)", '₹${tax.toStringAsFixed(2)}'),
          const Divider(),
          _priceRow('Total', '₹${total.toStringAsFixed(2)}',
              isBold: true, color: Colors.black),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String amount,
      {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(amount,
              style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  color: color ?? Colors.black,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildCartItemList() {
    return Column(
      children: _cartItems.map((item) {
        final imageUrl = item['image'];
        final isValidImage = imageUrl != null &&
            imageUrl is String &&
            imageUrl.trim().isNotEmpty &&
            imageUrl.startsWith('http');

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: isValidImage
                    ? Image.network(
                        imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _placeholderImage(),
                      )
                    : _placeholderImage(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['name'] ?? '',
                        style: GoogleFonts.nunitoSans(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    Text('Qty: ${item['quantity']}',
                        style: GoogleFonts.nunitoSans(
                            fontSize: 13, color: Colors.grey[700])),
                  ],
                ),
              ),
              Text('₹${(item['totalPrice'] as num).toStringAsFixed(2)}',
                  style: GoogleFonts.nunitoSans(
                      fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 60,
      height: 60,
      color: Colors.grey[300],
      alignment: Alignment.center,
      child: const Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }
}
