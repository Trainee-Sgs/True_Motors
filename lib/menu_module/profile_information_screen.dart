import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileInformationScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final String? currentImagePath;
  final ValueChanged<String>? onImageChanged;

  const ProfileInformationScreen({
    super.key,
    this.scaffoldKey,
    this.currentImagePath,
    this.onImageChanged,
  });

  @override
  State<ProfileInformationScreen> createState() =>
      _ProfileInformationScreenState();
}

class _ProfileInformationScreenState
    extends State<ProfileInformationScreen> {
  final ImagePicker _picker = ImagePicker();

  // ── Basic Details ──────────────────────────────────────────────────────────
  String _name = '';
  String _phone = '';
  String _email = '';
  String? _profileImagePath;

  // ── Address ────────────────────────────────────────────────────────────────
  String _flatNo = '';
  String _landmark = '';
  String _streetName = '';
  String _city = '';

  // ── Edit states ───────────────────────────────────────────────────────────
  bool _isEditingBasic = false;
  bool _isEditingAddress = false;

  // ── Controllers for Basic Details inline edit ─────────────────────────────
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _emailCtrl;

  // ── Controllers for Address inline edit ───────────────────────────────────
  late TextEditingController _flatCtrl;
  late TextEditingController _landmarkCtrl;
  late TextEditingController _streetCtrl;
  late TextEditingController _cityCtrl;

  final _basicFormKey = GlobalKey<FormState>();
  final _addressFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _profileImagePath = widget.currentImagePath;
    _nameCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _flatCtrl = TextEditingController();
    _landmarkCtrl = TextEditingController();
    _streetCtrl = TextEditingController();
    _cityCtrl = TextEditingController();
    _loadData();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _flatCtrl.dispose();
    _landmarkCtrl.dispose();
    _streetCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? '';
      _phone = prefs.getString('phone') ?? '';
      _email = prefs.getString('email') ?? '';
      _flatNo = prefs.getString('flat_no') ?? '';
      _landmark = prefs.getString('landmark') ?? '';
      _streetName = prefs.getString('street_name') ?? '';
      _city = prefs.getString('city') ?? '';
    });
  }

  String _formatPhone(String phone) {
    if (phone.isEmpty) return '';
    if (phone.length == 10) {
      return '${phone.substring(0, 5)} ${phone.substring(5, 10)}';
    }
    return phone;
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked =
      await _picker.pickImage(source: source, imageQuality: 80);
      if (picked != null) {
        setState(() => _profileImagePath = picked.path);
        widget.onImageChanged?.call(picked.path);
      }
    } catch (e) {
      debugPrint('Image pick error: $e');
    }
  }

  void _showImagePickerDialog() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                    color: const Color(0xFFDDDDDD),
                    borderRadius: BorderRadius.circular(2)),
              ),
              const Text('Profile Photo',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              ListTile(
                leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE8F5E9),
                    child: Icon(Icons.camera_alt, color: Color(0xFF005F65))),
                title: const Text('Camera'),
                onTap: () { Navigator.pop(context); _pickImage(ImageSource.camera); },
              ),
              ListTile(
                leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE3F2FD),
                    child: Icon(Icons.photo_library, color: Color(0xFF1565C0))),
                title: const Text('Gallery'),
                onTap: () { Navigator.pop(context); _pickImage(ImageSource.gallery); },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    // Validate forms if edit mode is active
    if (_isEditingBasic) {
      if (!_basicFormKey.currentState!.validate()) return;
    }

    if (_isEditingAddress) {
      if (!_addressFormKey.currentState!.validate()) return;
    }

    final prefs = await SharedPreferences.getInstance();

    // Basic Details
    if (_isEditingBasic) {
      _name = _nameCtrl.text.trim();
      _phone = _phoneCtrl.text.trim();
      _email = _emailCtrl.text.trim().toLowerCase();

      await prefs.setString('name', _name);
      await prefs.setString('phone', _phone);
      await prefs.setString('email', _email);
    }

    // Address
    if (_isEditingAddress) {
      _flatNo = _flatCtrl.text.trim();
      _landmark = _landmarkCtrl.text.trim();
      _streetName = _streetCtrl.text.trim();
      _city = _cityCtrl.text.trim();

      await prefs.setString('flat_no', _flatNo);
      await prefs.setString('landmark', _landmark);
      await prefs.setString('street_name', _streetName);
      await prefs.setString('city', _city);
    }

    setState(() {
      _isEditingBasic = false;
      _isEditingAddress = false;
    });

    if (mounted) {
      Navigator.pop(context);
    }
  }

  // ── Input decoration helper ────────────────────────────────────────────────
  InputDecoration _inputDec(String label) => InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(fontSize: 14, color: Color(0xFF005F65)),
    floatingLabelStyle:
    const TextStyle(fontSize: 14, color: Color(0xFF005F65)),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFC4C4C4))),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFC4C4C4))),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide:
        const BorderSide(color: Color(0xFF005F65), width: 1.5)),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide:
        const BorderSide(color: Color(0xFFE53935), width: 1.5)),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide:
        const BorderSide(color: Color(0xFFE53935), width: 1.5)),
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  );

  // ── Section header with Edit button ───────────────────────────────────────
  Widget _sectionHeader(
      String title,
      bool isEditing,
      VoidCallback onEdit,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          GestureDetector(
            onTap: onEdit,
            child: const Icon(
              Icons.edit_outlined,
              color: Color(0xFF005F65),
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  // ── Read-only info row ────────────────────────────────────────────────────
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF000000))),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: value.isEmpty
                      ? const Color(0xFFAAAAAA)
                      : const Color(0xFF555555)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() =>
      const Divider(height: 1, thickness: 1, color: Color(0xFFC4C4C4));

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: Column(
          children: [
            Container(
                width: double.infinity,
                height: statusBarHeight,
                color: const Color(0xFF615C5C)),
            Expanded(
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    // ── AppBar ──────────────────────────────────────────────
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 18),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.arrow_back,
                                size: 24, color: Color(0xFF01442D)),
                          ),
                          const SizedBox(width: 12),
                          const Text('Profile Information',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF01422D))),
                        ],
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8,),
                            // ── Profile Avatar Card ───────────────────────
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: const Color(0xFFC4C4C4)),
                                ),
                                child: Row(
                                  children: [
                                    Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundColor:
                                          const Color(0xFFF0F0F0),
                                          backgroundImage: (_profileImagePath !=
                                              null &&
                                              _profileImagePath!.isNotEmpty)
                                              ? FileImage(
                                              File(_profileImagePath!))
                                              : null,
                                          child: (_profileImagePath == null ||
                                              _profileImagePath!.isEmpty)
                                              ? const Icon(Icons.person,
                                              size: 48,
                                              color: Color(0xFFAAAAAA))
                                              : null,
                                        ),
                                        Positioned(
                                          bottom: 0, right: 0,
                                          child: GestureDetector(
                                            onTap: _showImagePickerDialog,
                                            child: Container(
                                              width: 22, height: 22,
                                              decoration: BoxDecoration(
                                                  color:
                                                  const Color(0xFF005F65),
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 1.5)),
                                              child: const Icon(
                                                  Icons.camera_alt,
                                                  color: Colors.white,
                                                  size: 12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _name.isEmpty ? 'User' : _name,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _phone.isEmpty
                                                ? '+91 000-000'
                                                : '+91 ${_formatPhone(_phone)}',
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Color(0xFF000000)),
                                          ),
                                          if (_email.isNotEmpty)
                                            Text(_email,
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Color(0xFF000000))),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),
                            // ── Basic Details Section ─────────────────────
                            _sectionHeader(
                              'Basic Details',
                              _isEditingBasic,
                                  () {
                                _nameCtrl.text = _name;
                                _phoneCtrl.text = _phone;
                                _emailCtrl.text = _email;
                                setState(() => _isEditingBasic = true);
                              },
                            ),
                            const SizedBox(height: 20),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: const Color(0xFFC4C4C4)),
                              ),
                              child: _isEditingBasic
                                  ? Padding(
                                padding: const EdgeInsets.all(16),
                                child: Form(
                                  key: _basicFormKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        style: TextStyle(fontSize: 14),
                                        controller: _nameCtrl,
                                        decoration:
                                        _inputDec('Full Name'),
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .allow(RegExp(r'[a-zA-Z ]'))
                                        ],
                                        validator: (v) =>
                                        (v == null || v.trim().isEmpty)
                                            ? 'Enter name'
                                            : null,
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        style: TextStyle(fontSize: 14),
                                        controller: _phoneCtrl,
                                        decoration:
                                        _inputDec('Mobile Number'),
                                        keyboardType:
                                        TextInputType.phone,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(
                                              10),
                                        ],
                                        validator: (v) {
                                          if (v == null ||
                                              v.trim().isEmpty)
                                            return 'Enter mobile number';
                                          if (v.trim().length != 10)
                                            return 'Must be 10 digits';
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        style: TextStyle(fontSize: 14),
                                        controller: _emailCtrl,
                                        decoration:
                                        _inputDec('Email Address'),
                                        keyboardType:
                                        TextInputType.emailAddress,
                                        validator: (v) {
                                          if (v == null ||
                                              v.trim().isEmpty)
                                            return 'Enter email';
                                          if (!RegExp(
                                              r'^[\w\.-]+@gmail\.com$')
                                              .hasMatch(v.trim()))
                                            return 'Enter valid email';
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              )
                                  : Column(
                                children: [
                                  _infoRow('Full Name', _name),
                                  _infoRow('Mobile Number',
                                      _phone.isEmpty ? '' : '+91 ${_formatPhone(_phone)}'),
                                  _infoRow(
                                      'Email Address', _email),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // ── Address Section ───────────────────────────
                            _sectionHeader(
                              'Address',
                              _isEditingAddress,
                                  () {
                                _flatCtrl.text = _flatNo;
                                _landmarkCtrl.text = _landmark;
                                _streetCtrl.text = _streetName;
                                _cityCtrl.text = _city;
                                setState(() => _isEditingAddress = true);
                              },
                            ),
                            const SizedBox(height: 20),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: const Color(0xFFC4C4C4)),
                              ),
                              child: _isEditingAddress
                                  ? Padding(
                                padding: const EdgeInsets.all(16),
                                child: Form(
                                  key: _addressFormKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        style: TextStyle(fontSize: 14),
                                        controller: _flatCtrl,
                                        decoration:
                                        _inputDec('Flat No.'),
                                        validator: (v) =>
                                        (v == null || v.trim().isEmpty)
                                            ? 'Enter flat no.'
                                            : null,
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        style: TextStyle(fontSize: 14),
                                        controller: _landmarkCtrl,
                                        decoration:
                                        _inputDec('Landmark'),
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        style: TextStyle(fontSize: 14),
                                        controller: _streetCtrl,
                                        decoration:
                                        _inputDec('Street Name'),
                                        validator: (v) =>
                                        (v == null || v.trim().isEmpty)
                                            ? 'Enter street name'
                                            : null,
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        style: TextStyle(fontSize: 14),
                                        controller: _cityCtrl,
                                        decoration: _inputDec('City'),
                                        validator: (v) =>
                                        (v == null || v.trim().isEmpty)
                                            ? 'Enter city'
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                                  : Column(
                                children: [
                                  _infoRow('Flat No.', _flatNo),
                                  _infoRow('Landmark', _landmark),
                                  _infoRow('Street Name', _streetName),
                                  _infoRow('City', _city),
                                ],
                              ),
                            ),

                            _isEditingAddress ? SizedBox(height: 30) : SizedBox(height: 40,),

                            // ── Save Changes button ───────────────────────
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 75),
                              child: SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: _saveChanges,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    const Color(0xFF005F65),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                    elevation: 0,
                                  ),
                                  child: const Text('Save Changes',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}