import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:true_motors/menu_module/listing_manager.dart';

class SellerInformationScreen extends StatefulWidget {
  // All data passed from previous screens
  final String registrationNumber;
  final String vehicleType;
  final String brand;
  final String model;
  final String fuelType;
  final String transmission;
  final String regYear;
  final String kmDriven;
  final String location;
  final String rto;
  final String price;
  final String insuranceDate;
  final List<String> features;
  final List<File> images;
  final bool allowTestDrive;
  final String additionalInfo;

  const SellerInformationScreen({
    super.key,
    required this.registrationNumber,
    required this.vehicleType,
    required this.brand,
    required this.model,
    required this.fuelType,
    required this.transmission,
    required this.regYear,
    required this.kmDriven,
    required this.location,
    required this.rto,
    required this.price,
    required this.insuranceDate,
    required this.features,
    required this.images,
    required this.allowTestDrive,
    required this.additionalInfo,
  });

  @override
  State<SellerInformationScreen> createState() =>
      _SellerInformationScreenState();
}

class _SellerInformationScreenState extends State<SellerInformationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _additionalInfoController =
  TextEditingController();

  // Validation errors
  String? _nameError;
  String? _contactError;
  String? _cityError;

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _cityController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  bool _validate() {
    bool valid = true;
    setState(() {
      // Seller name
      if (_nameController.text.trim().isEmpty) {
        _nameError = 'Please enter your name';
        valid = false;
      } else if (_nameController.text.trim().length < 3) {
        _nameError = 'Name must be at least 3 characters';
        valid = false;
      } else {
        _nameError = null;
      }

      // Contact number
      final contact = _contactController.text.trim();
      if (contact.isEmpty) {
        _contactError = 'Please enter a contact number';
        valid = false;
      } else if (!RegExp(r'^[6-9]\d{9}$').hasMatch(contact)) {
        _contactError = 'Enter a valid 10-digit Indian mobile number';
        valid = false;
      } else {
        _contactError = null;
      }

      // City
      if (_cityController.text.trim().isEmpty) {
        _cityError = 'Please enter your city';
        valid = false;
      } else {
        _cityError = null;
      }
    });
    return valid;
  }

  void _onSubmit() {
    if (_validate()) {
      // Save listing to pending in ListingManager
      final listing = VehicleListing(
        id: ListingManager().generateId(),
        brand: widget.brand,
        model: widget.model,
        fuelType: widget.fuelType,
        transmission: widget.transmission,
        regYear: widget.regYear,
        kmDriven: widget.kmDriven,
        location: widget.location,
        rto: widget.rto,
        price: widget.price,
        insuranceDate: widget.insuranceDate,
        features: widget.features,
        images: widget.images,
        allowTestDrive: widget.allowTestDrive,
        additionalInfo: widget.additionalInfo,
        registrationNumber: widget.registrationNumber,
        vehicleType: widget.vehicleType,
        status: 'pending',
      );
      ListingManager().addListing(listing);
      _showSuccessDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields correctly'),
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Vehicle Listed Successfully!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF005F65)),
            ),
            const SizedBox(height: 8),
            Text(
              'Your ${widget.vehicleType} (${widget.registrationNumber}) has been listed. Our team will contact you shortly.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
        actions: [
          Center(
            child: SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // close dialog
                  Navigator.popUntil(
                      context, (route) => route.isFirst); // go to home
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005F65),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Go to Home',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F3F3),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPromoBanner(),
                    SizedBox(
                      height: 15,
                    ),
                    // Page title
                    const Text(
                      'Seller Information',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF000000)),
                    ),
                    const SizedBox(height: 20),

                    // ── Seller Name ───────────────────────────────────────
                    _buildSectionLabel('Seller Name'),
                    _buildTextField(
                      controller: _nameController,
                      hint: 'Enter your full name',
                      error: _nameError,
                      keyboardType: TextInputType.name,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]')),
                      ],
                      onChanged: (_) => setState(() => _nameError = null),
                    ),

                    // ── Contact Number ────────────────────────────────────
                    _buildSectionLabel('Contact Number'),
                    _buildTextField(
                      controller: _contactController,
                      hint: 'Enter 10-digit mobile number',
                      error: _contactError,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (_) => setState(() => _contactError = null),
                    ),

                    // ── City ──────────────────────────────────────────────
                    _buildSectionLabel('City'),
                    _buildTextField(
                      controller: _cityController,
                      hint: 'Enter your city',
                      error: _cityError,
                      keyboardType: TextInputType.text,
                      onChanged: (_) => setState(() => _cityError = null),
                    ),

                    // ── Additional Info (Optional) ────────────────────────
                    _buildSectionLabel('Additional Info (Optional)'),
                    TextField(
                      controller: _additionalInfoController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Any additional notes',
                        hintStyle: const TextStyle(
                            color: Colors.grey, fontSize: 13),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                          BorderSide(color: Color(0xFFA7A7A7)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                          BorderSide(color: Color(0xFFA7A7A7)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                          const BorderSide(color: Color(0xFF005F65)),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: 50),

                    // ── Navigation buttons ────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding:
                              const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(
                                  color: Color(0xFF005F65)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text(
                              'Previous',
                              style: TextStyle(
                                  color: Color(0xFF005F65),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _onSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF005F65),
                              padding:
                              const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back,
                size: 24, color: Color(0xFF01422D)),
          ),
          const SizedBox(width: 16),
          const Text('Seller Information',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF01422D))),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF052243),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
            child: Image.asset(
              'assets/sell_image/red_car.png',
              width: 140,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 16, bottom: 16, left: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: const Text(
                      'Sell your car instantly',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Calistoga',
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: const Text(
                      'Best price.Free inspection',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Calistoga',
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Get Free Quote',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Calistoga',
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String? error,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
          const TextStyle(color: Color(0xFFB4B4B4), fontSize: 14),
          errorText: error,
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFFE2E2E2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
                color: error != null ? Colors.red : Color(0xFFE2E2E2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: error != null ? Colors.red : const Color(0xFF005F65),
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    );
  }
}