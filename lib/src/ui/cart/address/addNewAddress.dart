import 'dart:convert';
import 'package:Artisan/src/constants/colors.dart';
import 'package:Artisan/src/logic/services/api_services/retrofit/auth_api_client/auth_api_client.dart';
import 'package:Artisan/src/logic/services/preference_services.dart';
import 'package:Artisan/src/ui/auth/widgets/back_btn.dart';
import 'package:Artisan/src/widgets/custom_button.dart';
import 'package:Artisan/src/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

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
  final String _baseUrl = apiBaseUrl;

  LatLng? _selectedLocation;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    if (widget.editAddressId != null) {
      _loadAddressDetails(widget.editAddressId!);
    } else {
      _initLocation();
    }
  }

  Future<void> _initLocation() async {
    try {
      final hasPermission = await _handleLocationPermission();
      if (!hasPermission) return;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final location = LatLng(position.latitude, position.longitude);
      setState(() {
        _selectedLocation = location;
      });

      // Fill address fields initially
      await _updateAddressFromLatLng(location);
    } catch (e) {
      _showError('Error getting location: $e');
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showError('Location services are disabled. Please enable them.');
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showError('Location permission denied.');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showError(
          'Location permissions are permanently denied. Please enable them from settings.');
      return false;
    }

    return true;
  }

  Future<void> _updateAddressFromLatLng(LatLng? location) async {
    if (location == null) {
      print('Location is null, cannot reverse geocode');
      return;
    }

    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(location.latitude, location.longitude);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        print('--- Reverse Geocoding Result ---');
        print('Name: ${place.name ?? ''}');
        print('Street: ${place.street ?? ''}');
        print('Locality / City: ${place.locality ?? ''}');
        print('SubLocality: ${place.subLocality ?? ''}');
        print('AdministrativeArea / State: ${place.administrativeArea ?? ''}');
        print('SubAdministrativeArea: ${place.subAdministrativeArea ?? ''}');
        print('Postal Code: ${place.postalCode ?? ''}');
        print('Country: ${place.country ?? ''}');
        print('ISO Country Code: ${place.isoCountryCode ?? ''}');
        print('Thoroughfare: ${place.thoroughfare ?? ''}');
        print('SubThoroughfare: ${place.subThoroughfare ?? ''}');
        print('--------------------------------');

        setState(() {
          // _streetController.text = (place.street ?? '').trim();
          _streetController.text = [place.street, place.subLocality]
              .where((e) => e != null && e.isNotEmpty)
              .join(', ')
              .trim();
          _cityController.text = (place.locality ?? '').trim();
          _stateController.text = (place.administrativeArea ?? '').trim();
          _countryController.text = (place.country ?? '').trim();
          _postalCodeController.text = (place.postalCode ?? '').trim();
        });
      } else {
        print('No placemarks found for the location.');
      }
    } catch (e) {
      _showError("Error getting address: $e");
      print('Error in _updateAddressFromLatLng: $e');
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

        if (data['latitude'] != null && data['longitude'] != null) {
          final location = LatLng(
            double.tryParse(data['latitude'].toString()) ?? 0.0,
            double.tryParse(data['longitude'].toString()) ?? 0.0,
          );
          setState(() {
            _selectedLocation = location;
          });
        } else {
          _initLocation();
        }
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
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    final token =
        ref.read(preferenceServiceProvider).getString("auth_token") ?? '';
    final isEdit = widget.editAddressId != null;

    final latitude = _selectedLocation?.latitude;
    final longitude = _selectedLocation?.longitude;

    if (latitude == null || longitude == null) {
      _showError('Please select a location on the map');
      return;
    }

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
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
    };

    if (isEdit) body["id"] = widget.editAddressId!;

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
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      topPadding: 0,
      child: Stack(children: [
        SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 15, 25, 10),
                  child: Row(
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
                          maxLength: 10,
                          minLength: 3,
                        ),
                        const SizedBox(height: 16),
                        buildInputField(_fullNameController, 'Full Name'),
                        const SizedBox(height: 16),
                        buildInputField(
                          _mobileController,
                          'Mobile Number',
                          inputType: TextInputType.number,
                          minLength: 8,
                          maxLength: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Google Map with draggable marker
                if (_selectedLocation != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: SizedBox(
                      height: 250,
                      child: GoogleMap(
                        zoomGesturesEnabled: true,
                        zoomControlsEnabled: true,
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          target: _selectedLocation!,
                          zoom: 15,
                        ),
                        onMapCreated: (controller) =>
                            _mapController = controller,
                        markers: {
                          Marker(
                            consumeTapEvents: true,
                            markerId: const MarkerId('selected-location'),
                            position: _selectedLocation!,
                            draggable: true,
                            onDragEnd: (newPosition) async {
                              setState(() {
                                _selectedLocation = newPosition;
                              });
                              await _updateAddressFromLatLng(newPosition);
                            },
                          ),
                        },
                        onTap: (newPosition) async {
                          setState(() {
                            _selectedLocation = newPosition;
                          });
                          await _updateAddressFromLatLng(newPosition);
                        },
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                      ),
                    ),
                  ),
                ] else
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),

                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomButton(
                    isProcessing: _isSaving,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        _saveAddress();
                      }
                    },
                    text: 'Save Changes',
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
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
