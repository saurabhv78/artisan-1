import 'package:Artisan/src/constants/colors.dart';
import 'package:Artisan/src/ui/auth/widgets/back_btn.dart';
import 'package:Artisan/src/ui/cart/widgets/widgets.dart';
import 'package:Artisan/src/widgets/custom_button.dart';
import 'package:Artisan/src/widgets/custom_scaffold.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddressFormScreen extends StatefulWidget {
  const AddressFormScreen({super.key});

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      bgColor: Colors.white,
      // Gradient background
      child: Stack(children: [
        Column(
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 15, 25, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BackBtn(
                      iconColor: Colors.black,
                      onTap: () {
                        Navigator.pop(context);
                        // context.maybePop();
                      },
                    ),
                    const SizedBox(width: 20),
                    Text(
                      "Your Address",
                      style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w400,
                        color: bgDark,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    buildInputField(_streetController, 'Flat/Building,Street'),
                    const SizedBox(height: 16),
                    buildInputField(_cityController, 'City'),
                    const SizedBox(height: 16),
                    buildInputField(_stateController, 'State'),
                    const SizedBox(height: 16),
                    buildInputField(_postalCodeController, 'Postal Code'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Save Button
            CustomButton(
              isProcessing: false,
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  // Handle save logic
                  print('Address Saved');
                }
              },
              text: 'Save Changes',
            ),
          ],
        ),
      ]),

      // Bottom Navigation Bar
    );
  }

  Widget buildInputField(TextEditingController controller, String hint) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.nunitoSans(
          fontSize: 16,
          color: Colors.grey,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Required';
        }
        return null;
      },
    );
  }
}
