import 'package:flutter/material.dart';

class DealerRegistrationScreen extends StatefulWidget {
  const DealerRegistrationScreen({super.key});

  @override
  State<DealerRegistrationScreen> createState() => _DealerRegistrationScreenState();
}

class _DealerRegistrationScreenState extends State<DealerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Selected brands
  final List<String> _selectedBrands = ['TATA'];

  // List of available brands
  final List<String> _brands = [
    'TATA',
    'Hyundai',
    'Mahindra',
    'KIA',
    'Toyota',
    'Honda'
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Lato'),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6F9),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF005F65)),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Register as a Dealer',
            style: TextStyle(
              color: Color(0xFF005F65),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Progress Bar
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFF005F65),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFF005F65),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFF005F65), // 3rd step active
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Show Room Details'),
                  _buildLabel('Showroom / Business Name*'),
                  _buildTextField(hint: 'e.g Prime Motors'),
                  const SizedBox(height: 16),
                  
                  _buildLabel('Brand Dealt in'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ..._brands.map((brand) => _buildBrandChip(brand)),
                      _buildAddMoreChip(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  _buildLabel('Year In Business'),
                  _buildTextField(hint: 'e.g 8 years'),
                  const SizedBox(height: 24),

                  _buildSectionHeader('Owner / Contact Person'),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Full Name'),
                            _buildTextField(hint: 'owner name'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Designation'),
                            _buildTextField(hint: 'e.g. manager'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('Mobile Number'),
                  _buildTextField(hint: '+91 Enter Mobile Number', keyboardType: TextInputType.phone),
                  const SizedBox(height: 16),
                  _buildLabel('Email Address'),
                  _buildTextField(hint: 'business @email.com', keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 24),

                  _buildSectionHeader('Showroom Address'),
                  _buildLabel('Address Line'),
                  _buildTextField(hint: '', maxLines: 3),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('City'),
                            _buildTextField(hint: 'city'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Pincode'),
                            _buildTextField(hint: 'pincode', keyboardType: TextInputType.number),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('State'),
                  _buildTextField(hint: 'state'),
                  const SizedBox(height: 24),

                  _buildSectionHeader('Business Verification'),
                  _buildDocumentUploadCard(
                    title: 'GST Certificate',
                    subtitle: 'Required',
                  ),
                  const SizedBox(height: 12),
                  _buildDocumentUploadCard(
                    title: 'Dealership / Trade License',
                    subtitle: 'Required',
                  ),
                  const SizedBox(height: 24),

                  _buildSectionHeader('Showroom Photos'),
                  _buildPhotoUploadContainer(),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF005F65),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        _showSuccessDialog();
                      },
                      child: const Text(
                        'submit for verification',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF005F65),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFF005F65)),
        ),
      ),
    );
  }

  Widget _buildBrandChip(String label) {
    final isSelected = _selectedBrands.contains(label);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedBrands.remove(label);
          } else {
            _selectedBrands.add(label);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF005F65) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF005F65) : const Color(0xFFE0E0E0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF005F65),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildAddMoreChip() {
    return GestureDetector(
      onTap: () {
        // Handle add more brand logic
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: const Text(
          '+ Add more',
          style: TextStyle(
            color: Color(0xFF005F65),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentUploadCard({required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          const Icon(Icons.description_outlined, color: Color(0xFF005F65)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF005F65),
              side: const BorderSide(color: Color(0xFF005F65)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              minimumSize: const Size(80, 36),
            ),
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoUploadContainer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          style: BorderStyle.solid, 
        ),
      ),
      child: Column(
        children: const [
          Icon(Icons.image_outlined, color: Color(0xFF005F65), size: 32),
          SizedBox(height: 8),
          Text(
            'Upload showroom photos',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          Text(
            'PNG or JPG, up to 5 images',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Image.asset('assets/login_image/register_ticket.gif', width: 120, height: 120),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Verification Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A), // Dark blue
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Submitted Successfully',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00BFA5), // Greenish
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Thank you! Your dealer verification details have been submitted successfully',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 24),
                // Green support box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F8F1), // Very light green background
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFD6EFD6), // Slightly darker circle
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset('assets/onboarding_image/online-support 1.png', width: 24, height: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Our team will reach out to you within a few hours.',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Poppins'),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Please keep your phone handy.',
                              style: TextStyle(fontSize: 11, color: Colors.black54, fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Got It button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005F65),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                    },
                    child: const Text('Got It', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}
