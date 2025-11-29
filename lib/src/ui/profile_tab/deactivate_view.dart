import 'dart:convert';
import 'package:Artisan/src/constants/colors.dart';
import 'package:Artisan/src/logic/services/api_services/retrofit/auth_api_client/auth_api_client.dart';
import 'package:Artisan/src/logic/services/preference_services.dart';
import 'package:Artisan/src/ui/auth/widgets/back_btn.dart';
import 'package:Artisan/src/ui/auth/widgets/custom_auth_btn.dart';
import 'package:Artisan/src/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

/// ------------------------------------------------------
/// MODEL
/// ------------------------------------------------------
class DeactivatePageModel {
  final String email;
  final String password;

  DeactivatePageModel({
    this.email = "",
    this.password = "",
  });

  DeactivatePageModel copyWith({
    String? email,
    String? password,
  }) {
    return DeactivatePageModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}

/// ------------------------------------------------------
/// NOTIFIER
/// ------------------------------------------------------
class DeactivatePageNotifier extends StateNotifier<DeactivatePageModel> {
  DeactivatePageNotifier() : super(DeactivatePageModel());

  void setEmail(String value) => state = state.copyWith(email: value);

  void setPassword(String value) => state = state.copyWith(password: value);
}

final deactivatePageProvider =
    StateNotifierProvider<DeactivatePageNotifier, DeactivatePageModel>(
        (ref) => DeactivatePageNotifier());

/// ------------------------------------------------------
/// SCREEN
/// ------------------------------------------------------
class DeactivateScreen extends ConsumerStatefulWidget {
  const DeactivateScreen({super.key});

  @override
  ConsumerState<DeactivateScreen> createState() => _DeactivateScreenState();
}

class _DeactivateScreenState extends ConsumerState<DeactivateScreen> {
  bool isProcessing = false;
  bool isPasswordVisible = false;
  final String _baseUrl = apiBaseUrl;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();

    final model = ref.read(deactivatePageProvider);

    emailController = TextEditingController(text: model.email);
    passwordController = TextEditingController(text: model.password);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// ------------------------------------------------------
  /// API CALL
  /// ------------------------------------------------------
  Future<void> deactivateUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnack("Please fill all fields", Colors.red);
      return;
    }

    setState(() => isProcessing = true);

    try {
      // 🔥 READ TOKEN FROM RIVERPOD
      final token =
          ref.read(preferenceServiceProvider).getString("auth_token") ?? '';

      final url = Uri.parse(
        "$_baseUrl/auth/deactivate/$email",
      );

      // 🔥 SEND TOKEN IN HEADERS
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "$token",
        },
      );

      setState(() => isProcessing = false);

      if (response.statusCode == 200) {
        _showSuccessDialog();
      } else {
        final error = jsonDecode(response.body);
        _showSnack(error["message"] ?? "Something went wrong", Colors.red);
      }
    } catch (e) {
      setState(() => isProcessing = false);
      _showSnack("Server connection failed", Colors.red);
    }
  }

  /// Snackbar
  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  /// Success popup
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Account Deactivated"),
        content: const Text("Your account has been successfully deactivated."),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("OK"))
        ],
      ),
    );
  }

  /// ------------------------------------------------------
  /// UI
  /// ------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      topPadding: 35,
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isTablet = constraints.maxWidth > 600;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: SizedBox(
                width: isTablet ? 450 : double.infinity,
                child: ListView(
                  children: [
                    BackBtn(
                      iconColor: Colors.black,
                      onTap: () => Navigator.pop(context),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      "Deactivate Account",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // -------------------------
                    // EMAIL INPUT
                    // -------------------------
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: emailController,
                        enabled: !isProcessing,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: "Enter your email",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                        onChanged:
                            ref.read(deactivatePageProvider.notifier).setEmail,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // -------------------------
                    // PASSWORD INPUT
                    // -------------------------
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: passwordController,
                        enabled: !isProcessing,
                        obscureText: !isPasswordVisible,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Enter your password",
                          hintStyle: const TextStyle(color: Colors.black54),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                          suffixIcon: GestureDetector(
                            onTap: () => setState(
                                () => isPasswordVisible = !isPasswordVisible),
                            child: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        onChanged: ref
                            .read(deactivatePageProvider.notifier)
                            .setPassword,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // -------------------------
                    // BUTTON
                    // -------------------------
                    CustomAuthBtn(
                      borderColor: primaryColor,
                      backgroundcolor: primaryColor,
                      height: 50,
                      isProcessing: isProcessing,
                      onTap: deactivateUser,
                      text: "Continue to Deactivation",
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
