// import 'package:Artisan/src/constants/colors.dart';
// import 'package:Artisan/src/logic/services/preference_services.dart';
// import 'package:Artisan/src/ui/auth/widgets/back_btn.dart';
// import 'package:Artisan/src/ui/cart/address/addNewAddress.dart';
// import 'package:Artisan/src/widgets/custom_button.dart';
// import 'package:Artisan/src/widgets/custom_scaffold.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'dart:convert';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;

// import '../../logic/services/api_services/retrofit/auth_api_client/auth_api_client.dart';

// class EditAddress extends ConsumerStatefulWidget {
//   const EditAddress({super.key});

//   @override
//   ConsumerState<EditAddress> createState() => _EditAddressState();
// }

// class _EditAddressState extends ConsumerState<EditAddress> {
//   late String _token;
//   String? _selectedAddressId;
//   bool _isProcessing = false;
//   List<Map<String, String>> _addressList = [];
//   final String _baseUrl = apiBaseUrl;

//   @override
//   void initState() {
//     super.initState();
//     _token = ref.read(preferenceServiceProvider).getString("auth_token") ?? '';
//     _fetchAddressList();
//   }

//   /// Fetch all user addresses
//   Future<void> _fetchAddressList() async {
//     setState(() => _isProcessing = true);

//     final url = Uri.parse('$_baseUrl/auth/user/address');

//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Authorization': _token,
//           'Content-Type': 'application/json',
//         },
//       );

//       setState(() => _isProcessing = false);

//       if (response.statusCode == 200) {
//         final body = jsonDecode(response.body);
//         final List<dynamic> data = body['data'] ?? [];

//         _addressList = data.map<Map<String, String>>((item) {
//           final fullAddress =
//               "${item['address']}, ${item['city']}, ${item['state']} - ${item['pincode']}";
//           return {
//             'id': item['id'],
//             'label': fullAddress,
//             'sub': 'Created at: ${item['createdAt']}',
//             'isCurrent': item['isCurrentAddress'].toString(),
//             'fullName': item['fullName'] ?? '',
//             'contactNumber': item['contactNumber'] ?? '',
//           };
//         }).toList();

//         final currentAddress = _addressList.firstWhere(
//           (item) => item['isCurrent'] == 'true',
//           orElse: () => _addressList.isNotEmpty ? _addressList.first : {},
//         );

//         _selectedAddressId = currentAddress['id'];

//         setState(() {});
//       } else {
//         _showError('Failed to fetch addresses: ${response.statusCode}');
//       }
//     } catch (e) {
//       setState(() => _isProcessing = false);
//       _showError('Error fetching addresses: $e');
//     }
//   }

//   /// Save selected address to backend
//   Future<void> _saveSelectedAddress() async {
//     if (_selectedAddressId == null) {
//       _showError('Please select an address');
//       return;
//     }

//     setState(() => _isProcessing = true);

//     final url = Uri.parse('$_baseUrl/auth/address/current');

//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Authorization': _token,
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({'id': _selectedAddressId}),
//       );

//       setState(() => _isProcessing = false);

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Address saved successfully!')),
//         );
//         Navigator.pop(context);
//       } else {
//         _showError('Failed to save address: ${response.statusCode}');
//       }
//     } catch (e) {
//       setState(() => _isProcessing = false);
//       _showError('Error saving address: $e');
//     }
//   }

//   Future<void> _deleteSelectedAddress(id) async {
//     if (_selectedAddressId == null) {
//       _showError('Please select an address');
//       return;
//     }

//     setState(() => _isProcessing = true);

//     final url = Uri.parse('$_baseUrl/auth/address/remove');

//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Authorization': _token,
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({'id': id}),
//       );

//       setState(() => _isProcessing = false);

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Address delete successfully!')),
//         );
//         Navigator.pop(context);
//       } else {
//         _showError('Failed to save address: ${response.statusCode}');
//       }
//     } catch (e) {
//       setState(() => _isProcessing = false);
//       _showError('Error saving address: $e');
//     }
//   }

//   void _showError(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(msg)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomScaffold(
//       topPadding: 35,
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               // color: Colors.white,
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(25, 15, 25, 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     BackBtn(
//                       iconColor: Colors.black,
//                       onTap: () {
//                         context.maybePop();
//                       },
//                     ),
//                     const SizedBox(
//                       width: 15,
//                     ),
//                     Text(
//                       "Saved Addresses",
//                       style: GoogleFonts.nunitoSans(
//                         fontWeight: FontWeight.w400,
//                         color: bgDark,
//                         fontSize: 24,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             if (_addressList.isEmpty && !_isProcessing)
//               const Text("No saved addresses found"),
//             ..._addressList.map((item) {
//               final isSelected = _selectedAddressId == item['id'];
//               return ListTile(
//                 selectedColor: Colors.red,
//                 leading: Icon(
//                   Icons.location_on,
//                   color: isSelected ? Colors.red : Colors.grey,
//                 ),
//                 title: Text(
//                   item['label']!,
//                   style: GoogleFonts.nunitoSans(
//                     fontWeight: FontWeight.w400,
//                     color: bgDark,
//                     fontSize: 14,
//                   ),
//                 ),
//                 subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Name: ${item['fullName']}",
//                           style: GoogleFonts.nunitoSans(
//                             fontWeight: FontWeight.w400,
//                             color: bgDark,
//                             fontSize: 14,
//                           )),
//                       Text("Mobile: ${item['contactNumber']}",
//                           style: GoogleFonts.nunitoSans(
//                             fontWeight: FontWeight.w400,
//                             color: bgDark,
//                             fontSize: 14,
//                           )),
//                       Row(
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.edit, color: Colors.blue),
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => AddressFormScreen(
//                                     editAddressId: item['id'],
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                           IconButton(
//                               icon: const Icon(Icons.delete, color: Colors.red),
//                               onPressed: () {
//                                 _deleteSelectedAddress(item['id']);
//                               }
//                               // _deleteAddress(item['id']!),
//                               ),
//                         ],
//                       ),
//                       Divider(
//                         color: Colors.grey.shade300,
//                         height: 10,
//                       ),
//                     ]),
//                 trailing: Icon(
//                   isSelected
//                       ? Icons.radio_button_checked
//                       : Icons.radio_button_off,
//                   color: isSelected ? Colors.red : Colors.grey,
//                 ),
//                 onTap: () {
//                   setState(() => _selectedAddressId = item['id']);
//                 },
//               );
//             }),
//             const SizedBox(height: 20),
//             GestureDetector(
//               onTap: () {
//                 // Navigate to address form
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const AddressFormScreen()),
//                 );
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.red.shade600, width: 1.2),
//                   borderRadius: const BorderRadius.all(Radius.circular(12)),
//                   color: Colors.red.shade50.withOpacity(0.1),
//                 ),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // const SizedBox(width: 8),
//                     Text(
//                       'Add New Shipping Address',
//                       style: GoogleFonts.nunitoSans(
//                         color: Colors.red[600],
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             /// Save Button
//             CustomButton(
//               text: 'Save Changes',
//               onTap: _saveSelectedAddress,
//               isProcessing: _isProcessing,
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:Artisan/src/constants/colors.dart';
import 'package:Artisan/src/logic/services/preference_services.dart';
import 'package:Artisan/src/ui/auth/widgets/back_btn.dart';
import 'package:Artisan/src/ui/cart/address/addNewAddress.dart';
import 'package:Artisan/src/widgets/custom_button.dart';
import 'package:Artisan/src/widgets/custom_scaffold.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../logic/services/api_services/retrofit/auth_api_client/auth_api_client.dart';

class EditAddress extends ConsumerStatefulWidget {
  const EditAddress({super.key});

  @override
  ConsumerState<EditAddress> createState() => _EditAddressState();
}

class _EditAddressState extends ConsumerState<EditAddress> {
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

  Future<void> _deleteSelectedAddress(id) async {
    setState(() => _isProcessing = true);

    final url = Uri.parse('$_baseUrl/auth/address/remove');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': _token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'id': id}),
      );

      setState(() => _isProcessing = false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address deleted successfully!')),
        );

        Navigator.pop(context);
      } else {
        _showError('Failed to delete address: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      _showError('Error deleting address: $e');
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    // Responsive sizes
    final titleSize = width < 600 ? 22.0 : 28.0;
    final listTitleSize = width < 600 ? 14.0 : 20.0;
    final listSubtitleSize = width < 600 ? 14.0 : 18.0;
    final iconSize = width < 600 ? 20.0 : 26.0;
    final sectionSpacing = width < 600 ? 20.0 : 30.0;

    return CustomScaffold(
      topPadding: 0,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: width < 600 ? 20 : 35),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                children: [
                  BackBtn(
                    iconColor: Colors.black,
                    onTap: () => context.maybePop(),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "Saved Addresses",
                    style: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.w600,
                      color: bgDark,
                      fontSize: titleSize,
                    ),
                  ),
                ],
              ),

              SizedBox(height: sectionSpacing),

              if (_addressList.isEmpty && !_isProcessing)
                const Center(child: Text("No saved addresses found")),

              /// Address List
              ..._addressList.map((item) {
                final isSelected = _selectedAddressId == item['id'];

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? Colors.red : Colors.grey.shade300,
                      width: isSelected ? 1.6 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () =>
                        setState(() => _selectedAddressId = item['id']),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Address Title
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: isSelected ? Colors.red : bgDark,
                              size: iconSize,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                item['label']!,
                                style: GoogleFonts.nunitoSans(
                                  fontSize: listTitleSize,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: isSelected ? Colors.red : Colors.grey,
                              size: iconSize + 2,
                            ),
                          ],
                        ),

                        const SizedBox(height: 5),

                        Text(
                          "Name: ${item['fullName']}",
                          style: GoogleFonts.nunitoSans(
                            fontSize: listSubtitleSize,
                          ),
                        ),

                        Text(
                          "Mobile: ${item['contactNumber']}",
                          style: GoogleFonts.nunitoSans(
                            fontSize: listSubtitleSize,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit,
                                  color: Colors.blue, size: iconSize),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AddressFormScreen(
                                      editAddressId: item['id'],
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete,
                                  color: Colors.red, size: iconSize),
                              onPressed: () =>
                                  _deleteSelectedAddress(item['id']),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }),

              SizedBox(height: sectionSpacing),

              /// Add New Address
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AddressFormScreen()),
                  );
                },
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red.shade600),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.red.shade50.withOpacity(0.2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Add New Shipping Address",
                          style: GoogleFonts.nunitoSans(
                            color: Colors.red.shade600,
                            fontSize: width < 600 ? 16 : 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: sectionSpacing),

              /// Save Button
              Center(
                child: CustomButton(
                  text: "Save Changes",
                  onTap: _saveSelectedAddress,
                  isProcessing: _isProcessing,
                ),
              ),

              SizedBox(height: sectionSpacing),
            ],
          ),
        ),
      ),
    );
  }
}
