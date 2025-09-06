import 'package:Artisan/orders/my_order_list.dart';
import 'package:Artisan/src/constants/colors.dart';
import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

class PaymentPage extends StatelessWidget {
  final String? orderId;

  const PaymentPage({super.key, this.orderId});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent going back using back button
        return false;
      },
      child: Scaffold(
        // backgroundColor: subHead,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Icon(Icons.check_circle, color: primaryColor, size: 80),
                  const SizedBox(height: 20),
                  const Text(
                    "Your order is confirmed!",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  if (orderId != null)
                    Text(
                      "Order ID: $orderId",
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  const Text(
                    "Thank you for your order. You will be receiving a confirmation email with order details",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Back to Home",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OrdersPage()),
                      );
                      // TODO: Navigate to orders page
                    },
                    child: const Text("View My Orders",
                        style: TextStyle(color: Colors.blue)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
