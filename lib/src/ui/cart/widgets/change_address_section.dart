import 'dart:convert';

import 'package:Artisan/src/constants/colors.dart';
import 'package:Artisan/src/logic/services/preference_services.dart';
import 'package:Artisan/src/ui/cart/address/addressSelection_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../../logic/services/api_services/retrofit/auth_api_client/auth_api_client.dart';

class ChangeAddressSection extends ConsumerStatefulWidget {
  const ChangeAddressSection({super.key});

  @override
  ConsumerState<ChangeAddressSection> createState() =>
      _ChangeAddressSectionState();
}

class _ChangeAddressSectionState extends ConsumerState<ChangeAddressSection> {
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
          };
        }).toList();

        // Set current address
        final current = _addressList.firstWhere(
          (a) => a['isCurrent'] == 'true',
          orElse: () => _addressList.first,
        );

        _selectedAddressId = current['id'];

        setState(() {});
      } else {
        _showError('Failed to fetch addresses: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      _showError('Please add your address: ');
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedAddress = _addressList.firstWhere(
      (a) => a['id'] == _selectedAddressId,
      orElse: () => {},
    );

    final pinCode = selectedAddress['label']?.split(' - ').last ?? '';
    final addressText = selectedAddress['label'] ?? 'Select address';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xffFFE5E7),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Image.asset(
                'assets/images/ic_truck.png',
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deliver to $pinCode',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w500,
                        color: blackPrimaryColor,
                        fontSize: 14,
                        letterSpacing: -.1,
                      ),
                    ),
                    Text(
                      addressText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff818181),
                        fontSize: 12,
                        letterSpacing: -.1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 7),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => AddressSelectionSheet(
                      isFromProfile: false,
                    ),
                  ).then((_) {
                    _fetchAddressList(); // Refresh after bottom sheet closes
                  });
                },
                child: Container(
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: primaryColor, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Center(
                      child: Text(
                        "Change",
                        style: GoogleFonts.nunitoSans(
                          color: primaryColor,
                          fontSize: 14,
                          letterSpacing: -.1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
