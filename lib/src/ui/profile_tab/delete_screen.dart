import 'dart:convert';
import 'package:Artisan/src/logic/repositories/auth_repository.dart';
import 'package:Artisan/src/logic/services/api_services/retrofit/auth_api_client/auth_api_client.dart';
import 'package:Artisan/src/logic/services/preference_services.dart';
import 'package:Artisan/src/ui/auth/widgets/back_btn.dart';
import 'package:Artisan/src/ui/profile_tab/otp_screen_delete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  ConsumerState<DeleteAccountScreen> createState() =>
      _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  bool agree1 = false;
  bool agree2 = false;
  bool isProcessing = false;
  final TextEditingController _emailController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authRepositoryProvider).authUser?.userData;

      _emailController.text = user?.email ?? '';
      print(_emailController.text);
    });
  }

  final String baseUrl = apiBaseUrl; // CHANGE THIS

  Future<void> deleteAccountAPI() async {
    if (!agree1 || !agree2) return;

    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showSnack("Email is required", Colors.red);
      return;
    }

    setState(() => isProcessing = true);

    final token =
        ref.read(preferenceServiceProvider).getString("auth_token") ?? '';

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/send/otp/delete/user"),
        headers: {
          "Content-Type": "application/json", // IMPORTANT
          "Authorization": token, // change to "Bearer $token" if required
        },
        body: jsonEncode({
          "email": email,
        }),
      );

      setState(() => isProcessing = false);

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OtpScreenDeteteUser(
                    email: email,
                  )),
        );
      } else {
        final data = jsonDecode(response.body);
        _showSnack(data["message"] ?? "Something went wrong", Colors.red);
      }
    } catch (e) {
      setState(() => isProcessing = false);
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
    final deleteEnabled = agree1 && agree2 && !isProcessing;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 40),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xfff1e9ff),
              Color(0xffe4f7f5),
            ],
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
                SizedBox(
                  width: 30,
                ),
                Text(
                  "Delete Your Account",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              "Permanently Delete Your Account",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Deleting your account will permanently remove your profile and "
              "personal data. This action cannot be undone and you will lose access to:",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 10),
            const Text("• Saved payment methods and addresses"),
            const Text("• Order history and purchase records"),
            const Text("• Saved favorites or wish lists"),
            const SizedBox(height: 30),
            const Text(
              "Legal and Data Retention Notice",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "We must retain certain transaction data (like invoices) for a limited "
              "time due to tax and legal requirements. This is handled safely "
              "under our Privacy Policy.",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 30),
            const Text(
              "Delete My Account",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Checkbox(
                  value: agree1,
                  onChanged: (v) => setState(() => agree1 = v!),
                ),
                const Expanded(
                  child: Text(
                    "I understand deleting my account is permanent and "
                    "will result in the loss of all history.",
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: agree2,
                  onChanged: (v) => setState(() => agree2 = v!),
                ),
                const Expanded(
                  child: Text(
                    "I have read and agree to the Terms & Conditions.",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 100,
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Colors.grey),
                    ),
                    child: const Text("Keep My Account"),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: deleteEnabled ? deleteAccountAPI : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor:
                          deleteEnabled ? Colors.red : Colors.redAccent,
                    ),
                    child: isProcessing
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(
                            "Delete My Account",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  
}
