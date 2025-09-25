import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:Artisan/src/logic/services/preference_services.dart';
import 'package:Artisan/src/ui/cart/address/addNewAddress.dart';
import 'package:Artisan/src/widgets/custom_button.dart';

import '../../../logic/services/api_services/retrofit/auth_api_client/auth_api_client.dart';

class AddressSelectionSheet extends ConsumerStatefulWidget {
  const AddressSelectionSheet({super.key, required bool isFromProfile});

  @override
  ConsumerState<AddressSelectionSheet> createState() =>
      _AddressSelectionSheetState();
}

class _AddressSelectionSheetState extends ConsumerState<AddressSelectionSheet> {
  late String _token;
  String? _selectedAddressId;
  bool _isProcessing = false;
  List<Map<String, String>> _addressList = [];
  final String _baseUrl = apiBaseUrl;

  @override
  void initState() {
    super.initState();
    _token = ref.read(preferenceServiceProvider).getString("auth_token") ?? '';
    _fetchAddressList();
  }

  /// Fetch all user addresses
  Future<void> _fetchAddressList() async {
    setState(() => _isProcessing = true);

    final url = Uri.parse('$_baseUrl/auth/user/address');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': _token,
          'Content-Type': 'application/json',
        },
      );

      setState(() => _isProcessing = false);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List<dynamic> data = body['data'] ?? [];

        _addressList = data.map<Map<String, String>>((item) {
          final fullAddress =
              "${item['address']}, ${item['city']}, ${item['state']} - ${item['pincode']}";
          return {
            'id': item['id'],
            'label': fullAddress,
            'sub': 'Created at: ${item['createdAt']}',
            'isCurrent': item['isCurrentAddress'].toString(),
            'fullName': item['fullName'] ?? '',
            'contactNumber': item['contactNumber'] ?? '',
          };
        }).toList();

        final currentAddress = _addressList.firstWhere(
          (item) => item['isCurrent'] == 'true',
          orElse: () => _addressList.isNotEmpty ? _addressList.first : {},
        );

        _selectedAddressId = currentAddress['id'];

        setState(() {});
      } else {
        _showError('Failed to fetch addresses: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      _showError('Error fetching addresses: $e');
    }
  }

  /// Save selected address to backend
  Future<void> _saveSelectedAddress() async {
    if (_selectedAddressId == null) {
      _showError('Please select an address');
      return;
    }

    setState(() => _isProcessing = true);

    final url = Uri.parse('$_baseUrl/auth/address/current');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': _token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'id': _selectedAddressId}),
      );

      setState(() => _isProcessing = false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address saved successfully!')),
        );
        Navigator.pop(context);
      } else {
        _showError('Failed to save address: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      _showError('Error saving address: $e');
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.8, // 80% height
      child: SingleChildScrollView(
        child: Container(
          padding:
              const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 32),
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
                    icon:
                        const Icon(Icons.add_circle_outline, color: Colors.red),
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

              /// Address List
              if (_addressList.isEmpty && !_isProcessing)
                const Text("No saved addresses found"),
              ..._addressList.map((item) {
                final isSelected = _selectedAddressId == item['id'];
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
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Name: ${item['fullName']}"),
                      Text("Mobile: ${item['contactNumber']}"),
                    ],
                  ),
                  trailing: Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: isSelected ? Colors.red : Colors.grey,
                  ),
                  onTap: () {
                    setState(() => _selectedAddressId = item['id']);
                  },
                );
              }),

              const SizedBox(height: 20),

              /// Save Button
              CustomButton(
                text: 'Save Changes',
                onTap: _saveSelectedAddress,
                isProcessing: _isProcessing,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
