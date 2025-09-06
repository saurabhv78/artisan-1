import 'dart:convert';
import 'package:Artisan/src/constants/colors.dart';
import 'package:Artisan/src/logic/services/preference_services.dart';
import 'package:Artisan/src/ui/auth/widgets/back_btn.dart';
import 'package:Artisan/src/ui/cart/widgets/widgets.dart';
import 'package:Artisan/src/widgets/custom_button.dart';
import 'package:Artisan/src/widgets/custom_scaffold.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AddressFormScreen extends ConsumerStatefulWidget {
  final String? editAddressId;
  const AddressFormScreen({super.key, this.editAddressId});

  @override
  ConsumerState<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends ConsumerState<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _mobileController = TextEditingController();

  bool _isSaving = false;
  final String _baseUrl = 'http://3.111.86.244:3000/api/v1';

  @override
  void initState() {
    super.initState();
    if (widget.editAddressId != null) {
      _loadAddressDetails(widget.editAddressId!);
    }
  }

  Future<void> _loadAddressDetails(String id) async {
    final token =
        ref.read(preferenceServiceProvider).getString("auth_token") ?? '';
    final url = Uri.parse('$_baseUrl/auth/address/byId');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'id': id}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        _streetController.text = data['address'] ?? '';
        _cityController.text = data['city'] ?? '';
        _stateController.text = data['state'] ?? '';
        _countryController.text = data['country'] ?? '';
        _postalCodeController.text = data['pincode'] ?? '';
        _fullNameController.text = data['fullName'] ?? '';
        _mobileController.text = data['contactNumber'] ?? '';
      } else {
        _showError('Failed to load address');
      }
    } catch (e) {
      _showError('Error loading address: $e');
    }
  }

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _fullNameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    final token =
        ref.read(preferenceServiceProvider).getString("auth_token") ?? '';
    final isEdit = widget.editAddressId != null;

    final url = Uri.parse(isEdit
        ? '$_baseUrl/auth/address/update'
        : '$_baseUrl/auth/address/add');

    final body = {
      "address": _streetController.text.trim(),
      "city": _cityController.text.trim(),
      "state": _stateController.text.trim(),
      "country": _countryController.text.trim(),
      "pincode": _postalCodeController.text.trim(),
      "fullName": _fullNameController.text.trim(),
      "contactNumber": _mobileController.text.trim(),
    };

    if (isEdit) {
      body["id"] = widget.editAddressId!;
    }

    setState(() => _isSaving = true);

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      setState(() => _isSaving = false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEdit
                ? 'Address updated successfully!'
                : 'Address saved successfully!'),
          ),
        );
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        final resBody = jsonDecode(response.body);
        _showError(resBody['message'] ?? 'Failed to save address');
      }
    } catch (e) {
      setState(() => _isSaving = false);
      _showError('Error saving address: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      topPadding: 35,
      // bgColor: Colors.white,
      child: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 15, 25, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BackBtn(
                      iconColor: Colors.black,
                      onTap: () => Navigator.pop(context),
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
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      buildInputField(
                          _streetController, 'Flat/Building, Street'),
                      const SizedBox(height: 16),
                      buildInputField(_cityController, 'City'),
                      const SizedBox(height: 16),
                      buildInputField(_stateController, 'State'),
                      const SizedBox(height: 16),
                      buildInputField(_countryController, 'Country'),
                      const SizedBox(height: 16),
                      buildInputField(
                        _postalCodeController,
                        'Postal Code',
                        inputType: TextInputType.number,
                        maxLength: 6,
                        minLength: 6,
                      ),
                      const SizedBox(height: 16),
                      buildInputField(_fullNameController, 'Full Name'),
                      const SizedBox(height: 16),
                      buildInputField(
                        _mobileController,
                        'Mobile Number',
                        inputType: TextInputType.number,
                        maxLength: 10,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              CustomButton(
                isProcessing: _isSaving,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    _saveAddress();
                  }
                },
                text: 'Save Changes',
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget buildInputField(
    TextEditingController controller,
    String hint, {
    TextInputType inputType = TextInputType.text,
    int? maxLength,
    int? minLength,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      maxLength: maxLength,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.nunitoSans(
          fontSize: 16,
          color: Colors.grey,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: Colors.white,
        counterText: "",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'Required';
        if (minLength != null && value.length < minLength) {
          return 'Minimum $minLength characters required';
        }
        if (maxLength != null && value.length > maxLength) {
          return 'Maximum $maxLength characters allowed';
        }
        return null;
      },
    );
  }
}
