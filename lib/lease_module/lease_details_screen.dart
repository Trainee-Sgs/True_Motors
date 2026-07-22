import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:true_motors/lease_module/pricing_details_screen.dart';

class LeaseDetailsScreen extends StatefulWidget {
  final String vehicleType;
  final String brand;
  final String model;
  final String fuelType;
  final String transmission;
  final String year;
  final String kmDriven;
  final List<String> imagePaths;
  final String additionalInfo;
  final String state;
  final String city;
  final String area;
  final String rcPath;
  final String insurancePath;
  final String pollutionPath;

  const LeaseDetailsScreen({
    super.key,
    required this.vehicleType,
    required this.brand,
    required this.model,
    required this.fuelType,
    required this.transmission,
    required this.year,
    required this.kmDriven,
    required this.imagePaths,
    required this.additionalInfo,
    required this.state,
    required this.city,
    required this.area,
    required this.rcPath,
    required this.insurancePath,
    required this.pollutionPath,
  });

  @override
  State<LeaseDetailsScreen> createState() => _LeaseDetailsScreenState();
}

class _LeaseDetailsScreenState extends State<LeaseDetailsScreen> {
  // ── Selected values ─────────────────────────────────────────────────────
  String? _selectedLeaseType;
  String? _selectedLeaseDuration;
  final TextEditingController _noticePeriodController =
  TextEditingController();
  final TextEditingController _availableFromController =
  TextEditingController();

  // ── Which dropdown is currently open ──────────────────────────────────────
  String? _openDropdown;

  // ── Lists ──────────────────────────────────────────────────────────────────
  final List<String> _leaseTypes = const [
    'Self-Drive Lease',
    'Lease with Driver',
    'Corporate Lease',
    'Long Term Lease',
  ];

  final List<String> _leaseDurations = const [
    '1 Month',
    '3 Months',
    '6 Months',
    '1 Year',
    '2 Years',
    '3 Years',
  ];

  @override
  void dispose() {
    _noticePeriodController.dispose();
    _availableFromController.dispose();
    super.dispose();
  }

  void _toggleDropdown(String key) {
    setState(() => _openDropdown = _openDropdown == key ? null : key);
  }

  bool _validate() {
    bool valid = true;
    setState(() {
      if (_selectedLeaseType == null) valid = false;
      if (_selectedLeaseDuration == null) valid = false;
      if (_availableFromController.text.trim().isEmpty) valid = false;
    });
    return valid;
  }

  void _onSaveAndNext() {
    FocusScope.of(context).unfocus();
    setState(() => _openDropdown = null);

    if (!_validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill all fields',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Color(0xFF323232),
          behavior: SnackBarBehavior.fixed,
          duration: Duration(seconds: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PricingDetailsScreen(
          vehicleType: widget.vehicleType,
          brand: widget.brand,
          model: widget.model,
          fuelType: widget.fuelType,
          transmission: widget.transmission,
          year: widget.year,
          kmDriven: widget.kmDriven,
          imagePaths: widget.imagePaths,
          additionalInfo: widget.additionalInfo,
          state: widget.state,
          city: widget.city,
          area: widget.area,
          rcPath: widget.rcPath,
          insurancePath: widget.insurancePath,
          pollutionPath: widget.pollutionPath,
          leaseType: _selectedLeaseType!,
          leaseDuration: _selectedLeaseDuration!,
          noticePeriod: _noticePeriodController.text.trim(),
          availableFrom: _availableFromController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() => _openDropdown = null);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F2),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(width),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Lease Details',
                        style: TextStyle(
                          color: Color(0xFF01422D),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      const Text(
                        'Set your lease preference',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      SizedBox(height: height * 0.02),

                      // ── Lease Type ──────────────────────────────────────
                      _buildLabeledDropdown(
                        keyId: 'leaseType',
                        label: 'Lease Type',
                        placeholder: 'Select Lease Type',
                        value: _selectedLeaseType,
                        items: _leaseTypes,
                        width: width,
                        onSelected: (v) => setState(() {
                          _selectedLeaseType = v;
                          _openDropdown = null;
                        }),
                      ),

                      // ── Lease Duration ──────────────────────────────────
                      _buildLabeledDropdown(
                        keyId: 'leaseDuration',
                        label: 'Lease Duration',
                        placeholder: 'Select Lease Duration',
                        value: _selectedLeaseDuration,
                        items: _leaseDurations,
                        width: width,
                        onSelected: (v) => setState(() {
                          _selectedLeaseDuration = v;
                          _openDropdown = null;
                        }),
                      ),

                      // ── Notice Period (Optional) ───────────────────────
                      _buildLabeledTextField(
                        label: 'Notice Period (Optional)',
                        controller: _noticePeriodController,
                        placeholder: 'Enter Notice Period Time',
                        width: width,
                      ),

                      // ── Available From ──────────────────────────────────
                      _buildLabeledTextField(
                        label: 'Available From',
                        controller: _availableFromController,
                        placeholder: 'Select Date',
                        width: width,
                        readOnly: true,
                        suffixIcon: const Icon(Icons.calendar_month_outlined,
                            color: Color(0xFF742B88), size: 20),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate:
                            DateTime.now().add(const Duration(days: 3650)),
                            builder: (ctx, child) => Theme(
                              data: Theme.of(ctx).copyWith(
                                colorScheme: const ColorScheme.light(
                                    primary: Color(0xFF005F65)),
                              ),
                              child: child!,
                            ),
                          );
                          if (picked != null) {
                            setState(() {
                              _availableFromController.text =
                              '${picked.day}/${picked.month}/${picked.year}';
                            });
                          }
                        },
                      ),

                      SizedBox(height: height * 0.25),

                      // ── Previous & Save and Next buttons ──────────────────
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding:
                                const EdgeInsets.symmetric(vertical: 12),
                                side: const BorderSide(
                                    color: Color(0xFF005F65), width: 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text(
                                'Previous',
                                style: TextStyle(
                                  color: Color(0xFF005F65),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.04),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _onSaveAndNext,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF005F65),
                                padding:
                                const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Save & Next',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.04),
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

  // ── App bar ────────────────────────────────────────────────────────────────
  Widget _buildAppBar(double width) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back,
                size: width * 0.06, color: const Color(0xFF01422D)),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'Add New Vehicle',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF01422D),
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  // ── Labeled dropdown (always-visible label above field, per Figma) ─────────
  Widget _buildLabeledDropdown({
    required String keyId,
    required String label,
    required String placeholder,
    required String? value,
    required List<String> items,
    required double width,
    required ValueChanged<String> onSelected,
  }) {
    final isOpen = _openDropdown == keyId;
    final hasValue = value != null;

    return Container(
      margin: EdgeInsets.only(bottom: width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: width * 0.02),
          GestureDetector(
            onTap: () {
              if (items.isEmpty) return;
              FocusScope.of(context).unfocus();
              _toggleDropdown(keyId);
            },
            child: Container(
              height: width * 0.12,
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isOpen
                      ? const Color(0xFF005F65)
                      : const Color(0xFFE2E2E2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      hasValue ? value : placeholder,
                      style: TextStyle(
                        fontSize: width * 0.035,
                        color:
                        hasValue ? Colors.black : const Color(0xFFB4B4B4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: const Color(0xFF742B88),
                  ),
                ],
              ),
            ),
          ),
          if (isOpen && items.isNotEmpty)
            Container(
              margin: EdgeInsets.only(top: width * 0.02),
              constraints: BoxConstraints(maxHeight: width * 0.6),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                border: Border.all(color: const Color(0xFFE2E2E2)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  return InkWell(
                    onTap: () => onSelected(item),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.03,
                        vertical: width * 0.03,
                      ),
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: width * 0.035,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  // ── Labeled text field (always-visible label above field) ──────────────────
  Widget _buildLabeledTextField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    required double width,
    String? error,
    bool readOnly = false,
    Widget? suffixIcon,
    String? prefixText,
    String? suffixText,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    ValueChanged<String>? onChanged,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: width * 0.02),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            onTap: onTap,
            style: TextStyle(
              fontSize: width * 0.035,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: placeholder,
              hintStyle: TextStyle(
                fontSize: width * 0.035,
                color: const Color(0xFFB4B4B4),
              ),
              prefixText: prefixText,
              suffixText: suffixText,
              errorText: error,
              errorStyle: const TextStyle(fontSize: 12),
              suffixIcon: suffixIcon,
              contentPadding: EdgeInsets.symmetric(
                horizontal: width * 0.03,
                vertical: width * 0.035,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: error != null
                      ? const Color(0xFFB00020)
                      : const Color(0xFFE2E2E2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF005F65)),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFB00020)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFB00020)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}