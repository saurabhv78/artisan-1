import 'dart:convert';
import 'package:Artisan/src/logic/services/preference_services.dart';
import 'package:Artisan/src/ui/cart/address/addNewAddress.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Artisan/src/widgets/custom_button.dart';

class AddressSelectionSheet extends StatefulWidget {
  const AddressSelectionSheet({super.key});

  @override
  State<AddressSelectionSheet> createState() => _AddressSelectionSheetState();
}

class _AddressSelectionSheetState extends State<AddressSelectionSheet> {
  @override
  void initState() {
    _getAddress();
    super.initState();
    // Initialize any necessary data or state here
  }

  final String _baseUrl = 'http://3.111.86.244:3000/api/v1';
  final String _token = PreferenceService.authToken;

  String _selected = 'Home';
  bool _isProcessing = false;

  final List<Map<String, String>> _staticAddresses = [
    {
      'label': 'Home',
      'sub': 'No.10 Green Apartments, Chennai',
    },
    {
      'label': 'Office',
      'sub': 'Apartment, building, suite (optional)',
    },
    {
      'label': 'Parent’s House',
      'sub': 'Apartment, building, suite (optional)',
    },
    {
      'label': 'Friend’s House',
      'sub': 'Apartment, building, suite (optional)',
    },
  ];

  Future<void> _getAddress() async {
    setState(() => _isProcessing = true);

    final url = Uri.parse('$_baseUrl/auth/user/address');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'label': _selected}),
      );

      setState(() => _isProcessing = false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address saved successfully!')),
        );
        Navigator.pop(context);
      } else {
        _showError('Failed: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      _showError('Error: $e');
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 32),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        gradient: LinearGradient(
          colors: [Color(0xFFF4F4FF), Color(0xFFEAEAEA)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                child: const Icon(Icons.close),
                onTap: () => Navigator.pop(context),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Colors.red),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddressFormScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 10),

          /// Address Options
          ..._staticAddresses.map((item) {
            final isSelected = _selected == item['label'];
            return ListTile(
              leading: Icon(
                Icons.location_on,
                color: isSelected ? Colors.red : Colors.grey,
              ),
              title: Text(
                item['label']!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.black : Colors.grey[800],
                ),
              ),
              subtitle: Text(
                item['sub']!,
                style: TextStyle(color: Colors.grey[600]),
              ),
              trailing: Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isSelected ? Colors.red : Colors.grey,
              ),
              onTap: () {
                setState(() => _selected = item['label']!);
              },
            );
          }),

          const SizedBox(height: 20),

          /// Save Button
          CustomButton(
            text: 'Save Changes',
            onTap: () {},
            //  _saveAddress,
            isProcessing: _isProcessing,
          ),
        ],
      ),
    );
  }
}
