import 'dart:async';
import 'dart:convert';
import 'package:Artisan/src/logic/repositories/auth_repository.dart';
import 'package:Artisan/src/logic/services/api_services/retrofit/auth_api_client/auth_api_client.dart';
import 'package:Artisan/src/ui/auth/widgets/back_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreenDeteteUser extends ConsumerStatefulWidget {
  final String email;
  OtpScreenDeteteUser({super.key, required this.email});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OtpScreenDeteteUserState();
}

class _OtpScreenDeteteUserState extends ConsumerState<OtpScreenDeteteUser> {
  final List<TextEditingController> otpControllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());

  bool isProcessing = false;
  bool isOtpComplete = false;

  // TIMER
  Timer? countdownTimer;
  int remainingSeconds = 300; // 5 minutes

  final String baseUrl = apiBaseUrl;

  @override
  void initState() {
    super.initState();
    startOtpTimer();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    for (var c in otpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  // -----------------------------------------------------------
  // TIMER FUNCTION
  // -----------------------------------------------------------
  void startOtpTimer() {
    countdownTimer?.cancel();
    remainingSeconds = 300;

    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });
  }

  String get formattedTime {
    int min = remainingSeconds ~/ 60;
    int sec = remainingSeconds % 60;
    return "$min:${sec.toString().padLeft(2, '0')}";
  }

  // -----------------------------------------------------------
  // VERIFY OTP
  // -----------------------------------------------------------
  Future<void> verifyotp() async {
    setState(() => isProcessing = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token") ?? "";

    final enteredOtp = otpControllers.map((c) => c.text).join();

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/permanent/delete/user"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
        body: jsonEncode({
          "otp": enteredOtp,
          'email': widget.email,
        }),
      );

      setState(() => isProcessing = false);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _showSnack(data["message"] ?? "Verified!", Colors.green);
        // final res = await ref.read(authRepositoryProvider.notifier).logOut();
        showDeleteSuccessPopup();

// wait 2 seconds
        await Future.delayed(const Duration(seconds: 2));

        final res = await ref.read(authRepositoryProvider.notifier).logOut();
      } else {
        final data = jsonDecode(response.body);
        _showSnack(data["message"] ?? "Something went wrong", Colors.red);
      }
    } catch (e) {
      setState(() => isProcessing = false);
      _showSnack("Server error", Colors.red);
    }
  }

  // -----------------------------------------------------------
  // RESEND OTP
  // -----------------------------------------------------------
  Future<void> resendOtp() async {
    for (var controller in otpControllers) {
      controller.clear();
    }
    startOtpTimer(); // restart 5-min timer

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token") ?? "";

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/send/otp/delete/user"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token, // or "Bearer $token" if required
        },
        body: jsonEncode({
          "email": widget.email, // <-- same email
        }),
      );

      if (response.statusCode == 200) {
        _showSnack("OTP Resent Successfully!", Colors.green);
      } else {
        final data = jsonDecode(response.body);
        _showSnack(data["message"] ?? "Something went wrong", Colors.red);
      }
    } catch (e) {
      _showSnack("Server error", Colors.red);
    }
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 40),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xfff1e9ff), Color(0xffe4f7f5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                BackBtn(
                  onTap: () => Navigator.pop(context),
                  iconColor: Colors.black,
                ),
                SizedBox(width: 30),
                Text("Delete Your Account",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ],
            ),

            SizedBox(height: 50),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(widget.email,
                    style: GoogleFonts.openSans(
                        color: Colors.black, fontSize: 16)),
              ),
            ),

            SizedBox(height: 20),

            Text("Enter OTP",
                style: GoogleFonts.openSans(color: Colors.black, fontSize: 14)),
            SizedBox(height: 10),

            // OTP BOXES
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  width: 55,
                  height: 55,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: TextField(
                    controller: otpControllers[index],
                    focusNode: focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        if (index < 3) {
                          FocusScope.of(context)
                              .requestFocus(focusNodes[index + 1]);
                        } else {
                          FocusScope.of(context).unfocus();
                        }
                      }

                      // ENABLE PROCEED WHEN OTP COMPLETE
                      final otp = otpControllers.map((c) => c.text).join();
                      setState(() {
                        isOtpComplete = otp.length == 4;
                      });
                    },
                  ),
                );
              }),
            ),

            SizedBox(height: 15),

            // TIMER + RESEND
            Center(
              child: remainingSeconds > 0
                  ? Text(
                      "Resend in $formattedTime",
                      style: TextStyle(fontSize: 14, color: Colors.red),
                    )
                  : TextButton(
                      onPressed: resendOtp,
                      child: Text("Resend OTP",
                          style: TextStyle(fontSize: 16, color: Colors.blue)),
                    ),
            ),

            Spacer(),

            // BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // CANCEL
                SizedBox(
                  width: 150,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text("Cancel", style: TextStyle(fontSize: 16)),
                  ),
                ),

                // PROCEED
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed:
                        !isOtpComplete || isProcessing ? null : verifyotp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: isProcessing
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Proceed",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showDeleteSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xffeae8ed),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Account Deleted",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Grey Tick Icon (Circular badge)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Your account has been deleted successfully",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Exit Button
                  SizedBox(
                    width: 120,
                    height: 42,
                    child: OutlinedButton(
                      onPressed: () async {
                        final res = await ref
                            .read(authRepositoryProvider.notifier)
                            .logOut();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade600),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Exit",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
