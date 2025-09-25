import 'dart:io';
import 'package:Artisan/src/logic/repositories/auth_repository.dart';
import 'package:Artisan/src/logic/services/api_services/retrofit/auth_api_client/auth_api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  File? _selectedImage;
  bool _isLoading = false;

  final String _baseUrl = apiBaseUrl;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authRepositoryProvider).authUser?.userData;
      _nameController.text = user?.fullName ?? '';
      _emailController.text = user?.email ?? '';
      _phoneController.text = user?.phone ?? '';
    });
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<void> _saveProfile(BuildContext context) async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final token = ref.read(authRepositoryProvider).authUser?.token ?? "";

    // final url = Uri.parse('$_baseUrlauth+/update/profile');
    final url = Uri.parse('/auth/update/profile');

    setState(() => _isLoading = true);

    var request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = token
      ..fields['fullName'] = name
      ..fields['email'] = email
      ..fields['phone'] = phone;

    if (_selectedImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        _selectedImage!.path,
        filename: basename(_selectedImage!.path),
      ));
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        if (!mounted) Navigator.pop(context);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Update failed: ${response.body}")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authRepositoryProvider).authUser?.userData;
    final profilePic = _selectedImage != null
        ? FileImage(_selectedImage!)
        : (user?.profilePic != null && user!.profilePic!.isNotEmpty
            ? NetworkImage(user.profilePic!)
            : const AssetImage('assets/default_profile.png')) as ImageProvider;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEBDCFD), Color(0xFFE0F5F0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              /// AppBar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 24),
                    Text(
                      'Edit Profile',
                      style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                    _isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : GestureDetector(
                            onTap: () => _saveProfile(context),
                            child: Text(
                              'Save',
                              style: GoogleFonts.nunitoSans(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                  ],
                ),
              ),

              /// Profile Picture
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: profilePic,
                    ),
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child:
                          Icon(Icons.camera_alt, size: 18, color: Colors.black),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// Form Fields
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      buildLabel("Name"),
                      buildInputField(_nameController),
                      const SizedBox(height: 16),
                      buildLabel("Email"),
                      buildInputField(_emailController),
                      const SizedBox(height: 16),
                      buildLabel("Phone Number"),
                      buildInputField(_phoneController),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: GoogleFonts.nunitoSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget buildInputField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.nunitoSans(fontSize: 16),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.6),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
